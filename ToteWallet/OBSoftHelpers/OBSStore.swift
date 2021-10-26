//
//  Store.swift
//  platea
//
//  Created by Nadim Henoud on 4/1/16.
//  Copyright © 2016 OBSoft. All rights reserved.
//

import Foundation
import CoreData

class OBSStore: OBSRemoteData {
    let modelName:String
    let entityName:String
    static let coreCDManager:OBSCoreDataManager = OBSCoreDataManager.instance(name: "Core")
    static let appCDManager:OBSCoreDataManager = OBSCoreDataManager.instance(name: Config.modelName)
    var validity:StoreValidity
    var expireAfter: Int = 0 //minutes (0: always refresh, -1: never expire)
    var forceReload: Bool = false
    var expired: Bool {
        get {
            return (expireAfter > -1 && (validity.expiry ?? Date(timeIntervalSinceNow: -1) < Date())) || forceReload
        }
    }
    var loaded: Bool {
        get {
            return validity.loaded
        }
    }
    var abortLoading:Bool = false
    var pagesLoaded:Int = 0
    var totalRecords:Int = 0
    var perPage:Int = 999
    var currentPage:Int = 1
    var pages:Int {
        get {
            return totalRecords%perPage == 0 ? totalRecords/perPage : totalRecords/perPage + 1
        }
    }
    
    init(entityName:String, modelName:String = "Core") {
        self.entityName = entityName
        self.modelName = modelName
        self.validity = StoreValidity.load(storeName: self.entityName)
        if self.validity.synced == nil {
            self.validity.synced = Config.serverDOnlyf.date(from: "2019-01-01")
        }
    }
    
    public static var corePersistentContainer: NSPersistentContainer {
        get {
            return OBSStore.coreCDManager.persistentContainer
        }
    }
    
    public static var appPersistentContainer: NSPersistentContainer {
        get {
            return OBSStore.appCDManager.persistentContainer
        }
    }
    
    public func updateValidity() {
        self.validity.loaded = true
        self.validity.synced = Date()
        self.validity.expiry = Date(timeIntervalSinceNow: TimeInterval(self.expireAfter*60))
    }
    
    public func resetValidity() {
        self.validity.loaded = false
        self.validity.synced = Config.serverDOnlyf.date(from: "2019-01-01")
        self.validity.expiry = nil
    }
    
    public func load(url: String, force:Bool=false, delegate: OBSRemoteDataDelegate? = nil, useQueue:Bool=false) {
        self.abortLoading = false
        self.delegate = delegate
        
        if(force == true) {
            self.resetValidity()
            self.forceReload = true
        }
        
        if(self.expired) {
            self.pagesLoaded = 0
            self.currentPage = 1
            self.getData(command: self.buildPaginationUrl(url: url), headers: nil, useQueue: useQueue)
        } else {
            self.delegate?.hasFinishedLoadingData(status: .didLoadRemoteData, message: "")
        }
        
    }
    
    public func loadNext(url: String, useQueue:Bool=false, inBackground:Bool=false) {
        if pagesLoaded >= pages {
            self.hasFinishedLoadingPages()
            return
        }
        if inBackground {
            self.delegate?.hasFinishedLoadingData(status: .didLoadRemoteData, message: "")
        }
        while currentPage < pages  {
            self.currentPage += 1
            self.getData(command: self.buildPaginationUrl(url: url), headers: nil, useQueue: useQueue)
        }
    }
    
    func buildPaginationUrl(url: String) -> String {
        let pagination = "filter[_per_page]=\(self.perPage)&filter[_page]=\(self.currentPage)"
        
        if url.contains("?") {
            return "\(url)&\(pagination)"
        } else {
            return "\(url)?\(pagination)"
        }
    }
    
    public func hasFinishedLoadingPages(inBackground:Bool=false) {
        self.updateValidity()
        if !inBackground {
            self.delegate?.hasFinishedLoadingData(status: .didLoadRemoteData, message: "")
        }
    }
}

protocol OBSStoreDelegate: OBSRemoteDataDelegate
{
}

extension StoreValidity {
    static func create(name: String) -> StoreValidity {
        let persistentContainer = OBSStore.corePersistentContainer
        let c=NSEntityDescription.insertNewObject(forEntityName: "StoreValidity", into: persistentContainer.viewContext) as! StoreValidity
        c.name = name
        
        return c
    }
    static func load(storeName: String) -> StoreValidity {
        let persistentContainer = OBSStore.corePersistentContainer
        let request=NSFetchRequest<StoreValidity>(entityName: "StoreValidity")
        request.predicate=NSPredicate(format:"name == %@",storeName)
        do{
            let s = try persistentContainer.viewContext.fetch(request)
            return s.first ?? self.create(name: storeName)
        }
        catch{
            return self.create(name: storeName)
        }
    }
}


