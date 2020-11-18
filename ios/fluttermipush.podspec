#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint flutter_xiaomi_mipush.podspec' to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'fluttermipush'
  s.version          = '0.0.1'
  s.summary          = 'iOS 版本的小米推送插件'
  s.description      = <<-DESC
A new flutter plugin project.
                       DESC
  s.homepage         = 'http://scott-cry.win/'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'my_snail@126.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h', 'Library/*.h'
  s.vendored_libraries = 'Library/*.a'
  s.dependency 'Flutter'
  s.platform = :ios, '9.0'

  # Flutter.framework does not contain a i386 slice. Only x86_64 simulators are supported.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'VALID_ARCHS[sdk=iphonesimulator*]' => 'x86_64' }
end
