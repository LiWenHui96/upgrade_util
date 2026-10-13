package org.leoli.plugin.upgrade_util

import android.content.Context
import android.content.pm.PackageInfo
import android.content.pm.PackageManager
import android.os.Build

/**
 * 主流厂商应用市场的包名、页面协议与安装检测。
 *
 * 注意：Android 11（API 30）起受包可见性限制，需在 AndroidManifest.xml 中
 * 通过 `<queries>` 声明下列包名，否则 [filterInstalled] 永远返回空列表。
 */
object AppMarkets {
    /** 华为应用市场 */
    const val HUAWEI = "com.huawei.appmarket"

    /** 小米应用商店（含红米、POCO） */
    const val XIAOMI = "com.xiaomi.market"

    /** OPPO 软件商店（Android 9 起，含 realme、OnePlus） */
    const val OPPO = "com.heytap.market"

    /** OPPO 软件商店旧包名（Android 9 之前） */
    const val OPPO_LEGACY = "com.oppo.market"

    /** vivo 应用商店（含 iQOO） */
    const val VIVO = "com.bbk.appstore"

    /** 荣耀应用市场（独立后的新荣耀机型） */
    const val HONOR = "com.hihonor.appmarket"

    /** 三星应用商店 */
    const val SAMSUNG = "com.sec.android.app.samsungapps"

    /** 魅族应用商店 */
    const val MEIZU = "com.meizu.mstore"

    /** 全部市场包名，顺序即优先级：多个市场并存时取前者。 */
    val all: List<String> = listOf(
        HUAWEI,
        HONOR,
        XIAOMI,
        OPPO,
        OPPO_LEGACY,
        VIVO,
        MEIZU,
        SAMSUNG,
    )

    /** 需以 `startActivityForResult` 唤起的市场（OPPO 系对隐式唤起有限制，否则静默失败）。 */
    val requireActivityResult: Set<String> = setOf(OPPO, OPPO_LEGACY)

    /** 荣耀应用市场支持 `market://comment` 评论协议的最低 versionCode。 */
    private const val HONOR_COMMENT_MIN_VERSION = 160036301L

    /** 未收录品牌协议时使用的通用详情页协议模板，`%s` 为包名占位。 */
    private const val GENERIC_DETAIL_LINK = "market://details?id=%s"

    /**
     * 各市场的应用详情页协议模板，键为市场包名，`%s` 为包名占位。
     *
     * 仅收录有品牌专属协议的市场；小米、OPPO、荣耀等未收录的使用 [GENERIC_DETAIL_LINK]。
     *
     * vivo 为应用商店自更新协议，未传 `th_update_delay`，跳转后立即自动更新；
     * 魅族含两个 `%s`，依次为要更新的应用包名和调用方包名（`source_apkname`）。
     */
    private val detailLinks: Map<String, String> = mapOf(
        HUAWEI to "appmarket://details?id=%s",
        VIVO to "market://details?id=%s&th_name=self_update",
        MEIZU to "mstore://details?package_name=%s&source_apkname=%s",
        SAMSUNG to "samsungapps://ProductDetail/%s",
    )

    /**
     * 各市场的写评论深链模板，键为市场包名，`%s` 为包名占位。
     *
     * OPPO（含 realme、OnePlus）出自 OPPO 开放平台文档，需以 `startActivityForResult` 唤起；
     * vivo 出自应用商店自更新官方文档。
     */
    private val reviewLinks: Map<String, String> = mapOf(
        OPPO to "oaps://mk/developer/comment?pkg=%s",
        OPPO_LEGACY to "oaps://mk/developer/comment?pkg=%s",
        VIVO to "market://details?id=%s&th_name=need_comment",
    )

    /**
     * [market] 中 [pkg] 的详情页链接，未收录的市场使用 `market://` 通用协议。
     *
     * [context] 用于魅族模板中填充调用方包名。
     */
    fun detailLink(context: Context, market: String?, pkg: String): String {
        val template = detailLinks[market] ?: GENERIC_DETAIL_LINK
        return if (market == MEIZU) {
            template.replaceFirst("%s", pkg).replaceFirst("%s", context.packageName)
        } else {
            template.replace("%s", pkg)
        }
    }

    /**
     * [market] 中 [pkg] 的写评论深链，市场无评论深链时返回 null，由调用方落地详情页。
     *
     * 荣耀按市场版本区分协议：[HONOR_COMMENT_MIN_VERSION] 起支持 `market://comment`。
     */
    fun reviewLink(context: Context, market: String?, pkg: String): String? {
        val template = when (market) {
            HONOR -> "market://comment?id=%s".takeIf {
                versionCode(context, HONOR) >= HONOR_COMMENT_MIN_VERSION
            }

            else -> reviewLinks[market]
        } ?: return null
        return template.replace("%s", pkg)
    }

    /**
     * 返回 [all] 中已安装的市场包名。
     *
     * 逐包名调用 `getPackageInfo` 探测，不使用 `getInstalledPackages`：
     * 后者会读取整机应用列表，属于敏感个人信息，存在隐私合规风险。
     * manifest 中已通过 `<queries>` 声明这些包名，Android 11+ 上可被探测到。
     */
    fun filterInstalled(context: Context): List<String> {
        return all.filter {
            try {
                packageInfo(context, it)
                true
            } catch (e: PackageManager.NameNotFoundException) {
                false
            }
        }
    }

    /** 返回 [packageName] 的 versionCode，未安装时返回 0。 */
    private fun versionCode(context: Context, packageName: String): Long {
        val info = try {
            packageInfo(context, packageName)
        } catch (e: PackageManager.NameNotFoundException) {
            return 0
        }
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
            info.longVersionCode
        } else {
            @Suppress("DEPRECATION")
            info.versionCode.toLong()
        }
    }

    /** `getPackageInfo` 的 API 33 兼容封装。 */
    private fun packageInfo(context: Context, packageName: String): PackageInfo {
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            context.packageManager.getPackageInfo(
                packageName,
                PackageManager.PackageInfoFlags.of(0)
            )
        } else {
            @Suppress("DEPRECATION")
            context.packageManager.getPackageInfo(packageName, 0)
        }
    }
}