platform :ios, '8.0'
use_frameworks!

def shared_pods
    #DB
    pod 'RealmSwift', '~> 1.1.0' # Local database
    
    # Utils
    pod 'SwiftDate', '~> 4.0' # Date helper
    
    # Async handling
    pod 'PromiseKit'
    
    #UI
    pod 'SVProgressHUD', '~> 2.0' # Progress indicator
    pod 'LocationPickerViewController', :git => 'https://github.com/JeromeTan1997/LocationPicker', :branch => 'swift-3'
    pod 'EZSwipeController', :git => 'https://github.com/pattogato/EZSwipeController', :branch => 'bugfix/swift-3-fixes'
    pod 'MBPullDownController', '~> 1.0'
    
    # Dependency indejction
    pod 'Swinject', '~> 2.0.0-beta.2' # DI Tool
    pod 'SwinjectStoryboard', '~> 1.0.0-beta.2' # DI Tool for storyboards
end


target 'PFM' do
    shared_pods
end

target 'PFMTests' do
    shared_pods
end


