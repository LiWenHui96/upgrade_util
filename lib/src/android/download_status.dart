/// @Describe: The download status of Apk.
///
/// @Author: LiWeNHuI
/// @Date: 2022/1/12

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
