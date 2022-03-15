package io.upgrade

import android.content.Context
import android.content.pm.PackageManager
import android.view.View
import android.widget.ImageView
import io.flutter.plugin.common.*
import io.flutter.plugin.platform.PlatformView

/**
 * @author LiWeNHuI
 * @date 2022/1/21
 * @describe
 */
class MarketView internal constructor(
  context: Context,
  viewId: Int,
  args: String?,
  messenger: BinaryMessenger
) : PlatformView, MethodChannel.MethodCallHandler {
  private var mImageView = ImageView(context)
  private lateinit var channel: MethodChannel

  override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {}

  override fun getView(): View {
    return mImageView
  }

  override fun dispose() {
    channel.setMethodCallHandler(null)
  }

  init {
    args?.also {
      val pm = context.packageManager
      val info = pm.getApplicationInfo(it, PackageManager.GET_META_DATA)
      val icon = pm.getApplicationIcon(info)
      mImageView.setImageDrawable(icon)

      channel = MethodChannel(messenger, "${channelName}_$viewId")
      channel.setMethodCallHandler(this)

      mImageView.setOnClickListener { channel.invokeMethod("OnClickListener", "") }
    }
  }

  companion object {
    const val channelName = "upgrade_util.io.view.channel/method"
  }
}
