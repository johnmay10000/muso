//
//  Api.swift
//  muso
//
//  Created by John May on 5/10/2014.
//  Copyright (c) 2014 John May. All rights reserved.
//

import Foundation
import Alamofire
import Realm
// Required

// Bandcamp
// http://api.bandcamp.com/api/band/3/search?
// Last.fm
// http://ws.audioscrobbler.com/2.0/
// Echo Nest
// http://developer.echonest.com/api/v4/artist/search?
//
// Discogs 
// http://api.discogs.com/database/search?
// band/artist
// albums/discography/album
// search

// api keys
// Echo nest BD2FKJK9U8FCMFFT3


class Resource : RLMObject  {
    dynamic var name = ""
    dynamic var api_key_def = ""
    dynamic var api_key_name = ""
    dynamic var queryTerm = ""
    dynamic var resultTerm = ""
    dynamic var url = ""
    dynamic var use = true
}


class Resources {
    var all: RLMArray {
        get {
            return Resource.allObjects()
        }
    }
    
    func addResource(name: String,
                     api_key_def: String = "",
                     api_key_name: String = "",
                     queryTerm: String,
                     resultTerm: String,
                     url: String)
    {
//        RLMRealm.useInMemoryDefaultRealm()
        let realm = RLMRealm.defaultRealm()
        let r = Resource()
        r.name = name
        r.api_key_name = api_key_name
        r.api_key_def = api_key_def
        r.queryTerm = queryTerm
        r.url = url
        r.resultTerm = resultTerm
        
        realm.transactionWithBlock(){
            realm.addObject(r)
        }
    }
}

// ["api_key_name":"key", "api_key":""]

class Api {
    func search(resources:RLMArray, searchQuery:String, completion:(Array<AnyObject>) -> Void) {
        var params = Dictionary<String, String>()
        
        let aResource:Resource = resources[0] as Resource
        
//        if let searchTerm = aResource.queryTerm {
            params[aResource.queryTerm] = searchQuery
//        }
        
//        if let key_name = aResource.api_key_name {
//            if let key_def = aResource.api_key_def {
                    params[aResource.api_key_name] = aResource.api_key_def
//                }
//        }
        
        Alamofire.request(.GET, aResource.url, parameters: params)
            .responseJSON { (request, response, json, error) in
//                println(response)
                if let jsonToParse:AnyObject = json
                {
                    let jsonParsed = JSON(object:jsonToParse)
                    println(jsonParsed)
//                    jsonParsed[aResource.resultTerm].arrayObjects
                    if let array = jsonParsed["response"][aResource.resultTerm].arrayObjects {
                      completion(array)
                    }
                }
        }
    }
}