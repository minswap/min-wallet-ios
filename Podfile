# Uncomment the next line to define a global platform for your project
platform :ios, '16.0'
source 'https://github.com/CocoaPods/Specs.git'

install! 'cocoapods',
:preserve_pod_file_structure => true

target 'MinWallet' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  pod 'FlowStacks'
  pod 'Then'
  pod 'ScalingHeaderScrollView'
  pod 'SwiftyAttributes'
  pod 'SDWebImageSwiftUI'
  pod 'SkeletonUI'

  target 'MinWalletTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'MinWalletUITests' do
    # Pods for testing
  end

end


post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings["IPHONEOS_DEPLOYMENT_TARGET"] = "16.0"
    end
  end
end
