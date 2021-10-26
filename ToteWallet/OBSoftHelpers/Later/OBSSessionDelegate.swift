//
//  OBSSSLPinningDelegate.swift
//  Isaca
//
//  Created by OB Soft on 10/11/17.
//  Copyright © 2017 Obsoft. All rights reserved.
//

import Foundation
import Security

class OBSSessionDelegate: NSObject, URLSessionDelegate, URLSessionDataDelegate {
    // Initiating Connections
//    func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
//        // test
//        print("test");
//    }
    
    // SSL Pinning
    private func _urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        if (challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust) {
            if let serverTrust = challenge.protectionSpace.serverTrust {
                var secresult = SecTrustResultType.invalid
//                var cferror = CFError()
                let status = SecTrustEvaluate(serverTrust, &secresult)
                
                if (errSecSuccess == status) {
                    if let serverCertificate = SecTrustGetCertificateAtIndex(serverTrust, 0) {
                        let serverCertificateData = SecCertificateCopyData(serverCertificate)
                        let data = CFDataGetBytePtr(serverCertificateData);
                        let size = CFDataGetLength(serverCertificateData);
                        let cert1 = NSData(bytes: data, length: size).base64EncodedData(options: NSData.Base64EncodingOptions.endLineWithCarriageReturn) as NSData
                        let file_der = Bundle.main.path(forResource: challenge.protectionSpace.host, ofType: "crt")
                        
                        if let file = file_der {
                            if let cert2 = NSData(contentsOfFile: file) {
                                if cert1.isEqual(to: cert2 as Data) {
                                    completionHandler(URLSession.AuthChallengeDisposition.useCredential, URLCredential(trust:serverTrust))
                                    return
                                }
                            }
                        }
                    }
                }
            }
        }
        print("SSL Pinning Failed")
        // Pinning failed
        completionHandler(URLSession.AuthChallengeDisposition.cancelAuthenticationChallenge, nil)
    }
    
}
