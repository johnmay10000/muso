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
    dynamic var key = ""
    dynamic var  queryTerm = ""
    dynamic var url = ""
    dynamic var use = true
}


class Resources {
    var all: RLMArray {
        get {
            return Resource.allObjects()
        }
    }
    
    func addResource(name:String,
                     key:String,
                     queryTerm:String,
                     url:String)
    {
//        RLMRealm.useInMemoryDefaultRealm()
        let realm = RLMRealm.defaultRealm()
        let r = Resource()
        r.name = name
        r.key = key
        r.queryTerm = queryTerm
        r.url = url
        
        realm.transactionWithBlock(){
            realm.addObject(r)
        }
    }
}

class Api {
    func search(resources:RLMArray, searchQuery:String, completion:(Array<AnyObject>) -> Void) {
        var params = Dictionary<String, String>()
        if let searchTerm = resources[0].queryTerm {
            params[searchTerm] = searchQuery
        }
        
        Alamofire.request(.GET, resources[0].url, parameters: params)
            .responseJSON { (request, response, json, error) in
//                println(request)
//                println(response)
//                println(error)
                if let jsonToParse:AnyObject = json
                {
                    let jsonParsed = JSON(object:jsonToParse)                    
                    if let array = jsonParsed["results"].arrayObjects {
                      completion(array)
                    }
//                    println(jsonParsed["results"][0]["title"])
                }
//                println(json)
        }
    }
}