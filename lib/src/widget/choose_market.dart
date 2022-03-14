import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:upgrade_util/upgrade_util.dart';

/// @Describe: Choose Market
///
/// @Author: LiWeNHuI
/// @Date: 2022/3/14

class ChooseMarket {
  static Future<String> chooseMarkets({
    @required BuildContext context,
    @required List<AndroidMarketModel> markets,
  }) async {
    if (markets.length == 1) {
      return Future.value(markets.first.packageNameD);
    }

    return showModalBottomSheet(
      context: context,
      barrierColor: CupertinoDynamicColor.resolve(
        CupertinoDynamicColor.withBrightness(
          color: Color(0x33000000),
          darkColor: Color(0x7A000000),
        ),
        context,
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(14.0)),
      ),
      builder: (BuildContext ctx) {
        final UpgradeLocalizations local = UpgradeLocalizations.of(ctx);

        final BorderRadius radius = BorderRadius.circular(24.0);
        const Color color = Color(0xFFDEDEDE);

        Widget child = InkWell(
          borderRadius: radius,
          child: Center(child: Text(local.cancel)),
          onTap: () => Navigator.pop(ctx),
        );

        child = Ink(
          width: double.infinity,
          height: 48.0,
          decoration: BoxDecoration(color: color, borderRadius: radius),
          child: child,
        );

        child = Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(local.androidTitle, style: const TextStyle(fontSize: 20.0)),
            const SizedBox(height: 10.0),
            Flexible(
              child: GridView.builder(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.zero,
                itemCount: markets.length,
                itemBuilder: (BuildContext ctx, int index) {
                  Widget child = AndroidView(
                    viewType: viewName,
                    creationParams: markets[index].packageName,
                    creationParamsCodec: const StandardMessageCodec(),
                    hitTestBehavior: PlatformViewHitTestBehavior.transparent,
                  );

                  child = ConstrainedBox(
                    constraints:
                        const BoxConstraints(maxWidth: 48.0, maxHeight: 48.0),
                    child: child,
                  );

                  child = Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [child, Text(markets[index].showNameD)],
                  );

                  child =
                      Padding(padding: const EdgeInsets.all(5.0), child: child);

                  return GestureDetector(
                    onTap: () async {
                      Navigator.pop(context, markets[index].packageNameD);
                    },
                    child: child,
                  );
                },
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                ),
              ),
            ),
            const SizedBox(height: 10.0),
            child,
          ],
        );

        return Padding(padding: const EdgeInsets.all(15.0), child: child);
      },
    );
  }
}
