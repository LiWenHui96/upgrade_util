/// @Describe: 枚举
///
/// @Author: LiWeNHuI
/// @Date: 2026/10/12

library;

/// 跳转至应用商店的页面类型
enum UpgradeOpenType {
  /// 应用详情页
  detail,

  /// 评论列表页
  ///
  /// 仅 iOS 支持，打开 App Store 评论列表页
  reviews,

  /// 写评论页
  ///
  /// iOS 打开 App Store 撰写评论页；
  /// Android 目前部分商店支持评论深链（OPPO、vivo、荣耀），其他落地至详情页
  review,
}
