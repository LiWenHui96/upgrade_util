import 'dart:convert';
import 'dart:typed_data';

/// @Describe: Android Application market
///
/// @Author: LiWeNHuI
/// @Date: 2022/1/17

class AndroidMarket {
  // ignore: public_member_api_docs
  AndroidMarket({
    this.isGooglePlay = false,
    this.isHuawei = false,
    this.isXiaomi = false,
    this.isOppo = false,
    this.isVivo = false,
    this.isMeizu = false,
    this.isZte = false,
    this.isSamsung = false,
    this.isLenovo = false,
    this.isNubia = false,
    this.isTencent = false,
    this.is360 = false,
    this.isBaidu = false,
    this.isWanDouJia = false,
    this.is91 = false,
    this.isPp = false,
    this.isAnZhi = false,
    this.isYingYongHui = false,
    this.isCool = false,
    this.isMM = false,
  });

  // ignore: public_member_api_docs
  late bool isGooglePlay;

  // ignore: public_member_api_docs
  late bool isHuawei;

  // ignore: public_member_api_docs
  late bool isXiaomi;

  // ignore: public_member_api_docs
  late bool isOppo;

  // ignore: public_member_api_docs
  late bool isVivo;

  // ignore: public_member_api_docs
  late bool isMeizu;

  // ignore: public_member_api_docs
  late bool isZte;

  // ignore: public_member_api_docs
  late bool isSamsung;

  // ignore: public_member_api_docs
  late bool isLenovo;

  // ignore: public_member_api_docs
  late bool isNubia;

  // ignore: public_member_api_docs
  late bool isTencent;

  // ignore: public_member_api_docs
  late bool is360;

  // ignore: public_member_api_docs
  late bool isBaidu;

  // ignore: public_member_api_docs
  late bool isWanDouJia;

  // ignore: public_member_api_docs
  late bool is91;

  // ignore: public_member_api_docs
  late bool isPp;

  // ignore: public_member_api_docs
  late bool isAnZhi;

  // ignore: public_member_api_docs
  late bool isYingYongHui;

  // ignore: public_member_api_docs
  late bool isCool;

  // ignore: public_member_api_docs
  late bool isMM;

  /// Google Play Store - https://play.google.com/
  static const String MARKET_GOOGLE = 'com.android.vending';

  /// 华为 - 华为应用市场 - http://app.hicloud.com/
  static const String MARKET_HUAWEI = 'com.huawei.appmarket';

  /// 小米 - 小米应用商店 - https://app.mi.com/
  static const String MARKET_XIAOMI = 'com.xiaomi.market';

  /// OPPO/realme/OnePlus - OPPO软件商店（Android 9及以下） - https://store.oppomobile.com/
  static const String MARKET_OPPO = 'com.oppo.market';

  /// OPPO/realme/OnePlus - OPPO软件商店（Android 9及以上，新版本，支持全家桶手机）- https://store.oppomobile.com/
  static const String MARKET_OPPO_NEW = 'com.heytap.market';

  /// vivo/iqoo - vivo应用商店 - http://zs.vivo.com.cn/
  static const String MARKET_VIVO = 'com.bbk.appstore';

  /// 魅族 - 魅族应用商店 - http://app.flyme.cn/
  static const String MARKET_MEIZU = 'com.meizu.mstore';

  /// ZTE - 中兴应用商店 - https://apps.ztems.com/
  static const String MARKET_ZTE = 'zte.com.market';

  /// Samsung - 三星应用商店 - https://seller.samsungapps.com/
  static const String MARKET_SANSUNG = 'com.sec.android.app.samsungapps';

  /// Lenovo - 联想应用中心 - https://www.lenovomm.com/
  static const String MARKET_LENOVO = 'com.lenovo.leos.appstore';

  /// 努比亚 - 努比亚应用中心 - https://ui.nubia.cn/app/
  static const String MARKET_NUBIA = 'cn.nubia.neostore';

  /// 腾讯 - 应用宝 - https://sj.qq.com/
  static const String MARKET_TENCENT = 'com.tencent.android.qqdownloader';

  /// 360 - 360手机助手 - http://zhushou.360.cn/
  static const String MARKET_360 = 'com.qihoo.appstore';

  /// 百度 - 百度手机助手 - https://shouji.baidu.com/
  static const String MARKET_BAIDU = 'com.baidu.appsearch';

  /// 阿里 - 豌豆荚 - https://www.wandoujia.com/
  static const String MARKET_WANDOUJIA = 'com.wandoujia.phoenix2';

  /// 91手机助手 - http://zs.91.com/
  static const String MARKET_91 = 'com.dragon.android.pandaspace';

  /// 阿里 - PP助手 - https://www.25pp.com/
  static const String MARKET_PP = 'com.pp.assistant';

  /// 安智 - 安智市场 - http://www.anzhi.com/
  static const String MARKET_ANZHI = 'cn.goapk.market';

  /// 掌汇天下 - 应用汇 - http://www.appchina.com/
  static const String MARKET_YINGYONGHUI = 'com.yingyonghui.market';

  /// 酷安 - https://www.coolapk.com/
  static const String MARKET_COOL = 'com.coolapk.market';

  /// 移动 - MM应用商城 - http://mm.10086.cn/store
  static const String MARKET_MM = 'com.aspire.mm';

  /// Gets a list of package names set to `true'
  List<String> toMarkets() {
    final List<String> markets = <String>[];

    if (isGooglePlay) {
      markets.add(MARKET_GOOGLE);
    }
    if (isHuawei) {
      markets.add(MARKET_HUAWEI);
    }
    if (isXiaomi) {
      markets.add(MARKET_XIAOMI);
    }
    if (isOppo) {
      markets
        ..add(MARKET_OPPO)
        ..add(MARKET_OPPO_NEW);
    }
    if (isVivo) {
      markets.add(MARKET_VIVO);
    }
    if (isMeizu) {
      markets.add(MARKET_MEIZU);
    }
    if (isZte) {
      markets.add(MARKET_ZTE);
    }
    if (isSamsung) {
      markets.add(MARKET_SANSUNG);
    }
    if (isLenovo) {
      markets.add(MARKET_LENOVO);
    }
    if (isNubia) {
      markets.add(MARKET_NUBIA);
    }
    if (isTencent) {
      markets.add(MARKET_TENCENT);
    }
    if (is360) {
      markets.add(MARKET_360);
    }
    if (isBaidu) {
      markets.add(MARKET_BAIDU);
    }
    if (isWanDouJia) {
      markets.add(MARKET_WANDOUJIA);
    }
    if (is91) {
      markets.add(MARKET_91);
    }
    if (isPp) {
      markets.add(MARKET_PP);
    }
    if (isAnZhi) {
      markets.add(MARKET_ANZHI);
    }
    if (isYingYongHui) {
      markets.add(MARKET_YINGYONGHUI);
    }
    if (isCool) {
      markets.add(MARKET_COOL);
    }
    if (isMM) {
      markets.add(MARKET_MM);
    }

    return markets;
  }

  /// Google Play
  static AndroidMarket get gp => AndroidMarket(isGooglePlay: true);

  /// 华为、小米、oppo、vivo
  static AndroidMarket get hmov => AndroidMarket(
        isHuawei: true,
        isXiaomi: true,
        isOppo: true,
        isVivo: true,
      );

  /// 国内厂商
  static AndroidMarket get chn => AndroidMarket(
        isHuawei: true,
        isXiaomi: true,
        isOppo: true,
        isVivo: true,
        isMeizu: true,
        isZte: true,
        isSamsung: true,
        isLenovo: true,
        isNubia: true,
      );

  /// ALL true
  static AndroidMarket get allTrue => AndroidMarket(
        isGooglePlay: true,
        isHuawei: true,
        isXiaomi: true,
        isOppo: true,
        isVivo: true,
        isMeizu: true,
        isZte: true,
        isSamsung: true,
        isLenovo: true,
        isNubia: true,
        isTencent: true,
        is360: true,
        isBaidu: true,
        isWanDouJia: true,
        is91: true,
        isPp: true,
        isAnZhi: true,
        isYingYongHui: true,
        isCool: true,
        isMM: true,
      );
}

/// Software information in the Android application market
class AndroidMarketModel {
  // ignore: public_member_api_docs
  AndroidMarketModel({
    this.packageName,
    this.showName,
    this.icon,
  });

  // ignore: public_member_api_docs
  AndroidMarketModel.fromJson(Map<dynamic, dynamic> json) {
    packageName = json['packageName'] as String?;
    showName = json['showName'] as String?;
    icon = base64Decode(json['icon'].toString());
  }

  /// The name of the software.
  String? showName;

  /// The name of the package of the software.
  String? packageName;

  /// The icon of software.
  Uint8List? icon;
}
