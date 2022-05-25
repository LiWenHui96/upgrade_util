import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:upgrade_util/upgrade_util.dart';

/// @Describe: Upgrade dialog
///
/// @Author: LiWeNHuI
/// @Date: 2022/1/12

/// Listener - Download progress
typedef DownloadProgressCallback = Function(int count, int total);

/// Listener - Download status
typedef DownloadStatusCallback = Function(
  DownloadStatus downloadStatus, {
  dynamic error,
});

class UpgradeDialog extends StatefulWidget {
  UpgradeDialog({
    Key? key,
    required this.iOSAppId,
    required this.androidPackageName,
    required this.androidMarket,
    this.otherMarkets,
    required this.downloadUrl,
    this.saveApkName,
    required this.title,
    this.titleTextStyle,
    this.titleStrutStyle,
    required this.content,
    this.contentTextStyle,
    this.contentStrutStyle,
    required this.contentTextAlign,
    this.scrollController,
    this.actionScrollController,
    required this.force,
    this.updateKey,
    required this.updateText,
    this.updateTextStyle,
    required this.isUpgradeDefaultAction,
    required this.isUpgradeDestructiveAction,
    this.cancelKey,
    required this.cancelText,
    this.cancelTextStyle,
    required this.isCancelDefaultAction,
    required this.isCancelDestructiveAction,
    this.updateCallback,
    this.cancelCallback,
    this.downloadProgressCallback,
    this.downloadStatusCallback,
    required this.androidTitle,
    required this.cancel,
    required this.downloadTip,
  })  : assert(iOSAppId.isNotEmpty, 'iOSAppId Not empty'),
        assert(androidPackageName.isNotEmpty, 'androidPackageName Not empty'),
        super(key: key);

  static Future<T?> show<T>(
    BuildContext context, {
    Key? key,
    required String iOSAppId,
    required AndroidUpgradeInfo androidUpgradeInfo,
    String? title,
    TextStyle? titleTextStyle,
    StrutStyle? titleStrutStyle,
    String? content,
    TextStyle? contentTextStyle,
    StrutStyle? contentStrutStyle,
    TextAlign contentTextAlign = TextAlign.start,
    ScrollController? scrollController,
    ScrollController? actionScrollController,
    bool force = false,
    Key? updateKey,
    String? updateText,
    TextStyle? updateTextStyle,
    bool isUpgradeDefaultAction = false,
    bool isUpgradeDestructiveAction = false,
    Key? cancelKey,
    String? cancelText,
    TextStyle? cancelTextStyle,
    bool isCancelDefaultAction = false,
    bool isCancelDestructiveAction = true,
    VoidCallback? updateCallback,
    VoidCallback? cancelCallback,
    DownloadProgressCallback? downloadProgressCallback,
    DownloadStatusCallback? downloadStatusCallback,
  }) async {
    if (!(Platform.isIOS || Platform.isAndroid)) {
      throw UnimplementedError('Unsupported platform.');
    }

    final UpgradeLocalizations local = UpgradeLocalizations.of(context);

    Widget child = UpgradeDialog(
      key: key ?? ObjectKey(context),
      iOSAppId: iOSAppId,
      androidPackageName: androidUpgradeInfo.packageName,
      androidMarket: androidUpgradeInfo.androidMarket ?? AndroidMarket(),
      otherMarkets: androidUpgradeInfo.otherMarkets,
      downloadUrl: androidUpgradeInfo.downloadUrl ?? '',
      saveApkName: androidUpgradeInfo.saveApkName,
      title: title ?? local.title,
      titleTextStyle: titleTextStyle,
      titleStrutStyle: titleStrutStyle,
      content: content ?? local.content,
      contentTextStyle: contentTextStyle,
      contentStrutStyle: contentStrutStyle,
      contentTextAlign: contentTextAlign,
      scrollController: scrollController,
      actionScrollController: actionScrollController,
      force: force,
      updateKey: updateKey,
      updateText: updateText ?? local.updateText,
      updateTextStyle: updateTextStyle,
      isUpgradeDefaultAction: isUpgradeDefaultAction,
      isUpgradeDestructiveAction: isUpgradeDestructiveAction,
      cancelKey: cancelKey,
      cancelText: cancelText ?? local.cancelText,
      cancelTextStyle: cancelTextStyle,
      isCancelDefaultAction: isCancelDefaultAction,
      isCancelDestructiveAction: isCancelDestructiveAction,
      updateCallback: updateCallback,
      cancelCallback: cancelCallback,
      downloadProgressCallback: downloadProgressCallback,
      downloadStatusCallback: downloadStatusCallback,
      androidTitle: local.androidTitle,
      cancel: local.cancel,
      downloadTip: local.downloadTip,
    );

    child = WillPopScope(child: child, onWillPop: () async => false);

    return showCupertinoDialog(
      context: context,
      builder: (BuildContext ctx) => child,
      barrierDismissible: true,
    );
  }

  @override
  State<UpgradeDialog> createState() => _UpgradeDialogState();

  /// The [iOSAppId] is App Store ID.
  ///
  /// It is required.
  final String iOSAppId;

  /// The [androidPackageName] is the package name.
  ///
  /// It is required.
  final String androidPackageName;

  /// The [androidMarket] is the settings of app market for Android.
  ///
  /// It is all false by default.
  final AndroidMarket androidMarket;

  /// Package name for markets other than presets.
  final List<String>? otherMarkets;

  /// The [downloadUrl] is a link of download for Apk.
  final String downloadUrl;

  /// They are the saved information after the apk download is completed.
  /// For details, see the 'AndroidUtil.getDownloadPath' method.
  final String? saveApkName;

  final String title;
  final TextStyle? titleTextStyle;
  final StrutStyle? titleStrutStyle;

  final String content;
  final TextStyle? contentTextStyle;
  final StrutStyle? contentStrutStyle;

  /// The [contentTextAlign] is how to align text horizontally of [content].
  /// It is `TextAlign.start` by default.
  final TextAlign contentTextAlign;

  final ScrollController? scrollController;
  final ScrollController? actionScrollController;

  /// The [force] is Whether to force the update, there is no cancel button
  /// when forced.
  ///
  /// It is `false` by default.
  final bool force;

  final Key? updateKey;
  final String updateText;
  final TextStyle? updateTextStyle;
  final bool isUpgradeDefaultAction;
  final bool isUpgradeDestructiveAction;
  final Key? cancelKey;
  final String cancelText;
  final TextStyle? cancelTextStyle;
  final bool isCancelDefaultAction;
  final bool isCancelDestructiveAction;

  /// Use [updateCallback] to implement the event listener of clicking the
  /// update button.
  ///
  /// It is to close the dialog and open App Store and then jump to the
  /// details page of the app with application number 'appId' by default.
  final VoidCallback? updateCallback;

  /// Use [cancelCallback] to implement the event listener of clicking the
  /// cancel button.
  ///
  /// It is to close the dialog by default.
  final VoidCallback? cancelCallback;

  /// Use [downloadProgressCallback] to realize the listening event of
  /// download progress.
  final DownloadProgressCallback? downloadProgressCallback;

  /// Use [downloadStatusCallback] to realize the listening event of
  /// download status.
  final DownloadStatusCallback? downloadStatusCallback;

  final String androidTitle;
  final String cancel;
  final String downloadTip;
}

class _UpgradeDialogState extends State<UpgradeDialog> {
  /// Download progress
  double _downloadProgress = 0;

  DownloadStatus _downloadStatus = DownloadStatus.none;

  bool _isShowProgress = false;

  final CancelToken _cancelToken = CancelToken();

  @override
  void dispose() {
    super.dispose();

    _cancelToken.cancel('Page closed.');
  }

  @override
  Widget build(BuildContext context) {
    final CupertinoDialogAction cancelAction = CupertinoDialogAction(
      key: widget.cancelKey,
      onPressed: _cancel,
      isDestructiveAction: widget.isCancelDestructiveAction,
      isDefaultAction: widget.isCancelDefaultAction,
      textStyle: widget.cancelTextStyle,
      child: Text(widget.cancelText),
    );

    final CupertinoDialogAction updateAction = CupertinoDialogAction(
      key: widget.updateKey,
      onPressed: _update,
      isDefaultAction: force ? force : widget.isUpgradeDefaultAction,
      isDestructiveAction: widget.isUpgradeDestructiveAction,
      textStyle: widget.updateTextStyle,
      child: Text(widget.updateText),
    );

    final List<Widget> baseActions = <Widget>[
      if (!force) cancelAction,
      if (_isShowProgress)
        ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 45),
          child: const Center(child: CupertinoActivityIndicator()),
        )
      else
        updateAction,
    ];

    final List<Widget> downloadActions = <Widget>[
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        child: Material(
          color: Colors.transparent,
          child: Column(
            children: <Widget>[
              Text(widget.downloadTip),
              const SizedBox(height: 8),
              LinearProgressIndicator(value: _downloadProgress),
              const SizedBox(height: 4),
              Text(
                '${(_downloadProgress * 100).toStringAsFixed(2)}%',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                ),
              ),
              if (!force)
                Container(
                  margin: const EdgeInsets.only(top: 14),
                  child: Ink(
                    width: double.infinity,
                    height: 36,
                    decoration: BoxDecoration(
                      color: const Color(0xFFDEDEDE),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(18),
                      child: Center(child: Text(widget.cancel)),
                      onTap: () => Navigator.pop(context),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    ];

    final List<Widget> actions =
        _downloadProgress > 0 ? downloadActions : baseActions;

    return CupertinoAlertDialog(
      title: Text(
        widget.title,
        style: widget.titleTextStyle,
        strutStyle: widget.titleStrutStyle,
      ),
      content: Text(
        widget.content,
        style: widget.contentTextStyle,
        strutStyle: widget.contentStrutStyle,
        textAlign: widget.contentTextAlign,
      ),
      scrollController: widget.scrollController,
      actionScrollController: widget.actionScrollController,
      actions: actions,
    );
  }

  void _cancel() {
    cancelCallback?.call();

    Navigator.pop(context);
  }

  Future<void> _update() async {
    updateCallback?.call();

    if (Platform.isIOS) {
      Navigator.pop(context);
      await UpgradeUtil.jumpToStore(
        jumpMode: JumpMode.detailPage,
        iOSAppleId: widget.iOSAppId,
      );
    } else if (Platform.isAndroid) {
      await _androidUpgrade();
    }
  }

  Future<void> _androidUpgrade() async {
    setState(() {
      if (mounted) {
        _isShowProgress = true;
      }
    });

    final List<AndroidMarketModel> markets =
        await UpgradeUtil.getMarkets(
      androidMarket: widget.androidMarket,
      otherMarkets: widget.otherMarkets,
    );

    setState(() {
      if (mounted) {
        _isShowProgress = false;
      }
    });

    if (markets.isEmpty) {
      if (widget.downloadUrl.isNotEmpty) {
        await _download();
      } else {
        throw ArgumentError('Both androidMarket and downloadUrl are empty');
      }
    } else {
      final String? marketName =
          await ChooseMarket.chooseMarkets(context: context, markets: markets);
      if (marketName == null) {
        return;
      }
      await _jumpToMarket(marketName);
    }
  }

  Future<void> _jumpToMarket(String marketPackageName) async {
    Navigator.pop(context);
    await UpgradeUtil.jumpToStore(
      jumpMode: JumpMode.detailPage,
      androidPackageName: widget.androidPackageName,
      androidMarketPackageName: marketPackageName,
    );
  }

  Future<void> _download() async {
    if (_downloadStatus == DownloadStatus.start ||
        _downloadStatus == DownloadStatus.downloading ||
        _downloadStatus == DownloadStatus.done) {
      debugPrint(
        'Current download status: $_downloadStatus, the download cannot '
        'be repeated.',
      );
      return;
    }

    _updateStatus(DownloadStatus.start);

    try {
      final String urlPath = widget.downloadUrl;
      final String savePath =
          await UpgradeUtil.getDownloadPath(softwareName: widget.saveApkName);

      final Dio dio = Dio();
      await dio.download(
        urlPath,
        savePath,
        cancelToken: _cancelToken,
        onReceiveProgress: (int count, int total) async {
          if (total == -1) {
            _updateProgress(0.01);
          } else {
            widget.downloadProgressCallback?.call(count, total);
            _updateProgress(count / total.toDouble());
          }

          if (_downloadProgress == 1) {
            // After downloading, jump to the program installation interface.
            _updateStatus(DownloadStatus.done);
            Navigator.pop(context);
            await UpgradeUtil.installApk(savePath);
          } else {
            _updateStatus(DownloadStatus.downloading);
          }
        },
      );
    } catch (e) {
      debugPrint('$e');
      _updateProgress(0);
      _updateStatus(DownloadStatus.error, error: e);
    }
  }

  void _updateProgress(double value) {
    setState(() {
      if (mounted) {
        _downloadProgress = value;
      }
    });
  }

  void _updateStatus(DownloadStatus downloadStatus, {dynamic error}) {
    _downloadStatus = downloadStatus;
    widget.downloadStatusCallback?.call(_downloadStatus, error: error);
  }

  bool get force => widget.force;

  VoidCallback? get cancelCallback => widget.cancelCallback;

  VoidCallback? get updateCallback => widget.updateCallback;
}
