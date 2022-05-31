import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:upgrade_util/src/config/android_market.dart';
import 'package:upgrade_util/src/config/android_upgrade_config.dart';
import 'package:upgrade_util/src/config/enum.dart';
import 'package:upgrade_util/src/local/upgrade_localizations.dart';
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
  /// Externally provided
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
    final Widget child = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Flexible(child: _buildContent()),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: _downloadProgress > 0
              ? _buildDownloadAction()
              : _buildBasicActions(),
        ),
      ],
    );

    return Dialog(
      backgroundColor: const Color(0xFFFEFEFE),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: SizedBox(
        width: 270,
        child: Padding(padding: const EdgeInsets.all(8), child: child),
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
        if (widget.content != null) const SizedBox(height: 2),
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
        padding: const EdgeInsets.all(12),
        physics: const BouncingScrollPhysics(),
        child: child,
      ),
    );
  }

  Widget _buildBasicActions() {
    return Column(
      children: <Widget>[
        ElevatedButton(
          onPressed: _isShowIndicator ? null : _update,
          style: ButtonStyle(
            minimumSize:
                MaterialStateProperty.all(const Size(double.infinity, 40)),
            elevation: MaterialStateProperty.all(0),
          ),
          child: Text(
            _isShowIndicator ? '正在跳转...' : widget.updateText,
            style: widget.updateTextStyle,
          ),
        ),
        if (!widget.force)
          Container(
            margin: const EdgeInsets.only(top: 5),
            child: InkWell(
              onTap: widget.onCancelPressed,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                child: Text(
                  widget.cancelText,
                  style: widget.cancelTextStyle?.copyWith(color: Colors.grey) ??
                      const TextStyle(color: Colors.grey),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildDownloadAction() {
    const double height = 10;

    return Column(
      children: <Widget>[
        Container(
          height: height,
          margin: const EdgeInsets.symmetric(vertical: 3, horizontal: 2),
          child: Stack(
            children: <Widget>[
              SizedBox(
                height: height,
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(height)),
                  child: LinearProgressIndicator(
                    value: _downloadProgress,
                    backgroundColor: config.indicatorBackgroundColor,
                    color: config.indicatorColor,
                    valueColor: config.indicatorValueColor,
                  ),
                ),
              ),
              Center(
                child: Text(
                  '${(_downloadProgress * 100).toStringAsFixed(2)}%',
                  style: TextStyle(
                    color: config.indicatorTextColor ?? Colors.white,
                    fontSize: 8,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (!widget.force)
          Container(
            margin: const EdgeInsets.only(top: 5),
            child: ElevatedButton(
              onPressed: () async => Navigator.pop(context),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith(
                  (Set<MaterialState> states) => const Color(0xFFDFDFDF),
                ),
                elevation: MaterialStateProperty.all(0),
                minimumSize:
                    MaterialStateProperty.all(const Size(double.infinity, 32)),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32),
                  ),
                ),
              ),
              child: Text(config.downloadCancelText ?? ''),
            ),
          ),
      ],
    );
  }

  Future<void> _update() async {
    setState(() {
      if (mounted) {
        _isShowIndicator = true;
      }
    });

    final List<AndroidMarketModel> markets = await UpgradeUtil.getMarkets(
      androidMarket: config.androidMarket,
      otherMarkets: config.otherMarkets,
    );

    setState(() {
      if (mounted) {
        _isShowIndicator = false;
      }
    });

    if (markets.isEmpty) {
      final String? downloadUrl = config.downloadUrl;
      if (downloadUrl != null && downloadUrl.isNotEmpty) {
        await _download(downloadUrl);
      } else {
        throw ArgumentError('Both androidMarket and downloadUrl are empty');
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
  Future<void> _download(String downloadUrl) async {
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
      final String savePath =
          await UpgradeUtil.getDownloadPath(softwareName: config.saveName);

      final Dio dio = Dio();
      await dio.download(
        downloadUrl,
        savePath,
        cancelToken: _cancelToken,
        onReceiveProgress: (int count, int total) async {
          if (total < 0) {
            _updateProgress(0);
          } else {
            config.onDownloadProgressCallback?.call(count, total);
            _updateProgress(count / total.toDouble());
          }

          if (_downloadProgress == 1) {
            // After the download is complete, jump to the program installation
            // interface.
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

  void _updateStatus(DownloadStatus status, {dynamic error}) {
    setState(() {
      if (mounted) {
        _downloadStatus = status;
      }
    });
    config.onDownloadStatusCallback?.call(status, error: error);
  }

  AndroidUpgradeConfig get config => widget.androidUpgradeConfig;
}

/// Choose Market
@protected
class ChooseMarketsDialog extends StatefulWidget {
  /// Externally provided
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
            Text(market.showName ?? ''),
          ],
        );

        return GestureDetector(
          onTap: () async => Navigator.pop(context, market.packageName ?? ''),
          child: Padding(padding: const EdgeInsets.all(5), child: child),
        );
      },
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
      ),
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
