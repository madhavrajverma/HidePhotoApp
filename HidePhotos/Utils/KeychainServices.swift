//
//  KeychainServices.swift
//  HidePhotos
//
//  Created by Lakshya  Verma on 05/08/22.
//

import Foundation

struct KeychainWrapperError: Error {
  var message: String?
  var type: KeychainErrorType

  enum KeychainErrorType {
    case badData
    case servicesError
    case itemNotFound
    case unableToConvertToString
  }

  init(status: OSStatus, type: KeychainErrorType) {
    self.type = type
    if let errorMessage = SecCopyErrorMessageString(status, nil) {
      self.message = String(errorMessage)
    } else {
      self.message = "Status Code: \(status)"
    }
  }

  init(type: KeychainErrorType) {
    self.type = type
  }

  init(message: String, type: KeychainErrorType) {
    self.message = message
    self.type = type
  }
}

class KeychainWrapper {
    
 // Store Password in Key chain
  func storeGenericPasswordFor(account: String, service: String, password: String) throws {
  
      // checking if password is empty or not
      if password.isEmpty {
      try deleteGenericPasswordFor(account: account, service: service)
      return
    }
   
      // converting password into password data using .utf8 string encodings
      guard let passwordData = password.data(using: .utf8) else {
      print("Error converting value to data.")
      throw KeychainWrapperError(type: .badData)
    }

   
      // create a query
    let query: [String: Any] = [
     
      kSecClass as String: kSecClassGenericPassword,
     
      kSecAttrAccount as String: account,
      
      kSecAttrService as String: service,
    
      kSecValueData as String: passwordData
    ]

      
    // adding  password in keychain using SecItemADD method
    let status = SecItemAdd(query as CFDictionary, nil)
      
    // checking of status
      
    switch status {
   
    case errSecSuccess:
      break
    case errSecDuplicateItem:
      try updateGenericPasswordFor(
        account: account,
        service: service,
        password: password)
    
    default:
      throw KeychainWrapperError(status: status, type: .servicesError)
    }
  }

    
  func getGenericPasswordFor(account: String, service: String) throws -> String {
      
    let query: [String: Any] = [
    
      kSecClass as String: kSecClassGenericPassword,
      kSecAttrAccount as String: account,
      kSecAttrService as String: service,
   
      kSecMatchLimit as String: kSecMatchLimitOne,
      kSecReturnAttributes as String: true,
     
      kSecReturnData as String: true
    ]

    var item: CFTypeRef?
    let status = SecItemCopyMatching(query as CFDictionary, &item)
    guard status != errSecItemNotFound else {
      throw KeychainWrapperError(type: .itemNotFound)
    }
    guard status == errSecSuccess else {
      throw KeychainWrapperError(status: status, type: .servicesError)
    }

    guard let existingItem = item as? [String: Any],
    
      let valueData = existingItem[kSecValueData as String] as? Data,
    
      let value = String(data: valueData, encoding: .utf8)
      else {
       
        throw KeychainWrapperError(type: .unableToConvertToString)
    }

   
    return value
  }

  func updateGenericPasswordFor( account: String, service: String,password: String ) throws {
      
    guard let passwordData = password.data(using: .utf8) else {
      print("Error converting value to data.")
      return
    }
    
    let query: [String: Any] = [
      kSecClass as String: kSecClassGenericPassword,
      kSecAttrAccount as String: account,
      kSecAttrService as String: service
    ]

   
    let attributes: [String: Any] = [
      kSecValueData as String: passwordData
    ]

   
    let status = SecItemUpdate(query as CFDictionary, attributes as CFDictionary)
    guard status != errSecItemNotFound else {
      throw KeychainWrapperError(message: "Matching Item Not Found", type: .itemNotFound)
    }
    guard status == errSecSuccess else {
      throw KeychainWrapperError(status: status, type: .servicesError)
    }
  }

  func deleteGenericPasswordFor(account: String, service: String) throws {
   
    let query: [String: Any] = [
      kSecClass as String: kSecClassGenericPassword,
      kSecAttrAccount as String: account,
      kSecAttrService as String: service
    ]

    
    let status = SecItemDelete(query as CFDictionary)
    guard status == errSecSuccess || status == errSecItemNotFound else {
      throw KeychainWrapperError(status: status, type: .servicesError)
    }
  }
}

