//
//  DALHelper.swift
//  hero2
//
//  Created by Bence Pattogato on 19/09/16.
//

import RealmSwift
import Foundation

public typealias RealmBlock = (Realm) -> Void
public typealias InMemoryConfiguration = (inMemoryIdentifier: String, types: [Object.Type])

public protocol DALHelperProtocol {
    var realmConfiguration: Realm.Configuration! { get }
    
    /**
     Write into the main realm with automatically opened and closed transaction.
     Should be called from the main thread.
     
     - parameter block: The in-transaction block
     */
    func writeInMainRealm(_ block: RealmBlock)
    
    /**
     Write into a realm with automatically opened and closed transaction.
     
     - parameter block:         The in-transaction block
     */
    func writeInRealm(block: RealmBlock)
    
    /**
     Write into a realm with automatically opened and closed transaction.
     
     - parameter existingRealm: Optionally provide a realm instance
     - parameter block:         The in-transaction block
     */
    func writeInRealm(realm existingRealm: Realm?, block: RealmBlock)
    
    /**
     Read block dispatched to the main realm.
     
     - parameter block: The read block with the realm.
     */
    func readFromMainRealm(_ block: @escaping RealmBlock)
    
    /**
     Create a new realm with the shared configuration
     
     - returns: New Realm instance
     */
    func newRealm() -> Realm
    
    /**
     Deletes all objects from the persistent database
     */
    func clearDatabase()
    
    /**
     Deletes all object from the given database
     - parameter: realm: Existing realm instance
     */
    func clearDatabase(in realm: Realm)
    
    func createInMemoryDatabaseConfiguration(configuration: InMemoryConfiguration) -> Realm.Configuration
}

public final class DALHelper: DALHelperProtocol {
    
    fileprivate var inMemoryConfigurations: [InMemoryConfiguration] = []
    let realm: Realm!
    public let realmConfiguration: Realm.Configuration!
    
    /**
     Configuration method that should be called from the Main Thread.
     
     - parameter encrypted:      Indicator wether the database should be encrypted
     - parameter schema0ion:  Optional schema version of the database
     - parameter migrationBlock: Optional migration block
     */
    public init(encrypted: Bool,
                schemaVersion: UInt64,
                migrationBlock: MigrationBlock? = nil) {
        
        assert(Thread.isMainThread, "DALHelper should only be initialized from the main thread.")
        
        let encryptionKey: Data?
        if encrypted {
            encryptionKey = DALHelper.loadEncryptionKey()
        } else {
            encryptionKey = nil
        }
        
        realmConfiguration = Realm.Configuration(
            fileURL: URL.realmUrl(),
            inMemoryIdentifier: nil,
            encryptionKey: encryptionKey,
            readOnly: false,
            schemaVersion: schemaVersion,
            migrationBlock: migrationBlock,
            deleteRealmIfMigrationNeeded: false,
            objectTypes: nil)
        
        do {
            realm = try Realm(configuration: realmConfiguration)
            print("[REALM] Path: \(URL.realmUrl())")
        } catch let error as NSError {
            // If the encryption key is wrong, `error` will say that it's an invalid database
            fatalError("Error opening realm: \(error) TRY TO DELETE APP FROM DEVICE")
        }
    }
    
    /**
     Load the encryption key
     - if one exists, return it
     - if none exists, generate and save new one
     */
    private class func loadEncryptionKey() -> Data {
        let storedKey = SecureProperty<Data>(propertyName: "realmEncryptionKey")
        
        // Check if the key is available in the keychain
        if let key = storedKey.value {
            print("[REALM] Key loaded: \(key.hexadecimalString)")
            return key
        } else {
            // If no key is set up yet
            
            // Generate a random encryption key
            var key = Data(count: 64)
            _ = key.withUnsafeMutableBytes { bytes in
                SecRandomCopyBytes(kSecRandomDefault, 64, bytes)
            }
            storedKey.value = key
            
            print("[REALM] Key generated: \(key.hexadecimalString)")
            return key
        }
    }
    
}

public extension DALHelper {
    
    public func writeInMainRealm(_ block: RealmBlock) {
        assert(Thread.isMainThread, "The main realm is only accessible from the main thread.")
        writeInRealm(realm: realm, block: block)
    }
    
    public func writeInRealm(block: (Realm) -> Void) {
        writeInRealm(realm: nil, block: block)
    }
    public func writeInRealm(realm existingRealm: Realm?, block: RealmBlock) {
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
    
    public func readFromMainRealm(_ block: @escaping RealmBlock) {
        DispatchQueue.main.async(execute: { () -> Void in
            block(self.realm)
        })
    }
    
    public func newRealm() -> Realm {
        return try! Realm(configuration: realmConfiguration)
    }
    
    public func clearDatabase() {
        // Delete default realm data
        writeInRealm { (realm) in
            realm.deleteAll()
        }
        
        for inMemoryConfigDescriptor in inMemoryConfigurations {
            let config = createInMemoryDatabaseConfiguration(configuration: inMemoryConfigDescriptor)
            guard let inMemoryRealm = try? Realm(configuration: config) else {
                continue
            }
            
            writeInRealm(realm: inMemoryRealm, block: { (realm) in
                realm.deleteAll()
            })
        }
    }
    
    public func clearDatabase(in realm: Realm) {
        writeInRealm(realm: realm) { (realm) in
            realm.deleteAll()
        }
    }
    
    public func createInMemoryDatabaseConfiguration(configuration: InMemoryConfiguration) -> Realm.Configuration {
        
        let config = Realm.Configuration(inMemoryIdentifier: configuration.inMemoryIdentifier, objectTypes: configuration.types)
        
        if inMemoryConfigurations.contains(where: { $0.inMemoryIdentifier == configuration.inMemoryIdentifier }) {
            return config
        }
        
        inMemoryConfigurations.append(configuration)
        return config
    }
}

fileprivate extension URL {
    
    static func realmUrl() -> URL {
        return realmDirectoryURL().appendingPathComponent("Database").appendingPathExtension("realm")
    }
    
    static func realmDirectoryURL() -> URL {
        
        guard let documentsDirectoryPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first
            else {
                assertionFailure("Documents directory cannot be accessed")
                return URL(string: "")!
        }
        
        let url = URL(fileURLWithPath: documentsDirectoryPath, isDirectory: true).appendingPathComponent("Realm").appendingPathExtension("bundle")
        
        if !FileManager.default.fileExists(atPath: url.path) {
            do { try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: [:]) }
            catch _ {
                assertionFailure("REALM Directory cannot be created.")
            }
        }
        
        return url
    }
    
}

fileprivate extension Data {
    
    var hexadecimalString : String {
        var str = ""
        enumerateBytes { buffer, index, stop in
            for byte in buffer {
                str.append(String(format:"%02x",byte))
            }
        }
        return str
    }
    
}
