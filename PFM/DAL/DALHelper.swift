//
//  DALHelper.swift
//  Pods
//
//  Created by Andras on 25/03/16.
//
//

import RealmSwift

public class DALHelper: NSObject {
    
    private static var _sharedInstance: DALHelper!
    public private(set) static var sharedInstance: DALHelper {
        get {
            assert(_sharedInstance != nil, "DALHelper should be configured before first use.")
            return _sharedInstance
        }
        set {
            _sharedInstance = newValue
        }
    }
    
    let realm: Realm!
    public let realmConfiguration: Realm.Configuration!
    
    /**
     Configuration method that should be called from the Main Thread.
     
     - parameter encrypted:      Indicator wether the database should be encrypted
     - parameter schemaVersion:  Optional schema version of the database
     - parameter realmPath:      Optional realm path
     - parameter migrationBlock: Optional migration block
     */
    public class func configure(
        schemaVersion: UInt64 = 1,
        realmPath: String? = nil,
        migrationBlock: MigrationBlock? = nil
        ) {
        
        // Configure the shared instance on the main thread
        _sharedInstance = DALHelper(schemaVersion: schemaVersion,
                                    migrationBlock: migrationBlock)
        
    }
    
    init(schemaVersion: UInt64,
         migrationBlock: MigrationBlock? = nil) {
        
        
        realmConfiguration = Realm.Configuration(
            path: NSURL.realmUrl().path,
            inMemoryIdentifier: nil,
            encryptionKey: nil,
            readOnly: false,
            schemaVersion: schemaVersion,
            migrationBlock: migrationBlock,
            objectTypes: nil)
        
        do {
            realm = try Realm(configuration: realmConfiguration)
            print("[REALM] Path: \(realm.path)")
        } catch let error as NSError {
            fatalError("Error opening realm: \(error)")
        }
        
        super.init()
    }
    
}

extension NSData {
    
    var hexString : String {
        let buf = UnsafePointer<UInt8>(bytes)
        let charA = UInt8(UnicodeScalar("a").value)
        let char0 = UInt8(UnicodeScalar("0").value)
        
        func itoh(i: UInt8) -> UInt8 {
            return (i > 9) ? (charA + i - 10) : (char0 + i)
        }
        
        let p = UnsafeMutablePointer<UInt8>.alloc(length * 2)
        
        for i in 0..<length {
            p[i*2] = itoh((buf[i] >> 4) & 0xF)
            p[i*2+1] = itoh(buf[i] & 0xF)
        }
        
        return String(bytesNoCopy: p, length: length*2, encoding: NSUTF8StringEncoding, freeWhenDone: true)!
    }
}

public typealias RealmBlock = (Realm) -> Void

public extension DALHelper {
    
    /**
     Write into the main realm with automatically opened and closed transaction.
     
     - parameter block: The in-transaction block
     */
    public class func writeInMainRealm(block: RealmBlock) {
        writeInRealm(realm: self.sharedInstance.realm, block: block)
    }
    
    /**
     Write into a realm with automatically opened and closed transaction.
     
     - parameter existingRealm: Optionally provide a realm instance
     - parameter block:         The in-transaction block
     */
    public class func writeInRealm(realm existingRealm: Realm? = nil, block: RealmBlock) {
        // Get the realm instance
        let realm = existingRealm ?? newRealm()
        // Begin write transaction
        realm.beginWrite()
        // Write into the realm
        block(realm)
        // Commit write transaction
        do { try realm.commitWrite() }
        catch {}
    }
    
    /**
     Read block dispatched to the main realm.
     
     - parameter block: The read block with the realm.
     */
    public class func readFromMainRealm(block: RealmBlock) {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            block(self.sharedInstance.realm)
        })
    }
    
    /**
     Create a new realm with the shared configuration
     
     - returns: New Realm instance
     */
    public class func newRealm() -> Realm {
        return try! Realm(configuration: sharedInstance.realmConfiguration)
    }
    
}

extension NSURL {
    
    class func realmUrl() -> NSURL {
        return realmDirectoryURL().URLByAppendingPathComponent("Database").URLByAppendingPathExtension("realm")
    }
    
    class func realmDirectoryURL() -> NSURL {
        
        guard let documentsDirectoryPath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true).first
            else {
                assertionFailure("Documents directory cannot be accessed")
                return NSURL()
        }
        
        let url = NSURL(fileURLWithPath: documentsDirectoryPath, isDirectory: true).URLByAppendingPathComponent("Realm").URLByAppendingPathExtension("bundle")
        
        if let path = url.path {
            if !NSFileManager.defaultManager().fileExistsAtPath(path) {
                do { try NSFileManager.defaultManager().createDirectoryAtURL(url, withIntermediateDirectories: true, attributes: [:]) }
                catch _ {
                    assertionFailure("REALM Directory cannot be created.")
                }
            }
        }
        
        return url
    }
    
}