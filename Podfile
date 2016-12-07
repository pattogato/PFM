platform :ios, '9.0'
use_frameworks!

target 'PFM' do
    #DB
    pod 'RealmSwift', '~> 1.1.0' # Local database
    
    # Utils
    pod 'SwiftDate', '~> 4.0' # Date helper
    pod 'Locksmith', '~> 3.0.0' # Keychain wrapper
    
    # Async handling
    pod 'PromiseKit'
    
    #UI
    pod 'SVProgressHUD', '~> 2.0' # Progress indicator
    pod 'LocationPickerViewController', :git => 'https://github.com/JeromeTan1997/LocationPicker', :branch => 'swift-3'
    pod 'EZSwipeController', :git => 'https://github.com/pattogato/EZSwipeController', :branch => 'bugfix/swift-3-fixes'
    pod 'MBPullDownController', '~> 1.0'
    pod 'Charts/Realm' # Presenting beautifil charts
    pod 'KMPlaceholderTextView', '~> 1.3.0' # UITextField with placeholder
    pod 'SnapKit', '~> 3.0' # Constraints handling
    
    # Dependency indejction
    pod 'Swinject', '~> 2.0.0-beta.2' # DI Tool
    pod 'SwinjectStoryboard', '~> 1.0.0-beta.2' # DI Tool for storyboards
    
    # Facebook
    pod 'FacebookCore', '~> 0.2.0'
    pod 'FacebookLogin', '~> 0.2.0'
    pod 'FacebookShare', '~> 0.2.0’
    
    # Networking
    pod 'Alamofire', '~> 4.0.0' # Networking
    pod 'AlamofireObjectMapper', '~> 4.0.0' # Network object mapping
    pod 'AlamofireActivityLogger', '~> 2.0.0' # Network loggin
    pod 'AlamofireImage', '~> 3.0.0' # Image loader
    pod 'AlamofireNetworkActivityIndicator' # Network Activity indicator
    
    target 'PFMTests' do
        inherit! :search_paths
        # Additional Pods
    end
    
end


