package io.upgrade

import android.content.Context
import android.content.pm.PackageManager
import android.view.View
import android.widget.ImageView
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.platform.PlatformView

/**
 * @author LiWeNHuI
 * @date 2022/1/21
 * @describe
 */
class MarketView internal constructor(
  context: Context,
  args: String?
) : PlatformView, MethodChannel.MethodCallHandler {
  private var mImageView = ImageView(context)

  override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {

  }

  override fun getView(): View {
    return mImageView
  }

  override fun dispose() {}

  init {
    args?.also {
      val pm = context.packageManager
      val info = pm.getApplicationInfo(it, PackageManager.GET_META_DATA)
      val icon = pm.getApplicationIcon(info)
      mImageView.setImageDrawable(icon)
    }
  }
}