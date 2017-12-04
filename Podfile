source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '10.3'
inhibit_all_warnings!
use_frameworks!

workspace 'Rai'

target 'Rai' do
  pod 'SwiftyJSON'
  pod 'ReactiveSwift'
  pod 'Cartography'
end

target 'RaiToday' do
  pod 'SwiftyJSON'
  pod 'Cartography'
end

post_install do |installer|
  installer.pods_project.targets.each  do |target|
      target.build_configurations.each  do |config|
        config.build_settings['SWIFT_VERSION'] = '3.2'
        config.build_settings['PROVISIONING_PROFILE_SPECIFIER'] = ''
      end
   end
end
