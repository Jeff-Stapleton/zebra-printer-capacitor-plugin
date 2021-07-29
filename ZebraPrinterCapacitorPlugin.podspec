require 'json'

package = JSON.parse(File.read(File.join(__dir__, 'package.json')))

Pod::Spec.new do |s|
  s.name = 'ZebraPrinterCapacitorPlugin'
  s.version = package['version']
  s.summary = package['description']
  s.license = package['license']
  s.homepage = package['repository']['url']
  s.author = package['author']
  s.source = { :git => package['repository']['url'], :tag => s.version.to_s }
  s.source_files = 'ios/Plugin/**/*.{swift,h,m,c,cc,mm,cpp,modulemap,a}'
  s.ios.vendored_libraries = 'ios/Plugin/ZebraSDK/libZSDK_API.a'
  s.pod_target_xcconfig = {'SWIFT_INCLUDE_PATHS' => '$(SRCROOT)/../../../node_modules/zebra-printer-capacitor-plugin/ios/Plugin/ZebraSDK/**'}
  s.libraries = 'z'
  s.preserve_paths = 'ios/Plugin/ZebraSDK/module/module.modulemap'
  s.ios.deployment_target  = '12.0'
  s.dependency 'Capacitor'
  s.swift_version = '5.1'
end
