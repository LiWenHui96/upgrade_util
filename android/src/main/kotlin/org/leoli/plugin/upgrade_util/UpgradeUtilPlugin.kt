package org.leoli.plugin.upgrade_util

import android.app.Activity
import android.content.ActivityNotFoundException
import android.content.Context
import android.content.Intent
import android.net.Uri
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** upgrade_util 的 Android 端实现：跳转应用商店详情页与写评论页。 */
class UpgradeUtilPlugin : FlutterPlugin, MethodCallHandler, ActivityAware {
    /** 与 Flutter 通信的通道，随引擎 attach/detach 注册与注销。 */
    private lateinit var channel: MethodChannel

    private lateinit var context: Context

    /** 前台 Activity，唤起 [AppMarkets.requireActivityResult] 中的市场时必需；无前台界面时为 null。 */
    private var activity: Activity? = null

    /**
     * 本机已安装的厂商应用市场中优先级最高的包名，均未安装时为 null。
     *
     * 首次访问时依据 [AppMarkets] 检测一次并缓存，
     * [launchDetail] 与 [launchReview] 共用该结果，不重复检测。
     *
     * 有意保持惰性：应用安装列表属个人信息，检测推迟到用户主动触发
     * 跳转时（此时必然已同意隐私政策），避免上架合规风险。
     */
    private val installedMarket: String? by lazy {
        AppMarkets.filterInstalled(context).firstOrNull()
    }

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "upgrade_util")
        channel.setMethodCallHandler(this)
        context = flutterPluginBinding.applicationContext
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            "launchDetail" -> launchDetail(call, result)
            "launchReview" -> launchReview(call, result)
            else -> result.notImplemented()
        }
    }

    /**
     * 跳转至应用商店详情页
     *
     * 优先使用检测到的市场的品牌协议并显式指定包名唤起；
     * 未检测到市场或市场无品牌协议时，使用 `market://` 通用协议。
     */
    private fun launchDetail(call: MethodCall, result: Result) {
        result.success(openDetail(installedMarket, targetPkg(call)))
    }

    /**
     * 跳转至应用商店写评论
     *
     * 优先使用检测到的市场的评论深链并显式指定包名唤起；
     * 市场无评论深链或深链打开失败时，回退至应用详情页。
     */
    private fun launchReview(call: MethodCall, result: Result) {
        val market = installedMarket
        val pkg = targetPkg(call)
        val url = AppMarkets.reviewLink(context, market, pkg)
        val opened = url != null && openUrl(url, market)
        result.success(opened || openDetail(market, pkg))
    }

    /** 打开 [market] 中 [pkg] 的详情页。 */
    private fun openDetail(market: String?, pkg: String): Boolean {
        return openUrl(AppMarkets.detailLink(context, market, pkg), market)
    }

    /** 本次跳转的目标应用包名，缺省为本应用。 */
    private fun targetPkg(call: MethodCall): String {
        return call.argument<String>("packageName") ?: context.packageName
    }

    /**
     * 打开指定链接
     *
     * [AppMarkets.requireActivityResult] 中的市场对隐式唤起有限制，
     * 需借助前台 Activity 以 `startActivityForResult` 打开，否则静默失败；
     * 无前台 Activity 时退化为普通唤起。
     *
     * @param targetPackage 显式指定的目标包名（厂商应用市场），null 时由系统分发。
     * @return 是否成功发起跳转，不含用户在市场内的后续操作。
     */
    private fun openUrl(url: String, targetPackage: String? = null): Boolean {
        return try {
            val intent = Intent(Intent.ACTION_VIEW, Uri.parse(url)).setPackage(targetPackage)
            val foreground = activity
            if (targetPackage in AppMarkets.requireActivityResult && foreground != null) {
                foreground.startActivityForResult(intent, REQUEST_CODE_MARKET)
            } else {
                intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                context.startActivity(intent)
            }
            true
        } catch (e: ActivityNotFoundException) {
            false
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onDetachedFromActivityForConfigChanges() {
        activity = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onDetachedFromActivity() {
        activity = null
    }

    companion object {
        /** 以 [Activity.startActivityForResult] 唤起应用市场时的请求码。 */
        private const val REQUEST_CODE_MARKET = 100
    }
}