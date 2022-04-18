//
//  Encryptionclass.swift
//  Utility
//
//  Created by admin on 15/03/21.
//

import UIKit
import SwiftyRSA
import CryptoSwift
import RNCryptor


struct Encryptionclass {
    
    

        
    static func encrypt(string: String?, publicKey: String?) -> String? {
        
    
        
        var textToEncrypt = publicKey
        if ( textToEncrypt == nil || textToEncrypt == "" ) {
            print("empty")

        }

        var encryptedData = RSAUtils.encryptWithRSAPublicKey(textToEncrypt!.data(using: String.Encoding.utf8)!, pubkeyBase64: string!, keychainTag: "com.SHMISCustomer.Sample_Public")
        if ( encryptedData == nil ) {
            print("empty")
        } else {
            let encryptedDataText = encryptedData!.base64EncodedString(options: NSData.Base64EncodingOptions())
            NSLog("Encrypted with pubkey: %@", encryptedDataText)
            textToEncrypt = encryptedDataText
        }

    return textToEncrypt

    
               
//                if let decryptedMessage:Data = SecKeyCreateDecryptedData(privateSecKey, .rsaEncryptionOAEPSHA256, encryptedMessageData as CFData,error) as Data?{
//                    print("We have an decrypted message \(String.init(data: decryptedMessage, encoding: .utf8)!)")
//                }
//                else{
//                    print("Error decrypting")
//                }

           

        
//            guard let publicKey = publicKey else { return nil }
//
//            let keyString = publicKey.replacingOccurrences(of: "-----BEGIN PUBLIC KEY-----\n", with: "").replacingOccurrences(of: "\n-----END PUBLIC KEY-----", with: "")
//            guard let data = Data(base64Encoded: keyString) else { return nil }
//
//            var attributes: CFDictionary {
//                return [kSecAttrKeyType         : kSecAttrKeyTypeRSA,
//                        kSecAttrKeyClass        : kSecAttrKeyClassPublic,
//                        kSecAttrKeySizeInBits   : 2048,
//                        kSecReturnPersistentRef : kCFBooleanTrue] as CFDictionary
//            }
//
//            var error: Unmanaged<CFError>? = nil
//            guard let secKey = SecKeyCreateWithData(data as CFData, attributes, &error) else {
//                print(error.debugDescription)
//                return nil
//            }
           
                
                //encrypt(string: string, publicKey: secKey)
 

//        static func encrypt(string: String, publicKey: SecKey) -> String? {
//            let buffer = [UInt8](string.utf8)
//
//            var keySize   = SecKeyGetBlockSize(publicKey)
//            var keyBuffer = [UInt8](repeating: 0, count: keySize)
//
//            // Encrypto  should less than key length
//            guard SecKeyEncrypt(publicKey, SecPadding.PKCS1, buffer, buffer.count, &keyBuffer, &keySize) == errSecSuccess else { return nil }
//            return Data(bytes: keyBuffer, count: keySize).base64EncodedString()
//        }
    
    }
    
}

