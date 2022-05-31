/// @Describe: Enum
///
/// @Author: LiWeNHuI
/// @Date: 2022/5/31

/// The download status of Apk.
enum DownloadStatus {
  /// Not downloaded
  none,

  /// Ready to start downloading
  start,

  /// Downloading
  downloading,

  /// Download complete
  done,

  /// Download exception
  error
}

/// How to jump to the store's page
enum JumpMode {
  /// Product page
  detailPage,

  /// Evaluation page
  reviewsPage,

  /// Write an evaluation
  writeReview,
}
