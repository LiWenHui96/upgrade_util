#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint upgrade_util.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'upgrade_util'
  s.version          = '2.2.2'
  s.summary          = 'A plugin for app upgrades. It can jump to the application store, and implement the function of downloading and installing APK on Android.'
  s.description      = <<-DESC
A plugin for app upgrades. It can jump to the application store, and implement the function of downloading and installing APK on Android.
                       DESC
  s.homepage         = 'https://github.com/LiWenHui96/upgrade_util'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'LiWeNHuI' => 'sdgrlwh@163.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '9.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
