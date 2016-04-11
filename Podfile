# Uncomment this line to define a global platform for your project
# platform :ios, '8.0'
# Uncomment this line if you're using Swift
use_frameworks!

target 'Social Hippo' do
pod ‘Alamofire’
pod ’SwiftyJSON’
pod ‘Kingfisher’
end

post_install do | installer |
  require 'fileutils'
  FileUtils.cp_r('Pods/Target Support Files/Pods-Social Hippo/Pods-Social Hippo-Acknowledgements.plist', 'Resources/Settings.bundle/Acknowledgements.plist', :remove_destination => true)
end