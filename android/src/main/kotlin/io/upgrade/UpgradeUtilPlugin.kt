package io.upgrade

import android.content.Context
import android.content.pm.PackageManager
import android.os.Build
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** UpgradeUtilPlugin */
class UpgradeUtilPlugin : FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel: MethodChannel
  private lateinit var mContext: Context

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, CHANNEL_NAME)
    channel.setMethodCallHandler(this)

    mContext = flutterPluginBinding.applicationContext
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    when (call.method) {
      "getPlatformVersion" -> result.success("Android ${Build.VERSION.RELEASE}")
      "getPackageName" -> result.success(mContext.packageName)
      "hasStore" -> result.success(hasStore(call.arguments.toString()))
      else -> result.notImplemented()
    }
  }

  /**
   * Determine if the store is installed.
   */
  private fun hasStore(packageName: String): Boolean {
    val value = when (packageName) {
      "google" -> "com.android.vending"
      "huawei" -> "com.huawei.appmarket"
      "honor" -> "com.hihonor.appmarket"
      "xiaomi" -> "com.xiaomi.market"
      "oppo" -> if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) "com.heytap.market" else "com.oppo.market"
      "vivo" -> "com.bbk.appstore"
      "meizu" -> "com.meizu.mstore"
      "tencent" -> "com.tencent.android.qqdownloader"
      "baidu" -> "com.baidu.appsearch"
      else -> ""
    }
    return isAppExist(value)
  }

  /**
   * Determine if an app is installed
   *
   * @param packageName The package name of the software.
   * @return Boolean
   */
  private fun isAppExist(packageName: String): Boolean {
    return try {
      mContext.packageManager.getPackageInfo(packageName, 0)
      true
    } catch (e: PackageManager.NameNotFoundException) {
      false
    }
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  companion object {
    private const val CHANNEL_NAME = "upgrade_util.io.channel/method"
  }
}
