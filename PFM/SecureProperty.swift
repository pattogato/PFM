//
//  SecureProperty.swift
//  hero2
//
//  Created by Bence Pattogato on 19/09/16.
//

import Locksmith

fileprivate let BundleIdentifier: String = Bundle.main.bundleIdentifier!
fileprivate let ValueKey: String = "value"

public final class SecureProperty<T: Any> {
    
    public let account: String
    public let propertyName: String
    
    public var value: T? {
        didSet {
            // If a value exists, replace it
            if let changedValue = value {
                do {
                    try Locksmith.updateData(
                        data: [ValueKey: changedValue],
                        forUserAccount: account,
                        inService: propertyName)
                } catch let error {
                    print("[SP] Error saving data: \(error.localizedDescription)")
                }
            } else {
                // If it is cleared, delete from KeyChain
                do {
                    try Locksmith.deleteDataForUserAccount(
                        userAccount: account,
                        inService: propertyName)
                } catch let error {
                    print("[SP] Error deleting data: \(error.localizedDescription)")
                }
            }
        }
    }
    
    public init(propertyName: String, account: String = BundleIdentifier) {
        self.account = account
        self.propertyName = propertyName
        
        // Try to load data from the keychain (if exists)
        if let data = Locksmith.loadDataForUserAccount(
            userAccount: account,
            inService: propertyName),
            let loadedValue = data[ValueKey] as? T {
            value = loadedValue
        } else {
            print("[SP] Error loading \(propertyName)")
            value = nil
        }
    }
    
}

protocol SecurePropertyUserProtocol: class {
    static func cleanSecureProperties()
}

final class SecurePropertyCleaner {
    // Clean all classes that extend the cleanable protocol
    class func clean() {
        for aClass in Bundle.getObjectiveCClassList() {
            if let cleanableClass = aClass as? SecurePropertyUserProtocol.Type {
                cleanableClass.cleanSecureProperties()
            }
        }
    }
}

// Bundle

extension Bundle {
    class func getObjectiveCClassList() -> [AnyClass] {
        let expectedClassCount = objc_getClassList(nil, 0)
        let allClasses = UnsafeMutablePointer<AnyClass?>.allocate(capacity: Int(expectedClassCount))
        let autoreleasingAllClasses = AutoreleasingUnsafeMutablePointer<AnyClass?>(allClasses)
        let actualClassCount:Int32 = objc_getClassList(autoreleasingAllClasses, expectedClassCount)
        
        var classes = [AnyClass]()
        for i in 0 ..< actualClassCount {
            if let currentClass: AnyClass = allClasses[Int(i)] {
                classes.append(currentClass)
            }
        }
        
        allClasses.deallocate(capacity: Int(expectedClassCount))
        
        return classes
    }
}
