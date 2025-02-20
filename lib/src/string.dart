/// @Describe: String extension.
///
/// @Author: LiWeNHuI
/// @Date: 2025/2/17

library;

extension ExtendString on String? {
  /// 是否为空
  bool get isBlank {
    if (this == null) return true;

    /// 去除所有空格
    final String replace = this!.replaceAll(RegExp(r'\s+\b|\b\s'), '');
    return replace.isEmpty;
  }

  /// 显示信息
  String get _d => isBlank ? '' : this!;

  /// 链接Uri拼接参数
  String addParameters(Map<String, dynamic> parameters) {
    if (isBlank) return _d;

    final Uri? uri = Uri.tryParse(_d);
    if (uri == null) return _d;

    final Map<String, dynamic> existingMap =
        uri.queryParameters.cast<String, dynamic>();
    final Map<String, dynamic> map = Map<String, dynamic>.from(existingMap);
    return uri.replace(queryParameters: map..addAll(parameters)).toString();
  }

  /// 替换文本
  /// 以 %s 为标识
  String replace([List<dynamic>? list]) {
    const String key = '%s';
    final RegExp pattern = RegExp('$key{1}');

    /// 判断条件
    if (list == null || list.length != pattern.allMatches(_d).length) return _d;

    int index = 0;
    return _d.splitMapJoin(pattern, onMatch: (_) => _onMatch(list, index++));
  }

  /// 匹配信息
  String _onMatch(List<dynamic> list, int index) {
    try {
      return '${list[index]}';
    } catch (e) {
      return '';
    }
  }
}
