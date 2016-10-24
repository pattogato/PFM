platform :ios, '8.0'
use_frameworks!

def shared_pods
    pod 'RealmSwift', '~> 1.1.0' # Local database
    pod 'EZSwipeController', :git => 'https://github.com/pattogato/EZSwipeController', :branch => 'bugfix/swift-3-fixes'
    pod 'MBPullDownController', '~> 1.0'
    pod 'ALCameraViewController' , '~> 1.2.7'
    pod 'LocationPickerViewController', :git => 'https://github.com/JeromeTan1997/LocationPicker', :branch => 'swift-3'
    pod 'SwiftDate', '~> 4.0' # Date helper
end


target 'PFM' do
    shared_pods
end

target 'PFMTests' do
    shared_pods
end


