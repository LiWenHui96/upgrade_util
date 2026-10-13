#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint upgrade_util.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'upgrade_util'
  s.version          = '0.0.1'
  s.summary          = 'An in-app update plugin that supports redirecting to app stores for updates, previewing reviews, and writing reviews.'
  s.description      = <<-DESC
An in-app update plugin that supports redirecting to app stores for updates, previewing reviews, and writing reviews.
                       DESC
  s.homepage         = 'https://github.com/LeoLi-Byte'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'LeoLi-Byte' => 'sdgrlwh@163.com' }
  s.source           = { :path => '.' }
  s.source_files = 'upgrade_util/Sources/upgrade_util/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '15.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'

  # If your plugin requires a privacy manifest, for example if it uses any
  # required reason APIs, update the PrivacyInfo.xcprivacy file to describe your
  # plugin's privacy impact, and then uncomment this line. For more information,
  # see https://developer.apple.com/documentation/bundleresources/privacy_manifest_files
  s.resource_bundles = {'upgrade_util_privacy' => ['upgrade_util/Sources/upgrade_util/PrivacyInfo.xcprivacy']}
end
