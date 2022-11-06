import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:upgrade_util/src/android_market.dart';
import 'package:upgrade_util/src/upgrade_config.dart';
import 'package:upgrade_util/src/upgrade_localizations.dart';
import 'package:upgrade_util/src/upgrade_util.dart';

/// @Describe: Displays a Material upgrade dialog above the current contents
///            of the app.
///
/// @Author: LiWeNHuI
/// @Date: 2022/5/27

Future<T?> showMaterialUpgradeDialog<T>(
  BuildContext context, {
  required Widget child,
  Color? barrierColor,
  String? barrierLabel,
  RouteSettings? routeSettings,
}) {
  return showDialog(
    context: context,
    builder: (_) => child,
    barrierColor: barrierColor ?? const Color.fromRGBO(0, 0, 0, .4),
    barrierLabel: barrierLabel,
    routeSettings: routeSettings,
  );
}

/// The widget of Material upgrade dialog.
@protected
class MaterialUpgradeDialog extends StatefulWidget {
  // ignore: public_member_api_docs
  const MaterialUpgradeDialog({
    Key? key,
    required this.androidUpgradeConfig,
    required this.force,
    required this.title,
    this.content,
    required this.updateText,
    this.updateTextStyle,
    required this.cancelText,
    this.cancelTextStyle,
    required this.onUpgradePressed,
    required this.onCancelPressed,
    required this.isDebugLog,
  }) : super(key: key);

  /// Android upgrade config.
  /// Only Android is supported.
  ///
  /// It is required.
  final AndroidUpgradeConfig androidUpgradeConfig;

  /// Whether to force the update, there is no cancel button
  /// when forced.
  ///
  /// It is `false` by default.
  final bool force;

  /// A title of the version.
  final Widget title;

  /// A description of the version.
  final Widget? content;

  /// Text message of the update button.
  final String updateText;

  /// The text style of [updateText].
  final TextStyle? updateTextStyle;

  /// Text message of cancel button.
  final String cancelText;

  /// The text style of [cancelText].
  final TextStyle? cancelTextStyle;

  /// Click event of Updates button.
  final ValueChanged<String?>? onUpgradePressed;

  /// Click event of Cancel button.
  final VoidCallback? onCancelPressed;

  // ignore: public_member_api_docs
  final bool isDebugLog;

  @override
  State<MaterialUpgradeDialog> createState() => _MaterialUpgradeDialogState();
}

class _MaterialUpgradeDialogState extends State<MaterialUpgradeDialog> {
  /// Whether to show `CupertinoActivityIndicator`.
  bool _isShowIndicator = false;

  /// Download progress
  double _downloadProgress = 0;

  /// Download status
  DownloadStatus _downloadStatus = DownloadStatus.none;

  final CancelToken _cancelToken = CancelToken();

  @override
  void dispose() {
    super.dispose();

    _cancelToken.cancel('Upgrade Dialog is closed.');
  }

  @override
  Widget build(BuildContext context) {
    Widget child = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Flexible(child: _buildContent()),
        const SizedBox(height: 12),
        _buildActions(),
      ],
    );

    child = Container(
      color: const Color(0xFFFEFEFE),
      child: Padding(padding: const EdgeInsets.all(12), child: child),
    );

    if (config.topImageProvider != null) {
      child = Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Image(
            image: config.topImageProvider!,
            width: double.infinity,
            height: config.topImageHeight,
            fit: BoxFit.fill,
          ),
          child,
        ],
      );
    }

    return Dialog(
      backgroundColor: Colors.transparent,
      child: ClipRRect(
        borderRadius: config.dialogBorderRadius ?? BorderRadius.circular(10),
        child: SizedBox(
          width: MediaQueryData.fromWindow(window).size.width - 80,
          child: child,
        ),
      ),
    );
  }

  Widget _buildContent() {
    final Widget child = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        DefaultTextStyle(
          style: TextStyle(
            color: Colors.black.withOpacity(.95),
            fontSize: 18,
            fontWeight: FontWeight.bold,
            height: 1.5,
            textBaseline: TextBaseline.alphabetic,
          ),
          textAlign: TextAlign.center,
          child: widget.title,
        ),
        if (widget.content != null) const SizedBox(height: 8),
        if (widget.content != null)
          DefaultTextStyle(
            style: TextStyle(
              color: Colors.black.withOpacity(.9),
              height: 1.5,
              textBaseline: TextBaseline.alphabetic,
            ),
            textAlign: TextAlign.center,
            child: widget.content!,
          ),
      ],
    );

    return Scrollbar(
      radius: const Radius.circular(10),
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        physics: const BouncingScrollPhysics(),
        child: child,
      ),
    );
  }

  Widget _buildActions() {
    final List<Widget> children = <Widget>[
      _buildTopAction(),
      if (!widget.force) _buildBottomAction(),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(children: children),
    );
  }

  Widget _buildTopAction() {
    final double iHeight = config.indicatorHeight ?? 10;
    final double tHeight = config.indicatorTextSize ?? 8;

    final Widget firstChild = Container(
      height: max(iHeight, tHeight) + 2,
      margin: const EdgeInsets.symmetric(vertical: 3, horizontal: 2),
      child: Stack(
        children: <Widget>[
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(iHeight),
              child: LinearProgressIndicator(
                value: _downloadProgress,
                backgroundColor: config.indicatorBackgroundColor,
                color: config.indicatorColor,
                valueColor: config.indicatorValueColor,
                minHeight: iHeight,
              ),
            ),
          ),
          Center(
            child: Text(
              '${(_downloadProgress * 100).toStringAsFixed(2)}%',
              style: TextStyle(
                color: config.indicatorTextColor ?? Colors.white,
                fontSize: tHeight,
              ),
            ),
          ),
        ],
      ),
    );

    final Widget secondChild = ElevatedButton(
      onPressed: _isShowIndicator ? null : _update,
      style: (config.updateButtonStyle ?? const ButtonStyle()).copyWith(
        minimumSize: MaterialStateProperty.all(const Size(double.infinity, 44)),
        elevation: MaterialStateProperty.all(0),
      ),
      child: Text(
        _isShowIndicator ? '正在跳转...' : widget.updateText,
        style: widget.updateTextStyle,
      ),
    );

    final Widget child = AnimatedCrossFade(
      duration: const Duration(milliseconds: 200),
      crossFadeState: _downloadProgress > 0 && _downloadProgress < 1
          ? CrossFadeState.showFirst
          : CrossFadeState.showSecond,
      alignment: Alignment.center,
      firstChild: firstChild,
      secondChild: secondChild,
    );

    return Container(margin: const EdgeInsets.only(bottom: 5), child: child);
  }

  Widget _buildBottomAction() {
    final Widget firstChild = ElevatedButton(
      onPressed: () async => Navigator.pop(context),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith(
          (Set<MaterialState> states) => const Color(0xFFDFDFDF),
        ),
        elevation: MaterialStateProperty.all(0),
        minimumSize: MaterialStateProperty.all(const Size(double.infinity, 32)),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32),
          ),
        ),
      ),
      child: Text(config.downloadCancelText ?? ''),
    );

    final Widget secondChild = InkWell(
      onTap: widget.onCancelPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        child: Text(
          widget.cancelText,
          style: (widget.cancelTextStyle ?? const TextStyle())
              .copyWith(color: Colors.grey),
        ),
      ),
    );

    return AnimatedCrossFade(
      duration: const Duration(milliseconds: 200),
      crossFadeState: _downloadProgress > 0 && _downloadProgress < 1
          ? CrossFadeState.showFirst
          : CrossFadeState.showSecond,
      alignment: Alignment.center,
      firstChild: firstChild,
      secondChild: secondChild,
    );
  }

  Future<void> _update() async {
    log('Start verifying the application market within the mobile phone.');

    setState(() {
      if (mounted) {
        _isShowIndicator = true;
      }
    });

    final List<AndroidMarketModel> markets =
        await UpgradeUtil.getMarkets(config.marketPackageNames);

    setState(() {
      if (mounted) {
        _isShowIndicator = false;
      }
    });

    log(
      'After inspection, the number of currently available app stores is '
      '${markets.length}.',
    );

    if (markets.isEmpty) {
      final Uri? downloadUri = config.downloadUri;
      if (downloadUri != null) {
        await _download(downloadUri);
      } else {
        throw ArgumentError('Both androidMarket and downloadUri are empty');
      }
    } else {
      widget.onUpgradePressed
          ?.call(await _chooseMarkets(context: context, markets: markets));
    }
  }

  /// Choose market
  Future<String?> _chooseMarkets({
    required BuildContext context,
    required List<AndroidMarketModel> markets,
  }) async {
    if (markets.length == 1) {
      return Future<String>.value(markets.first.packageName);
    }

    return showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
      ),
      builder: (_) => ChooseMarketsDialog(markets: markets),
    );
  }

  /// Download
  Future<void> _download(Uri downloadUri) async {
    final String savePath =
        await UpgradeUtil.getDownloadPath(softwareName: config.saveName);

    final File file = File(savePath);
    if (File(savePath).existsSync()) {
      if (config.isExistsFile) {
        await _install(savePath);
        return;
      } else {
        file.deleteSync();
      }
    }

    if (_downloadStatus == DownloadStatus.start ||
        _downloadStatus == DownloadStatus.downloading) {
      log(
        'Current download status: $_downloadStatus, the download cannot '
        'be repeated.',
      );
      return;
    }

    _updateDownload(0, DownloadStatus.start, d: 'Start download.');

    try {
      final Dio dio = Dio();
      dio.interceptors.addAll(config.downloadInterceptors);
      await dio.downloadUri(
        downloadUri,
        savePath,
        onReceiveProgress: (int count, int total) async {
          config.onDownloadProgressCallback?.call(count, total);

          if (total <= 0) {
            _updateDownload(0, DownloadStatus.error, d: 'Download failed.');
          } else if (count >= total) {
            // After the download is complete, jump to the program installation
            // interface.
            _updateDownload(1, DownloadStatus.done, d: 'Download completed.');
            await _install(savePath);
          } else {
            _updateDownload(
              count / total.toDouble(),
              DownloadStatus.downloading,
            );
          }
        },
        cancelToken: _cancelToken,
        deleteOnError: config.deleteOnError,
        lengthHeader: config.lengthHeader,
        data: config.data,
        options: config.options,
      );
    } catch (e) {
      debugPrint('$e');
      _updateDownload(0, DownloadStatus.error, d: 'Download failed.', error: e);
    }
  }

  Future<void> _install(String savePath) async {
    if (!widget.force && mounted) {
      Navigator.pop(context);
    }
    await UpgradeUtil.installApk(savePath);
  }

  void _updateDownload(
    double progress,
    DownloadStatus status, {
    String? d,
    dynamic error,
  }) {
    setState(() {
      if (mounted) {
        _downloadProgress = progress;
        _downloadStatus = status;
      }
    });
    log(d);
    config.onDownloadStatusCallback?.call(status, error: error);
  }

  void log(String? d) {
    if (widget.isDebugLog && d != null) {
      debugPrint('Upgrade Util - ${DateTime.now()} - $d');
    }
  }

  AndroidUpgradeConfig get config => widget.androidUpgradeConfig;
}

/// Choose Market
@protected
class ChooseMarketsDialog extends StatefulWidget {
  // ignore: public_member_api_docs
  const ChooseMarketsDialog({
    Key? key,
    required this.markets,
  }) : super(key: key);

  /// Get the software information of the application market included in
  /// the mobile phone.
  final List<AndroidMarketModel> markets;

  @override
  State<ChooseMarketsDialog> createState() => _ChooseMarketsDialogState();
}

class _ChooseMarketsDialogState extends State<ChooseMarketsDialog> {
  @override
  Widget build(BuildContext context) {
    final UpgradeLocalizations local = UpgradeLocalizations.of(context);
    const double cancelHeight = 48;

    Widget child = GridView.builder(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: 10),
      itemCount: widget.markets.length,
      itemBuilder: (BuildContext context, int index) {
        final AndroidMarketModel market = widget.markets[index];
        Widget child =
            market.icon != null ? Image.memory(market.icon!) : Container();

        child = Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            SizedBox(width: 48, height: 48, child: child),
            Text(market.showName ?? '', style: const TextStyle(fontSize: 12)),
          ],
        );

        return GestureDetector(
          onTap: () async => Navigator.pop(context, market.packageName ?? ''),
          child: Padding(padding: const EdgeInsets.all(5), child: child),
        );
      },
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
    );

    child = Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(local.androidTitle, style: const TextStyle(fontSize: 18)),
        Flexible(child: child),
        Ink(
          width: double.infinity,
          height: cancelHeight,
          decoration: BoxDecoration(
            color: const Color(0xFFDEDEDE),
            borderRadius: BorderRadius.circular(cancelHeight),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(cancelHeight),
            child: Center(child: Text(local.androidCancel)),
            onTap: () => Navigator.pop(context),
          ),
        )
      ],
    );

    return Padding(padding: const EdgeInsets.all(15), child: child);
  }
}

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
