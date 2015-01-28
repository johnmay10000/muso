//
//  Api.swift
//  muso
//
//  Created by John May on 5/10/2014.
//  Copyright (c) 2014 John May. All rights reserved.
//

import Foundation
import UIKit
//import Alamofire
import Realm
//import Basis
//import swiftz_core

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
// ["api_key_name":"key", "api_key":""]

typealias ApiResponse = (data: NSData, response: NSHTTPURLResponse) -> Void
typealias FailureResponse = (error:NSError!) -> Void

class Api {
    func search(resources:RLMResults, searchQuery:String, completion:([ArtistResult]) -> Void) {
        var params = Dictionary<String, String>()
        let resource:Resource = resources[0] as Resource
        let searchTerm = resource.queryTerm
        params[searchTerm] = searchQuery
        params["type"] = "artist"
        
        let xs: [Int8] = [1, 2, 0, 3, 4]
        
        sconcat(Min(), 2, xs)
        
        mconcat(Sum<Int8, NInt8>(i: { return nint8 }), xs)
        
        get(resource.url, parameters: params, success: { ApiResponse in
                let json:JSON = JSON(data:ApiResponse.data)
//                println("SEARCH!")
//                println(searchQuery)
                let maybe:[String : AnyObject]? = json.dictionaryObject
                if let actual = maybe {
                    let artistResults:[ArtistResult]? = parseJSON(actual)
                    if let actual = artistResults {
                        completion(actual)
                    }
                }            
            }, failure: { FailureResponse in
                println(FailureResponse.localizedDescription)
        })
    }

    func image(url:String, imageView:UIImageView) {
        get(url, parameters: Dictionary<String, String>(), success:{ ApiResponse in
            let d = ApiResponse.data
            }, failure:{ FailureResponse in
                println(FailureResponse.localizedDescription)
        })
    }
    
    func get(url:String, parameters:Dictionary<String, String>, success:ApiResponse, failure:FailureResponse) -> Void {
        let client = getClient()
        client.get(url, parameters: parameters, success, failure)
    }
    
    
    func getClient() -> OAuthSwiftClient {
        let creds:RLMResults = OAuthCredentials().all
        let cred:OAuthCredential = creds[0] as OAuthCredential
        
        let client:OAuthSwiftClient = OAuthSwiftClient(consumerKey:"oTwRJVjNCsbRoQyFGsDS",
            consumerSecret: "hPJQPoeoQqmyVYMRwGAYvsnyHMQXqXkb", accessToken: cred.api_key_token, accessTokenSecret: cred.api_key_secret)
        return client
    }
}


//        Alamofire.request(.GET, resource.url, parameters: params)
//            .responseJSON { (request, response, json, error) in
//                println(request)
//                println(response)
//                if let jsonToParse:AnyObject = json {
//                    let jsonParsed = JSON(object:jsonToParse)
////                    println(jsonParsed)
////                    jsonParsed[aResource.resultTerm].arrayObjects
//                    if let array = jsonParsed[resource.resultTerm].arrayObjects {
//                        println(array)
//                      completion(array)
//                    }
//                }
//            }
