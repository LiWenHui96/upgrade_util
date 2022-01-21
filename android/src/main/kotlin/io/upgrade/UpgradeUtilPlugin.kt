package io.upgrade

import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.net.Uri
import android.os.Build
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
import java.util.ArrayList

/** UpgradeUtilPlugin */
class UpgradeUtilPlugin : FlutterPlugin, MethodCallHandler, ActivityAware {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel
    private lateinit var mContext: Context

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "upgrade_util")
        channel.setMethodCallHandler(this)

        flutterPluginBinding.platformViewRegistry.registerViewFactory(
            "plugins.upgrade_util/view",
            MarketViewFactory()
        )
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        when (call.method) {
            "getApkDownloadPath" -> result.success(mContext.cacheDir.path)
            "installApk" -> {
                val path = call.argument<String>("path")
                path?.also { result.success(installApk(path)) }
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
     * @param path 软件保存地址
     * @return Boolean
     */
    private fun installApk(path: String): Boolean {
        val file = File(path)
        if (!file.exists()) {
            return false
        }

        val intent = Intent(Intent.ACTION_VIEW)
        val url: Uri?

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
            val authority = "${mContext.packageName}.UpgradeUtilPlugin.fileprovider"
            url = FileProvider.getUriForFile(mContext, authority, file)
            intent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
        } else {
            url = Uri.fromFile(file)
            intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        }

        if (url != null) {
            intent.setDataAndType(url, "application/vnd.android.package-archive")
            mContext.startActivity(intent)
            return true
        }

        return false
    }

    /**
     * Gets a list of installed app market package names
     *
     * @param packages 需要验证的包名列表
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
     * @param packageName 包名
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
     * @param packageName 应用包名
     * @param marketPackageName 市场包名
     * @return Boolean
     */
    private fun jumpToMarket(packageName: String?, marketPackageName: String?) {
        return try {
            val mPackageInfo = pm().getPackageInfo(mContext.packageName, 0)
            val mPackageName = packageName ?: mPackageInfo.packageName
            val uri = Uri.parse("${getUriString(marketPackageName)}${mPackageName}")
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
     * @param packageName 包名
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

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        mContext = binding.activity
    }

    override fun onDetachedFromActivityForConfigChanges() {}

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {}

    override fun onDetachedFromActivity() {}
}
