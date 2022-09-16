package io.upgrade

import android.app.Activity
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.graphics.Bitmap
import android.graphics.Canvas
import android.graphics.drawable.Drawable
import android.net.Uri
import android.os.Build
import android.provider.Settings
import android.text.TextUtils
import android.util.Base64
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
  private lateinit var mContext: Context
  private lateinit var mActivity: Activity

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, channelName)
    channel.setMethodCallHandler(this)

    mContext = flutterPluginBinding.applicationContext
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    when (call.method) {
      "getDownloadPath" -> result.success("${mContext.cacheDir.path}${File.separator}libCacheApkDownload${File.separator}")
      "installApk" -> {
        try {
          installApk(call.arguments<String>())
          result.success(true)
        } catch (e: Throwable) {
          result.error(e.javaClass.simpleName, e.message, null)
        }
      }
      "getMarkets" -> result.success(getMarkets(call.arguments<List<String>>()))
      "jumpToMarket" -> jumpToMarket(call.arguments as String?)
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

    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O
        && Build.VERSION.SDK_INT < Build.VERSION_CODES.Q
        && !pm().canRequestPackageInstalls()) {
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
      val authority = "${mContext.packageName}.UpgradeUtilPlugin.fileprovider"
      FileProvider.getUriForFile(mContext, authority, file)
    } else {
      Uri.fromFile(file)
    }
    intent.setDataAndType(uri, downloadType)
    mContext.startActivity(intent)
  }

  @RequiresApi(Build.VERSION_CODES.O)
  private fun showSettingPackageInstall() {
    val intent = Intent(Settings.ACTION_MANAGE_UNKNOWN_APP_SOURCES)
    intent.data = Uri.parse("package:" + mContext.packageName)
    mActivity.startActivityForResult(intent, installRequestCode)
  }

  /**
   * Get the software information of the application market included in the mobile phone.
   *
   * @param packages List of package names to verify
   */
  private fun getMarkets(packages: List<String>?): ArrayList<Map<String, String>> {
    val pkgs = ArrayList<Map<String, String>>()
    packages?.forEach {
      if (isAppExist(it)) {
        val info = pm().getPackageInfo(it, 0)
        pkgs.add(
          mapOf(
            "packageName" to it,
            "showName" to info.applicationInfo.loadLabel(pm()).toString(),
            "icon" to drawableToBitmap(pm().getApplicationIcon(info.packageName))
          )
        )
      }
    }
    return pkgs
  }

  private fun drawableToBitmap(drawable: Drawable): String {
    val bitmap = Bitmap.createBitmap(
      drawable.intrinsicWidth,
      drawable.intrinsicHeight,
      Bitmap.Config.ARGB_8888
    )
    val canvas = Canvas(bitmap)
    drawable.setBounds(0, 0, canvas.width, canvas.height)
    drawable.draw(canvas)

    val byteArrayOutputStream = ByteArrayOutputStream()
    bitmap.compress(Bitmap.CompressFormat.PNG, 100, byteArrayOutputStream)
    return Base64.encodeToString(byteArrayOutputStream.toByteArray(), Base64.NO_WRAP)
  }

  /**
   * Determine if an app is installed
   *
   * @param packageName The package name of the software.
   * @return Boolean
   */
  private fun isAppExist(packageName: String): Boolean {
    return try {
      pm().getPackageInfo(packageName, 0)
      true
    } catch (e: PackageManager.NameNotFoundException) {
      false
    }
  }

  /**
   * Jump to market
   *
   * @param marketPackageName The package name of market.
   */
  private fun jumpToMarket(marketPackageName: String?) {
    try {
      val uri = Uri.parse("${getUriString(marketPackageName)}${mContext.packageName}")
      val intent = Intent(Intent.ACTION_VIEW, uri)
      intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
      if (!TextUtils.isEmpty(marketPackageName)) intent.setPackage(marketPackageName)
      mContext.startActivity(intent)
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
    return mContext.packageManager
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  companion object {
    private const val channelName = "upgrade_util.io.channel/method"
    private const val downloadType = "application/vnd.android.package-archive"

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
