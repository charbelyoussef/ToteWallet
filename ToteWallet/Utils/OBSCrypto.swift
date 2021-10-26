//
//  Hash.swift
//  platea
//
//  Created by Nadim Henoud on 4/2/16.
//  Copyright © 2016 OBSoft. All rights reserved.
//

import Foundation

class OBSCrypto {
    func sha1(data : Data) -> Data {
        var hash = [UInt8](repeating: 0,  count: Int(CC_SHA1_DIGEST_LENGTH))
        data.withUnsafeBytes {
            _ = CC_SHA1($0.baseAddress, CC_LONG(data.count), &hash)
        }
        return Data(hash)
    }
    
    func sha256(data : Data) -> Data {
        var hash = [UInt8](repeating: 0,  count: Int(CC_SHA256_DIGEST_LENGTH))
        data.withUnsafeBytes {
            _ = CC_SHA256($0.baseAddress, CC_LONG(data.count), &hash)
        }
        return Data(hash)
    }
    
    func sha512(data : Data) -> Data {
        var hash = [UInt8](repeating: 0,  count: Int(CC_SHA512_DIGEST_LENGTH))
        data.withUnsafeBytes {
            _ = CC_SHA512($0.baseAddress, CC_LONG(data.count), &hash)
        }
        return Data(hash)
    }
    
}

extension String {
    func sha1() -> Data {
        return OBSCrypto().sha1(data: self.data(using: String.Encoding.utf8)!)
    }
    func sha256() -> Data {
        return OBSCrypto().sha256(data: self.data(using: String.Encoding.utf8)!)
    }
    func sha512() -> Data {
        return OBSCrypto().sha512(data: self.data(using: String.Encoding.utf8)!)
    }
}

extension Data {
    private static let hexAlphabet = "0123456789ABCDEF".unicodeScalars.map { $0 }
    
    public func hexEncodedString() -> String {
        return String(self.reduce(into: "".unicodeScalars, { (result, value) in
            result.append(Data.hexAlphabet[Int(value/16)])
            result.append(Data.hexAlphabet[Int(value%16)])
        }))
    }
}
