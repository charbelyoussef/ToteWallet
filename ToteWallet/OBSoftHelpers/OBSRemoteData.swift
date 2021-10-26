//
//  OBSRemoteData.swift
//  platea
//
//  Created by Nadim Henoud on 4/2/16.
//  Copyright © 2016 OBSoft. All rights reserved.
//

import UIKit

class OBSRemoteData {
    var delegate: OBSRemoteDataDelegate? = nil
    var useQueue = true
    
    func getURL(command:String) -> String {
        return "\(Config.serverAPIURL)\(command)"
    }
    
    func getData(command: String, headers: [String:String]?, useQueue: Bool?)
    {
        let thisType = type(of: self)
        let className = String(describing: thisType)
        let url = self.getURL(command: command)
        OBSRemoteDataQueue.shared.append(storeInstance: self, url: url, method: "GET", store: className, params: nil, headers: nil, useQueue: useQueue)
    }
    
    func postData(command: String, data: [String:String], headers: [String:String]?, raw:[[String:Any]]? = nil , useQueue: Bool?)
    {
        let thisType = type(of: self)
        let className = String(describing: thisType)
        let url = self.getURL(command: command)
        OBSRemoteDataQueue.shared.append(storeInstance: self, url: url, method: "POST", store: className, params: data, headers: headers, data: raw, useQueue: useQueue)
    }
    
    func postDataImage(command: String, data: [String : String], headers: [String:String]?, image: UIImage?, imageName: String){
        let thisType = type(of: self)
        let className = String(describing: thisType)
        let url = self.getURL(command: command)
        OBSRemoteDataQueue.shared.append(storeInstance: self, url: url, method: "POST", store: className, params: data, headers: headers, useQueue: useQueue)
    }
    
    func parseResponse(data: Data?, response: URLResponse?, error: Error?, command : String) {}
    
    func parseError(response: URLResponse?, error: Error?, command : String) {
        self.delegate?.hasFinishedLoadingDataWithError(error: error)
    }
    
    func didNotLoadRemoteData(command: String) {
        self.delegate?.hasFinishedLoadingData(status: .didNotLoadRemoteData, message: "")
    }
    
    func parseJSON(data: Data) -> [String: AnyObject]? {
        var json: [String: AnyObject]?
        do {
            json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String : AnyObject]
            if json == nil {
                do {
                    let data = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    json = ["data":data as AnyObject]
                } catch {
                    return nil
                }
            }
        } catch {
            return nil
        }
        return json
    }
    
    func getBodyData(prefix:String="form", data:Array<Any?>) -> [[String:Any]] {
        var postData:[[String:Any]] = []
        for d in data {
            postData += parseData(prefix, d)
        }
        return postData
    }
    
    func getFormEncodedBodyData(prefix:String="form", data:Array<Any?>) -> [String:String] {
        var postData:[String:Any] = [:]
        for d in data {
            postData.merge(parseData(prefix, d, useNameAsKey: true)[0], uniquingKeysWith: {(_,new) in new})
        }
        return postData as! [String:String]
    }
    
    func parseData(_ k:String, _ v:Any?, useNameAsKey:Bool=false) -> [[String:Any]] {
        var postData:[[String:Any]] = []
        var d:[String:Any]=[:]
        
        switch v.self {
        case is [String: Any?]:
            for (_k,_v) in v as! [String: Any?] {
                let _d = parseData("\(k)[\(_k)]",_v,useNameAsKey: useNameAsKey)
                if useNameAsKey == true {
                    d.merge(_d[0], uniquingKeysWith: {(_,new) in new})
                } else {
                    postData += _d
                }
            }
            break
        case is Array<Any?>:
            for (_k,_v) in (v as! Array<Any?>).enumerated() {
                let _d = parseData("\(k)[\(_k)]", _v, useNameAsKey: useNameAsKey)
                if useNameAsKey == true {
                    d.merge(_d[0], uniquingKeysWith: {(_,new) in new})
                } else {
                    postData += _d
                }
            }
            break
        case is HTMLEncodable:
            let _v = (v as! HTMLEncodable)
            switch _v.type {
                case .array:
                    for __v in _v.value as! [Any?] {
                        let _d = parseData("\(k)[\(_v.key)]",__v,useNameAsKey: useNameAsKey)
                        if useNameAsKey == true {
                            d.merge(_d[0], uniquingKeysWith: {(_,new) in new})
                        } else {
                            postData += _d
                        }
                    }
                    break
                case .dictionary:
                    for __v in _v.value as! [String:Any?] {
                        let _d = parseData("\(k)[\(_v.key)]",__v,useNameAsKey: useNameAsKey)
                        if useNameAsKey == true {
                            d.merge(_d[0], uniquingKeysWith: {(_,new) in new})
                        } else {
                            postData += _d
                        }
                    }
                    break
                case .imageJPG:
                    if useNameAsKey == true { break }
                    d["name"] = "\(k)[\(_v.key)]" // var name
                    d["value"] = _v.value ?? "" // filename
                    if(_v.value != nil) {
                        d["mime"] = "image/jpg"
                        d["data"] = UIImage.load(fileName: _v.value as! String)!.jpegData(compressionQuality: 0.2)!
                    }
                case .imagePNG:
                    if useNameAsKey == true { break }
                    d["name"] = "\(k)[\(_v.key)]" // var name
                    d["value"] = _v.value ?? "" // filename
                    if(_v.value != nil) {
                        d["mime"] = "image/png"
                        d["data"] = UIImage.load(fileName: _v.value as! String)!.pngData()!
                    }
                case .filePDF:
                    if useNameAsKey == true { break }
                    d["name"] = "\(k)[\(_v.key)]" // var name
                    d["value"] = _v.value ?? "" // filename
                    if(_v.value != nil) {
                        let url = URL(fileURLWithPath: _v.value as! String)
                        d["mime"] = "application/pdf"
                        do {
                            d["data"] = try Data(contentsOf:url, options:[])
                        } catch {
                            print("File \(url) NOT FOUND in getBodyData")
                        }
                    }
                default:
                    if useNameAsKey {
                        let n = "\(k)[\(_v.key)]"
                        d[n] = "\(_v.value ?? "")"
                    } else {
                        d["name"] = "\(k)[\(_v.key)]"
                        d["value"] = "\(_v.value ?? "")"
                    }
                    break
                }
                break
            default:
                if useNameAsKey {
                    d[k] = "\(v ?? "")"
                } else {
                    d["name"] = k
                    d["value"] = "\(v ?? "")"
                }
                break
        }
        if d.count > 0 {
            postData.append(d)
        }
        return postData
    }
}

class OBSRemoteDataQueue:NSObject { //:URLSessionDataTask
    static private var instance:OBSRemoteDataQueue?=nil
    
    let urlSession:URLSession = URLSession(configuration: .ephemeral, delegate: OBSSessionDelegate(), delegateQueue: OperationQueue.main)
    private var queue:[RemoteDataRequest]
    private var stores:[Int:OBSRemoteData] = [:]
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    var counter = 1
    var isOffline = false
    var isSyncing = false
    var shouldSync = true
//    var maxThreads = 5
//    var runningThreads:Int {
//        get {
//            return queue.filter({$0.processing == true}).count
//        }
//    }
    
    override private init(){
        queue = OBSRequestStore.shared.requests()
        counter = queue.count
        super.init();
        urlSession.configuration.httpShouldUsePipelining = true
        urlSession.configuration.httpMaximumConnectionsPerHost = 5
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityDidChange(notification:)), name: .reachabilityChanged, object: OBSReachability.shared?.reachability)
    }
    
    @objc private func reachabilityDidChange(notification: NSNotification) {
        processQueue()
    }
    
    static var shared:OBSRemoteDataQueue{
        get {
            if instance==nil{
                instance=OBSRemoteDataQueue()
            }
            return instance!
        }
    }
    
    func append(storeInstance: OBSRemoteData, url: String, method: String, store:String, params: [String:String]?, headers: [String:String]?, data: [[String:Any]]? = nil, useQueue: Bool?) {
        let id = Int(Date().timeIntervalSince1970) * 1000 + Int.random(in: 0...999)
        counter = counter+1;
        let useThatQueue = useQueue ?? storeInstance.useQueue
        if useThatQueue == false {
            if (OBSReachability.shared?.reachability?.connection == .unavailable) {
                storeInstance.didNotLoadRemoteData(command: url)
                return
            }
            
            let request = OBSRequestStore.shared.createRequest(id: id, url: url, method: method, store: store, params: params, headers: headers, data: data, persistent: false)
            stores[request.id] = storeInstance;
            if method == "GET" {
                self.getData(request: request, useQueue: false)
            } else if method == "POST" {
                self.postData(request: request, useQueue: false)
            }
            return
        }
        let request = OBSRequestStore.shared.createRequest(id: id, url: url, method: method, store: store, params: params, headers: headers, data: data)
        stores[request.id] = storeInstance;
        queue.append(request)
        processQueue(currentRequest: request)
    } 
    
    func processQueue(currentRequest: RemoteDataRequest? = nil) {
        if (OBSReachability.shared?.reachability?.connection != .unavailable) && shouldSync {
            if(isOffline) {
                isSyncing = queue.count > 0
                isOffline = false
                NotificationCenter.default.post(name: .queueStateChanged, object: self)
            }
            var q:RemoteDataRequest? = self.queue.first(where: {$0.processing != true})
//            while runningThreads <= maxThreads && q != nil {
            while q != nil {
                if q!.method == "GET" {
                    q!.processing = true
                    getData(request: q!)
                } else if q!.method == "POST" {
                    q!.processing = true
                    postData(request: q!)
                }
                q = self.queue.first(where: {$0.processing != true})
            }
        } else {
            isOffline = true
            isSyncing = false
            guard let id = currentRequest?.id else { return }
            stores[id]?.didNotLoadRemoteData(command: currentRequest!.url)
        }
    }
    
    func remove(request: RemoteDataRequest) {
        let index = self.queue.firstIndex(where: { (req) -> Bool in
            req.id == request.id
        })
        if index != nil {
            self.queue.remove(at: index!)
        }
        self.stores.removeValue(forKey: request.id)
        OBSRequestStore.shared.removeRequest(id: request.id)
        queue = OBSRequestStore.shared.requests()
        if(self.queue.count == 0 && isSyncing) {
            isSyncing = false
            NotificationCenter.default.post(name: .queueStateChanged, object: self)
        }
    }
    
    func getData(request: RemoteDataRequest, useQueue: Bool = true)
    {
        let url = request.url
//        print(url)
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let nsurl = URL(string: url)
        var r = URLRequest(url: nsurl!)
        
        if OBSUser.shared.wsse != nil {
            r.addValue((OBSUser.shared.wsse!.generateToken()), forHTTPHeaderField: "x-wsse")
        }
        
//        let urlSession = URLSession(configuration: URLSessionConfiguration.default, delegate: OBSSSLPinningDelegate(), delegateQueue: nil)
        self.processRequest(r: r, request: request, useQueue: useQueue)
    }
    
    
    func postData(request: RemoteDataRequest, useQueue: Bool = true)
    {
        let url = request.url
//        print(url)
        let reqBoundary = "BOUNDARY-----OBSOFT------88---"
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let nsurl = URL(string: url)
        var r = URLRequest(url: nsurl!)
        r.httpMethod = "POST"
        r.setValue("multipart/form-data; boundary=\(reqBoundary)", forHTTPHeaderField: "Content-Type")
        
//        let httpBody = NSMutableData()
//        for param in data{
//            httpBody.append("--\(reqBoundary)\r\n".data(using: .utf8)!)
//            httpBody.append("Content-Disposition: form-data; name=\"\(param.0)\"\r\n\r\n".data(using: .utf8)!)
//            httpBody.append("\(param.1)\r\n".data(using: .utf8)!)
//        }
        r.httpBody = createBody(parameters: request.parameters, boundary: reqBoundary)
        
        if OBSUser.shared.wsse != nil {
            r.addValue((OBSUser.shared.wsse!.generateToken()), forHTTPHeaderField: "x-wsse")
        }
//        if(request.headers != nil){
            for (key,value) in request.headers {
                r.addValue(value, forHTTPHeaderField: key)
            }
//        }
//        let urlSession = URLSession(configuration: URLSessionConfiguration.default, delegate: OBSSSLPinningDelegate(), delegateQueue: nil)
        self.processRequest(r: r, request: request, useQueue: useQueue)
        
    }
    
    func createBody(parameters: [RemoteDataRequestParam], boundary: String) -> Data {
        let body = NSMutableData()

        let boundaryPrefix = "--\(boundary)\r\n"

        body.appendString(boundaryPrefix)
        for param in parameters {
            if param.mime == "image/jpg" || param.mime == "image/png" || param.mime == "application/pdf" {
                body.appendString("Content-Disposition: form-data; name=\"\(param.name)\"; filename=\"\(param.value)\"\r\n")
                body.appendString("Content-Type: \(param.mime!)\r\n\r\n")
                body.append(param.data!)
                body.appendString("\r\n")
            } else {
                body.appendString("Content-Disposition: form-data; name=\"\(param.name)\"\r\n\r\n")
                body.appendString("\(param.value)\r\n")
            }
            body.appendString(boundaryPrefix)
        }

        return body as Data
    }

    
    func processRequest(r: URLRequest, request: RemoteDataRequest, useQueue: Bool) {
        
//        print(request.id)
        let task = urlSession.dataTask(with: r) { (data, response, error) -> Void in
            DispatchQueue.main.async() { () -> Void in
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                //EXCEPTION if response is nil it should retry (bad connection)s
                if response == nil {
                    self.processRequest(r: r, request: request, useQueue: useQueue)
                } else if (response as! HTTPURLResponse).statusCode == 403 || (response as! HTTPURLResponse).statusCode == 401 {
                    NotificationCenter.default.post(name: .requestNeedsAuthentication, object: self)
                    self.stores[request.id]?.parseError(response: response, error: error, command: request.url)
                    self.shouldSync = false
                } else {
                    if !self.shouldSync {
                        self.processQueue()
                    }
                    self.shouldSync = true
                    if (response as! HTTPURLResponse).statusCode == 500 {
                        NotificationCenter.default.post(name: .requestFailedFromServer, object: self)
                        self.stores[request.id]?.parseError(response: response, error: error, command: request.url)
                    } else {
                        self.stores[request.id]?.parseResponse(data: data, response: response, error: error, command: request.url)
                    }
                    if Config.useCoreData {
                        self.remove(request: request)
                    }
                }
                if useQueue {
                    var rr = OBSRequestStore.shared.findRequest(id: request.id)
                    if rr.count > 0 {
                        rr[0].processing = false
                    }
                }
            }
        }
        task.resume()
    }
}

extension NSMutableData {
    func appendString(_ string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: false)
        append(data!)
    }
}


protocol OBSRemoteDataDelegate
{
    func hasFinishedLoadingData(status: OBSRemoteDataStatus.Name,message: String)
    func hasFinishedLoadingDataWithError(error: Error?)
}

extension Notification.Name {
    static let queueStateChanged = Notification.Name("QueueStateChanged")
    static let requestNeedsAuthentication = Notification.Name("RequestNeedsAuthentication")
    static let requestFailedFromServer = Notification.Name("RequestFailedFromServer")
}

class OBSRemoteDataStatus : Equatable {
    
    var name: OBSRemoteDataStatus.Name
    
    init(name: OBSRemoteDataStatus.Name, object: Any? = nil, userInfo: [AnyHashable : Any]? = nil) {
        self.name = name
    }
    
    typealias Name = NSNotification.Name
    
    /// Compare two notifications for equality.
    static func == (lhs: OBSRemoteDataStatus, rhs: OBSRemoteDataStatus) -> Bool {
        return lhs.name == rhs.name
    }
}

extension OBSRemoteDataStatus.Name {
    static let HTTPForbidden = OBSRemoteDataStatus.Name("HTTPForbidden") // 403
    static let HTTPSuccess = OBSRemoteDataStatus.Name("HTTPSuccess") // 200
    static let HTTPServerError = OBSRemoteDataStatus.Name("HTTPServerError") // 500
    static let didLoadRemoteData = OBSRemoteDataStatus.Name("didLoadRemoteData")
    static let didNotLoadRemoteData = OBSRemoteDataStatus.Name("didNotLoadRemoteData")
}

protocol HTMLEncodable {
    var type:HTMLEncodableType.Name {get set}
    var key:String {get set}
    var value:Any? {get set}
}

class HTMLEncodableData: HTMLEncodable {
    var type:HTMLEncodableType.Name
    var key:String
    var value:Any?
    
    init(key: String, value: Any?, type:HTMLEncodableType.Name = .string) {
        self.key = key
        self.value = value
        self.type = type
    }
}

class HTMLEncodableType : Equatable {
    
    var name: OBSRemoteDataStatus.Name
    
    init(name: OBSRemoteDataStatus.Name, object: Any? = nil, userInfo: [AnyHashable : Any]? = nil) {
        self.name = name
    }
    
    typealias Name = NSNotification.Name
    
    /// Compare two notifications for equality.
    static func == (lhs: HTMLEncodableType, rhs: HTMLEncodableType) -> Bool {
        return lhs.name == rhs.name
    }
    
}

extension HTMLEncodableType.Name {
    static let string = HTMLEncodableType.Name("String")
    static let array = HTMLEncodableType.Name("Array")
    static let dictionary = HTMLEncodableType.Name("Dictionary")
    static let imageJPG = HTMLEncodableType.Name("ImageJPG")
    static let imagePNG = HTMLEncodableType.Name("ImagePNG")
    static let filePDF = HTMLEncodableType.Name("FilePDF")
}
