//
//  Api.swift
//  muso
//
//  Created by John May on 5/10/2014.
//  Copyright (c) 2014 John May. All rights reserved.
//

import Foundation
import Alamofire
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


class Api {
    func search(searchQuery:String, completion:(Array<AnyObject>) -> Void) {
        Alamofire.request(.GET, "http://api.discogs.com/database/search?", parameters: ["q":searchQuery, "type":"artist"])
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