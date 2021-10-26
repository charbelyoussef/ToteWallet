//
//  OBSRequest.swift
//  EyeQLab
//
//  Created by Nadim Henoud on 4/22/19.
//  Copyright © 2019 OBSoft. All rights reserved.
//

import Foundation
import CoreData

class OBSRequestStore: OBSStore {
    private var _requests:[RemoteDataRequest]=[]
    static private var instance:OBSRequestStore?=nil
    
    static var shared:OBSRequestStore{
        get {
            if instance==nil{
                instance=OBSRequestStore()
            }
            return instance!
        }
    }
    
    init() {
        super.init(entityName: "CDRequest", modelName: "Core")
    }
    
    func createRequest(id: Int, url: String, method: String, store:String, params: [String:String]?, headers: [String:String]?, data:[[String:Any]]?, persistent:Bool=true) -> RemoteDataRequest {
        
        var _parameters:[[String:Any]] = []
        if params != nil {
            for x in params!{
                var item:[String:String] = [:]
                item["name"]=x.key
                item["value"]=x.value
                _parameters.append(item)
            }
        }
        
        if data != nil {
            _parameters += data!
        }
        
        if(Config.useCoreData) {
            return createCDRequest(id: id, url: url, method: method, store: store, params: _parameters, headers: headers, persistent: persistent)
        } else {
            return OBSBaseRequest(url: url, method: method, store: store, params: _parameters, headers: headers, persistent: persistent)
        }
    }
    
    func findRequest(id:Int)->[RemoteDataRequest]{
        if(Config.useCoreData) {
            let request=NSFetchRequest<CDRequest>(entityName: self.entityName)
            request.predicate=NSPredicate(format:"r_id == %@",NSNumber(value:id))
            do{
                return try OBSStore.corePersistentContainer.viewContext.fetch(request)
            }
            catch{
                return []
            }
        } else {
            return self._requests.filter({$0.id == id})
        }
    }
    
    func requests()->[RemoteDataRequest] {
        if(Config.useCoreData) {
            do{
                return try OBSStore.corePersistentContainer.viewContext.fetch(NSFetchRequest<CDRequest>(entityName: self.entityName))
            }
            catch{
                return []
            }
        } else {
            return self._requests
        }
    }
    
    func removeRequest(id:Int){
        if(Config.useCoreData) {
            for c in findRequest(id: id){
                OBSStore.corePersistentContainer.viewContext.delete(c as! CDRequest)
            }
        } else {
            self._requests.removeAll(where: {$0.id == id})
        }
    }
    
    func clean(persistent:Bool=false) {
        if(Config.useCoreData) {
            let request=NSFetchRequest<CDRequest>(entityName: self.entityName)
            if !persistent {
                request.predicate=NSPredicate(format:"r_persistent == false")
            }
            do{
                let requests = try OBSStore.corePersistentContainer.viewContext.fetch(request)
                for c in requests {
                    OBSStore.corePersistentContainer.viewContext.delete(c)
                }
            }
            catch{
                return
            }
        } else {
            if !persistent {
                self._requests.removeAll(where: {$0.persistent == persistent})
            } else {
                self._requests.removeAll()
            }
        }
    }
    
    func createCDRequest(id: Int, url: String, method: String, store:String, params: [[String:Any]]?, headers: [String:String]?, persistent:Bool) -> RemoteDataRequest {
        let c=NSEntityDescription.insertNewObject(forEntityName: self.entityName, into: OBSStore.corePersistentContainer.viewContext) as! CDRequest
        c.r_id=Int64(id)
        c.r_url=url
        c.r_method = method
        c.r_store = store
        c.r_processing = false
        c.r_persistent = persistent
        for param in params ?? [] {
            c.addToParams(CDParam.create(item: param))
        }
        
        if headers != nil {
            for x in headers!{
                let p=NSEntityDescription.insertNewObject(forEntityName: "CDHeaderOptions", into: OBSStore.corePersistentContainer.viewContext) as! CDHeaderOptions
                c.addToRequestheaders(p)
                p.key=x.key
                p.value=x.value
            }
        }
        
        return c
    }
}

protocol RemoteDataRequest{
    var id:Int{get}
    var url:String{get}
    var method:String {get}
    var store:String {get}
    var parameters:[RemoteDataRequestParam] {get}
    var headers:[String:String] {get}
    var processing: Bool {get set}
    var persistent: Bool {get set}
}
protocol RemoteDataRequestParam{
    var name:String{get}
    var value:String{get}
    var mime:String? {get}
    var data:Data? {get}
}

class OBSBaseRequest: RemoteDataRequest {
    var id: Int
    var url: String
    var method: String
    var store: String
    var parameters: [RemoteDataRequestParam] = []
    var headers: [String : String]
    var processing: Bool
    var persistent: Bool
    
    init(url: String, method: String, store:String, params: [[String:Any]]?, headers: [String:String]?, persistent:Bool) {
        self.id = -1
        self.url = url
        self.method = method
        self.store=store
        self.headers = headers ?? [:]
        self.processing = true
        self.persistent = persistent
        for param in params ?? [] {
            parameters.append(OBSBaseParam(item: param))
        }
    }
}

class OBSBaseParam:RemoteDataRequestParam {
    var name: String
    var value: String
    var mime: String?
    var data: Data?
    
    init(name:String, value: String, mime: String?, data: Data?) {
        self.name = name
        self.value = value
        self.mime = mime
        self.data = data
    }
    
    convenience init(item:[String:Any]) {
        self.init(name: item["name"] as! String, value: item["value"] as! String, mime: item["mime"] as? String, data: item["data"] as? Data)
    }
}


extension CDRequest:RemoteDataRequest{
    var parameters: [RemoteDataRequestParam] {
        return params?.allObjects as! [RemoteDataRequestParam]
    }
    
    var id: Int {
        return Int(r_id)
    }
    
    var url: String {
        return r_url ?? ""
    }
    
    var method: String {
        return r_method ?? ""
    }
    
    var store: String {
        return r_store ?? ""
    }
    
    var headers: [String : String] {
        var r=[String:String]()
        for x in requestheaders!{
            r[(x as! CDHeaderOptions).key!]=(x as! CDHeaderOptions).value!
        }
        return r
    }
    
    var processing: Bool {
        get {
            return r_processing
        }
        set {
            r_processing = newValue
        }
    }
    
    var persistent: Bool {
        get {
            return r_persistent
        }
        set {
            r_persistent = newValue
        }
    }
    
}

extension CDParam:RemoteDataRequestParam {
    var name: String {
        return paramname!
    }
    
    var value: String {
        return paramvalue!
    }
    
    var mime: String? {
        return parammime
    }
    
    var data: Data? {
        return paramdata
    }
    
    public static func create(item:[String:Any]) -> CDParam {
        let p=NSEntityDescription.insertNewObject(forEntityName: "CDParam", into: OBSStore.corePersistentContainer.viewContext) as! CDParam
        
        p.paramname = item["name"] as? String
        p.paramvalue = item["value"] as? String
        p.paramdata = item["data"] as? Data
        p.parammime = item["mime"] as? String
        
        return p
    }
}
