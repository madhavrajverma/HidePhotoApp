//
//  StoreKeyInKeycahin.swift
//  HidePhotos
//
//  Created by Lakshya  Verma on 07/08/22.
//

import Foundation
import CryptoKit
import Security


// This code Is from Apple official Documentation

/// The interface needed for SecKey conversion.
protocol GenericPasswordConvertible: CustomStringConvertible {
    /// Creates a key from a raw representation.
    init<D>(rawRepresentation data: D) throws where D: ContiguousBytes
    
    /// A raw representation of the key.
    var rawRepresentation: Data { get }
}

extension GenericPasswordConvertible {
    /// A string version of the key for visual inspection.
    /// IMPORTANT: Never log the actual key data.
    public var description: String {
        return self.rawRepresentation.withUnsafeBytes { bytes in
            return "Key representation contains \(bytes.count) bytes."
        }
    }
}

// Ensure that SymmetricKey is generic password convertible.
extension SymmetricKey: GenericPasswordConvertible {
    
    init<D>(rawRepresentation data: D) throws where D: ContiguousBytes {
        self.init(data: data)
    }
    
    var rawRepresentation: Data {
        return dataRepresentation  // Contiguous bytes repackaged as a Data instance.
    }
}


struct KeyStoreError: Error, CustomStringConvertible {
    var message: String
    
    init(_ message: String) {
        self.message = message
    }
    
    public var description: String {
        return message
    }
}

extension OSStatus {
    
    /// A human readable message for the status.
    var message: String {
        return (SecCopyErrorMessageString(self, nil) as String?) ?? String(self)
    }
}



struct KeyStoreManager {
    
    /// Stores a CryptoKit key in the keychain as a generic password.
    func storeKey<T: GenericPasswordConvertible>(_ key: T, account: String) throws {

        // Treat the key data as a generic password.
        let query = [kSecClass: kSecClassGenericPassword,
                     kSecAttrAccount: account,
                     kSecAttrAccessible: kSecAttrAccessibleWhenUnlocked,
                     kSecUseDataProtectionKeychain: true,
                     kSecValueData: key.rawRepresentation] as [String: Any]
        
        // Add the key data.
        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else {
            throw KeyStoreError("Unable to store item: \(status.message)")
        }
    }
    
    /// Reads a CryptoKit key from the keychain as a generic password.
    func readKey<T: GenericPasswordConvertible>(account: String) throws -> T? {

        // Seek a generic password with the given account.
        let query = [kSecClass: kSecClassGenericPassword,
                     kSecAttrAccount: account,
                     kSecUseDataProtectionKeychain: true,
                     kSecReturnData: true] as [String: Any]
        
        // Find and cast the result as data.
        var item: CFTypeRef?
        switch SecItemCopyMatching(query as CFDictionary, &item) {
        case errSecSuccess:
            guard let data = item as? Data else { return nil }
            return try T(rawRepresentation: data)  // Convert back to a key.
        case errSecItemNotFound: return nil
        case let status: throw KeyStoreError("Keychain read failed: \(status.message)")
        }
    }
    
    func getKey<T: GenericPasswordConvertible>(account:String) throws -> T  {
        guard let key: T = try readKey(account: account) else {
            throw KeyStoreError("Failed to locate stored key.")
        }
        return key
    }
    
    /// Stores a key in the keychain and then reads it back.
    func roundTrip<T: GenericPasswordConvertible>(_ key: T) throws -> T {

        // An account name for the key in the keychain.
        let account = "com.example.genericpassword.key"

        // Start fresh.
        try deleteKey(account: account)

        // Store and read it back.
        try storeKey(key, account: account)
        
        guard let key: T = try readKey(account: account) else {
            throw KeyStoreError("Failed to locate stored key.")
        }
        return key
    }
    
    /// Removes any existing key with the given account.
    func deleteKey(account: String) throws {
        let query = [kSecClass: kSecClassGenericPassword,
                     kSecUseDataProtectionKeychain: true,
                     kSecAttrAccount: account] as [String: Any]
        switch SecItemDelete(query as CFDictionary) {
        case errSecItemNotFound, errSecSuccess: break // Okay to ignore
        case let status:
            throw KeyStoreError("Unexpected deletion error: \(status.message)")
        }
    }
}


extension ContiguousBytes {
    /// A Data instance created safely from the contiguous bytes without making any copies.
    var dataRepresentation: Data {
        return self.withUnsafeBytes { bytes in
            let cfdata = CFDataCreateWithBytesNoCopy(nil, bytes.baseAddress?.assumingMemoryBound(to: UInt8.self), bytes.count, kCFAllocatorNull)
            return ((cfdata as NSData?) as Data?) ?? Data()
        }
    }
}

