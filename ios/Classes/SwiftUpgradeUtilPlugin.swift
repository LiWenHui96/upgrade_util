import Flutter
import UIKit

let channelName = "upgrade_util.io.channel/method"

public class SwiftUpgradeUtilPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: channelName, binaryMessenger: registrar.messenger())
    let instance = SwiftUpgradeUtilPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch (call.method) {
      case "getPlatformVersion":
        result("iOS " + UIDevice.current.systemVersion)
        break
      case "launch":
        result(NSNumber(value: launchURL(arg: call.arguments as! [String: Any?])))
        break
      default:
        result(FlutterMethodNotImplemented)
        break
    }
  }
  
  func launchURL(arg: [String : Any?]) -> Bool {
    let urlString = arg["url"] as! String
    
    guard let url = URL(string: urlString) else {
      return false
    }
    let application = UIApplication.shared
    
    if urlString.count > 0 && application.canOpenURL(url) {
      if #available(iOS 10.0, *) {
        let universalLinksOnly = arg["universalLinksOnly"] ?? NSNumber(value: 0)
        let options = [
          UIApplication.OpenExternalURLOptionsKey.universalLinksOnly: universalLinksOnly ?? false
        ]
        
        application.open(url, options: options, completionHandler: nil)
        return true
      } else {
        return application.openURL(url)
      }
    }
    
    return false
  }
}
