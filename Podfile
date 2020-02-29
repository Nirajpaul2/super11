# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'GoSuper11' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for GoSuper11
pod 'Alamofire', '~> 4.5'
pod 'AlamofireImage'
pod 'SwiftyJSON'
pod 'NVActivityIndicatorView’
pod 'SkyFloatingLabelTextField', '~> 3.0'
pod 'SwiftOverlays'
pod 'TKSubmitTransition', :git => 'https://github.com/entotsu/TKSubmitTransition.git', :branch => 'swift4'
pod 'FAPanels'
pod 'SwiftyGif'
pod "AnimatableReload"
pod 'Fabric'
pod 'Crashlytics'
pod 'FBSDKLoginKit'
pod 'GoogleSignIn'
pod 'Firebase/Core'
pod 'XMSegmentedControl', :git => 'https://github.com/xaviermerino/XMSegmentedControl.git'



  target 'GoSuper11Tests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'GoSuper11UITests' do
    inherit! :search_paths
    # Pods for testing
  end

post_install do |installer|
    installer.pods_project.build_configurations.each do |config|
        config.build_settings.delete('CODE_SIGNING_ALLOWED')
        config.build_settings.delete('CODE_SIGNING_REQUIRED')
    end
end
end
