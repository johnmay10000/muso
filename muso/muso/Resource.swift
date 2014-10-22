//
//  Resource.swift
//  muso
//
//  Created by John May on 9/10/2014.
//  Copyright (c) 2014 John May. All rights reserved.
//

import Foundation
import Realm

class Resource : RLMObject  {
    dynamic var id = ""
    dynamic var name = ""
    dynamic var api_key_def = ""
    dynamic var api_key_name = ""
    dynamic var queryTerm = ""
    dynamic var resultTerm = ""
    dynamic var url = ""
    dynamic var use = true
    
    override class func primaryKey() -> String {
        return "id"
    }
}

//class Release : Resource {
//    dynamic var
//}

class Resources {
    var all: RLMResults {
        get {
            return Resource.allObjects()
        }
    }
    
    func addResource(id: String,
        name: String,
        api_key_def: String = "",
        api_key_name: String = "",
        queryTerm: String = "",
        resultTerm: String = "",
        url: String = "")
    {
        //        RLMRealm.useInMemoryDefaultRealm()
        let realm = RLMRealm.defaultRealm()
        let r = Resource()
        r.id = id
        r.name = name
        r.api_key_name = api_key_name
        r.api_key_def = api_key_def
        r.url = url
        r.queryTerm = queryTerm
        r.resultTerm = resultTerm
        
        realm.transactionWithBlock(){
            realm.addOrUpdateObject(r)
        }
    }
}