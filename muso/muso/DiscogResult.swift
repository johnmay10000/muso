//
//  DiscogResult.swift
//  muso
//
//  Created by John May on 20/10/2014.
//  Copyright (c) 2014 John May. All rights reserved.
//

import Foundation


//[resource_url: http://api.discogs.com/artists/18845, id: 18845, uri: /artist/18845-Slayer, thumb: http://api.discogs.com/images/A-150-18845-1364197824-3484.jpeg, title: Slayer, type: artist]


struct ArtistResult {
    let id: Int
    let title: String
    let thumb: String
    let resource_url: String
    let type: String
    let uri: String
}

func parseArtistResult(result: AnyObject) -> ArtistResult? {
    let mkArtistResult = curry {id, title, thumb, resource_url, type, uri in ArtistResult(id: id, title: title, thumb: thumb, resource_url: resource_url, type: type, uri: uri) }

    return asDict(result) >>>= {
        mkArtistResult <*> int($0,"id")
            <*> string($0,"title")
            <*> string($0,"thumb")
            <*> string($0,"resource_url")
            <*> string($0,"type")
            <*> string($0,"uri")
    }
}

func parseJSON(parsedJSON:[String:AnyObject]?) -> [ArtistResult]? {
    if let toProcess = parsedJSON {
        let artistResults = array(toProcess, "results") >>>= { join($0.map(parseArtistResult)) }
        return artistResults
    } else {
        return []
    }
}

extension ArtistResult : Printable {
    var description : String {
        return "ArtistResult { id = \(id), title = \(title), thumb = \(thumb), resource_url = \(resource_url), type = \(type), uri = \(uri)"
    }
}

func toURL(urlString: String) -> NSURL {
    return NSURL(string: urlString)!
}


func asDict(x: AnyObject) -> [String:AnyObject]? {
    return x as? [String:AnyObject]
}


func join<A>(elements: [A?]) -> [A]? {
    var result : [A] = []
    for element in elements {
        if let x = element {
            result += [x]
        } else {
            return nil
        }
    }
    return result
}



infix operator  <*> { associativity left precedence 150 }
func <*><A, B>(l: (A -> B)?, r: A?) -> B? {
    if let l1 = l {
        if let r1 = r {
            return l1(r1)
        }
    }
    return nil
}

func flatten<A>(x: A??) -> A? {
    if let y = x { return y }
    return nil
}

func array(input: [String:AnyObject], key: String) ->  [AnyObject]? {
    let maybeAny : AnyObject? = input[key]
    return maybeAny >>>= { $0 as? [AnyObject] }
}

func dictionary(input: [String:AnyObject], key: String) ->  [String:AnyObject]? {
    return input[key] >>>= { $0 as? [String:AnyObject] }
}

func string(input: [String:AnyObject], key: String) -> String? {
    return input[key] >>>= { $0 as? String }
}

func number(input: [NSObject:AnyObject], key: String) -> NSNumber? {
    return input[key] >>>= { $0 as? NSNumber }
}

func int(input: [NSObject:AnyObject], key: String) -> Int? {
    return number(input,key).map { $0.integerValue }
}

func bool(input: [NSObject:AnyObject], key: String) -> Bool? {
    return number(input,key).map { $0.boolValue }
}


func curry<A,B,R>(f: (A,B) -> R) -> A -> B -> R {
    return { a in { b in f(a,b) } }
}

func curry<A,B,C,R>(f: (A,B,C) -> R) -> A -> B -> C -> R {
    return { a in { b in {c in f(a,b,c) } } }
}

func curry<A,B,C,D,R>(f: (A,B,C,D) -> R) -> A -> B -> C -> D -> R {
    return { a in { b in { c in { d in f(a,b,c,d) } } } }
}

func curry<A,B,C,D,E,G,R>(f: (A,B,C,D,E,G) -> R) -> A -> B -> C -> D -> E -> G -> R {
    return { a in { b in { c in { d in { e in { g in f(a,b,c,d,e,g) } } } } } }
}

infix operator  >>>= {}

func >>>= <A,B> (optional : A?, f : A -> B?) -> B? {
    return flatten(optional.map(f))
}