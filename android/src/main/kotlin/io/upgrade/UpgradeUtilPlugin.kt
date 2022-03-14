package io.upgrade

import android.app.Activity
import android.content.Intent
import android.content.pm.PackageManager
import android.net.Uri
import android.os.Build
import android.provider.Settings
import android.text.TextUtils
import androidx.annotation.NonNull
import androidx.core.content.FileProvider

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import java.io.File
import java.io.FileNotFoundException
import java.util.ArrayList

/** UpgradeUtilPlugin */
class UpgradeUtilPlugin : FlutterPlugin, MethodCallHandler, ActivityAware {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel: MethodChannel
  private lateinit var mActivity: Activity

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, channelName)
    channel.setMethodCallHandler(this)

    flutterPluginBinding.platformViewRegistry.registerViewFactory(viewName, MarketViewFactory())
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    when (call.method) {
      "getPlatformVersion" -> result.success("Android ${android.os.Build.VERSION.RELEASE}")
      "apkDownloadPath" -> result.success(mActivity.cacheDir.path)
      "installApk" -> {
        val path = call.argument<String>("path")
        path?.also {
          try {
            installApk(path)
            result.success(true)
          } catch (e: Throwable) {
            result.error(e.javaClass.simpleName, e.message, null)
          }
        }
      }
      "availableMarket" -> {
        val packages = call.argument<List<String>>("packages")
        result.success(getMarkets(packages))
      }
      "jumpToMarket" -> {
        val packageName = call.argument<String>("packageName")
        val marketPackageName = call.argument<String>("marketPackageName")
        jumpToMarket(packageName, marketPackageName)
      }
      else -> result.notImplemented()
    }
  }

  /**
   * Install Apk
   *
   * @param path The storage address of apk.
   * @return Boolean
   */
  private fun installApk(path: String) {
    val file = File(path)
    if (!file.exists()) throw FileNotFoundException("$path is not exist! or check permission")

    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
      if (canRequestPackageInstalls()) install24(file)
      else {
        showSettingPackageInstall()
        apkFile = file
      }
    } else {
      installBelow24(Uri.fromFile(file))
    }
  }

  private fun canRequestPackageInstalls(): Boolean {
    return Build.VERSION.SDK_INT <= Build.VERSION_CODES.O || pm().canRequestPackageInstalls()
  }

  private fun showSettingPackageInstall() { // todo to test with android 26
    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
      val intent = Intent(Settings.ACTION_MANAGE_UNKNOWN_APP_SOURCES)
      intent.data = Uri.parse("package:" + mActivity.packageName)
      mActivity.startActivityForResult(intent, installRequestCode)
    } else {
      throw RuntimeException("VERSION.SDK_INT < O")
    }
  }

  private fun installBelow24(uri: Uri?) {
    val intent = Intent(Intent.ACTION_VIEW)
    intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
    intent.setDataAndType(uri, downloadType)
    mActivity.startActivity(intent)
  }

  private fun install24(file: File?) {
    if (file == null) throw NullPointerException("file is null!")

    val intent = Intent(Intent.ACTION_VIEW)
    intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
    intent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
    val authority = "${mActivity.packageName}.UpgradeUtilPlugin.fileprovider"
    val uri: Uri = FileProvider.getUriForFile(mActivity, authority, file)
    intent.setDataAndType(uri, downloadType)
    mActivity.startActivity(intent)
  }

  /**
   * Gets a list of installed app market package names
   *
   * @param packages List of package names to verify
   * @return List<String>
   */
  private fun getMarkets(packages: List<String>?): List<Map<String, String>> {
    val pkgs = ArrayList<Map<String, String>>()
    packages?.also {
      for (i in packages.indices) {
        val packageName = packages[i]
        if (isAppExist(packageName)) {
          val info = pm().getApplicationInfo(packageName, PackageManager.GET_META_DATA)
          val label = pm().getApplicationLabel(info).toString()
          pkgs.add(
            mapOf(
              "packageName" to packageName,
              "showName" to label
            )
          )
        }
      }
    }
    return pkgs
  }

  /**
   * Determine if an app is installed
   *
   * @param packageName The package name of the software.
   * @return Boolean
   */
  private fun isAppExist(packageName: String): Boolean {
    if (!TextUtils.isEmpty(packageName)) {
      val list = pm().getInstalledPackages(0)
      for (info in list) {
        if (packageName.equals(info.packageName, ignoreCase = true)) {
          return true
        }
      }
    }
    return false
  }

  /**
   * Jump to market
   *
   * @param packageName The package name of the application
   * @param marketPackageName The package name of market.
   * @return Boolean
   */
  private fun jumpToMarket(packageName: String?, marketPackageName: String?) {
    return try {
      val mPackageInfo = pm().getPackageInfo(mActivity.packageName, 0)
      val mPackageName = packageName ?: mPackageInfo.packageName
      val uri = Uri.parse("${getUriString(marketPackageName)}${mPackageName}")
      val intent = Intent(Intent.ACTION_VIEW, uri)
      intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
      if (!TextUtils.isEmpty(marketPackageName)) intent.setPackage(marketPackageName)
      mActivity.startActivity(intent)
    } catch (e: Exception) {
      e.printStackTrace()
    }
  }

  /**
   * Distinguish Samsung's Uri.
   *
   * @param packageName The package name of the software.
   * @return String
   */
  private fun getUriString(packageName: String?): String {
    return if (packageName == "com.sec.android.app.samsungapps") {
      "http://www.samsungapps.com/appquery/appDetail.as?appId="
    } else {
      "market://details?id="
    }
  }

  private fun pm(): PackageManager {
    return mActivity.packageManager
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  companion object {
    const val channelName = "upgrade_util.io.channel/method"
    const val viewName = "upgrade_util.io.view/android"
    const val downloadType = "application/vnd.android.package-archive"

    private const val installRequestCode = 9989
    private var apkFile: File? = null
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    mActivity = binding.activity

    binding.addActivityResultListener { requestCode, resultCode, intent ->
      if (resultCode == Activity.RESULT_OK && requestCode == installRequestCode) {
        install24(apkFile)
        true
      } else
        false
    }
  }

  override fun onDetachedFromActivityForConfigChanges() {}

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {}

  override fun onDetachedFromActivity() {}
}
