//
//  KeychainHelper.swift
//  
//
//  Created by Valentin Perignon on 15/09/2022.
//

import Foundation

enum KeychainError: Error {
    case cannotSavePassword
    case cannotFindElement
    case cannotRemoveElement
}

struct KeychainHelper {
    public static func save(password: String, for account: String) throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: account,
            kSecValueData as String: password.data(using: .utf8)!
        ]
        let status = SecItemAdd(query as CFDictionary, nil)
        if status != noErr {
            throw KeychainError.cannotSavePassword
        }
    }

    public static func getPassword(for account: String) throws -> String {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: account,
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecReturnAttributes as String: true,
            kSecReturnData as String: true
        ]

        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)

        guard status == noErr,
              let existingItem = item as? [String: Any],
              let tokenData = existingItem[kSecValueData as String] as? Data,
              let password = String(data: tokenData, encoding: .utf8)
        else { throw KeychainError.cannotFindElement }

        return password
    }

    public static func removePassword(for account: String) throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: account
        ]
        let status = SecItemDelete(query as CFDictionary)
        if status != noErr {
            throw KeychainError.cannotRemoveElement
        }
    }
}
