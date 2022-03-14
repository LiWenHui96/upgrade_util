#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint upgrade_util.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'upgrade_util'
  s.version          = '2.1.0'
  s.summary          = 'An app upgrade plugin. It realizes the function of jumping to App Store or Market and installing after downloading APK.'
  s.description      = <<-DESC
An app upgrade plugin. It realizes the function of jumping to App Store or Market and installing after downloading APK.
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
