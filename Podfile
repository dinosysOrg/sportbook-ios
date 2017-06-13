# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

def shared_pods
   pod 'SDWebImage'
   pod 'Alamofire'
   pod 'SwiftyJSON'
   pod 'DateToolsSwift'
   pod 'Hue'
   pod 'RxSwift'
   pod 'RxCocoa'
   pod "RxGesture"
   pod 'RxKeyboard'
   pod 'RxReachability'
   pod 'Moya/RxSwift'
   pod 'FacebookCore'
   pod 'FacebookLogin'
   pod 'SkyFloatingLabelTextField'
   pod 'Fabric'
   pod 'Crashlytics'
   pod 'IQKeyboardManager'
   pod 'DLRadioButton'  
end

target 'SportBook Production' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for SportBook
   shared_pods
end

target 'SportBook Staging' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!
  
  # Pods for SportBook
  shared_pods 

  target 'SportBookTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'SportBookUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end
