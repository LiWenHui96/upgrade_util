#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint upgrade_util.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'upgrade_util'
  s.version          = '0.0.1'
  s.summary          = 'A plug-in for application upgrades, which implements the method of jumping to the store and the function of installing after downloading the APK.'
  s.description      = <<-DESC
A plug-in for application upgrades, which implements the method of jumping to the store and the function of installing after downloading the APK.
                       DESC
  s.homepage         = 'https://github.com/LiWenHui96'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'LiWeNHuI' => 'sdgrlwh@163.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '12.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'

  # If your plugin requires a privacy manifest, for example if it uses any
  # required reason APIs, update the PrivacyInfo.xcprivacy file to describe your
  # plugin's privacy impact, and then uncomment this line. For more information,
  # see https://developer.apple.com/documentation/bundleresources/privacy_manifest_files
  # s.resource_bundles = {'upgrade_util_privacy' => ['Resources/PrivacyInfo.xcprivacy']}
end
