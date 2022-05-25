package io.upgrade

import android.app.Activity
import android.content.Intent
import android.content.pm.PackageManager
import android.graphics.Bitmap
import android.graphics.drawable.BitmapDrawable
import android.net.Uri
import android.os.Build
import android.provider.Settings
import android.text.TextUtils
import androidx.annotation.NonNull
import androidx.annotation.RequiresApi
import androidx.core.content.FileProvider
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import java.io.ByteArrayOutputStream
import java.io.File
import java.io.FileNotFoundException

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

    flutterPluginBinding.platformViewRegistry.registerViewFactory(
      viewName,
      MarketViewFactory(flutterPluginBinding.binaryMessenger)
    )
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    when (call.method) {
      "getPlatformVersion" -> result.success("Android ${Build.VERSION.RELEASE}")
      "getDownloadPath" -> result.success("${mActivity.cacheDir.path}${File.separator}libCacheApkDownload${File.separator}")
      "installApk" -> {
        try {
          installApk(call.arguments<String>())
          result.success(true)
        } catch (e: Throwable) {
          result.error(e.javaClass.simpleName, e.message, null)
        }
      }
      "getMarkets" -> result.success(getMarkets(call.arguments<List<String>>()))
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
  private fun installApk(path: String?) {
    if (path == null) throw NullPointerException("The path of file is null!")

    val file = File(path)
    if (!file.exists()) throw FileNotFoundException("$path is not exist or check permission")

    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O && !pm().canRequestPackageInstalls()) {
      showSettingPackageInstall()
      apkFile = file
    } else {
      install(file)
    }
  }

  private fun install(file: File?) {
    if (file == null) throw NullPointerException("The file is null!")

    val intent = Intent(Intent.ACTION_VIEW)
    intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)

    val uri: Uri = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
      intent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
      val authority = "${mActivity.packageName}.UpgradeUtilPlugin.fileprovider"
      FileProvider.getUriForFile(mActivity, authority, file)
    } else {
      Uri.fromFile(file)
    }
    intent.setDataAndType(uri, downloadType)
    mActivity.startActivity(intent)
  }

  @RequiresApi(Build.VERSION_CODES.O)
  private fun showSettingPackageInstall() {
    val intent = Intent(Settings.ACTION_MANAGE_UNKNOWN_APP_SOURCES)
    intent.data = Uri.parse("package:" + mActivity.packageName)
    mActivity.startActivityForResult(intent, installRequestCode)
  }

  /**
   * Get a list of software information from the installed application market.
   *
   * @param packages List of package names to verify
   * @return List<Map<String, Any>>
   */
  private fun getMarkets(packages: List<String>?): List<Map<String, Any>> {
    val pkgs = ArrayList<Map<String, Any>>()
    packages?.also {
      for (i in packages.indices) {
        val packageName = packages[i]
        if (isAppExist(packageName)) {
          val info = pm().getApplicationInfo(packageName, PackageManager.GET_META_DATA)
          val label = pm().getApplicationLabel(info).toString()
          val bitmap = (pm().getApplicationIcon(info) as BitmapDrawable).bitmap
          val icon = ByteArrayOutputStream()
          bitmap.compress(Bitmap.CompressFormat.PNG, 100, icon)
          pkgs.add(
            mapOf(
              "packageName" to packageName,
              "showName" to label,
              "icon" to icon.toByteArray()
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
      return pm().getInstalledPackages(0)
        .any { packageName.equals(it.packageName, ignoreCase = true) }
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

    binding.addActivityResultListener { requestCode, resultCode, _ ->
      if (resultCode == Activity.RESULT_OK && requestCode == installRequestCode) {
        install(apkFile)
        true
      } else
        false
    }
  }

  override fun onDetachedFromActivityForConfigChanges() {}

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {}

  override fun onDetachedFromActivity() {}
}
