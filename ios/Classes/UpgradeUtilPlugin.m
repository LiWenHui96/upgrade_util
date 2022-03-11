#import "UpgradeUtilPlugin.h"
#if __has_include(<upgrade_util/upgrade_util-Swift.h>)
#import <upgrade_util/upgrade_util-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "upgrade_util-Swift.h"
#endif

@implementation UpgradeUtilPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftUpgradeUtilPlugin registerWithRegistrar:registrar];
}
@end
