//
//  OAuthCredentials.swift
//  muso
//
//  Created by John May on 19/10/2014.
//  Copyright (c) 2014 John May. All rights reserved.
//

import Foundation
import Realm

class OAuthCredential : RLMObject  {
    dynamic var id = ""
    dynamic var api_key_token = ""
    dynamic var api_key_secret = ""

    override class func primaryKey() -> String {
        return "id"
    }
}


class OAuthCredentials {
    var all: RLMResults {
        get {
            return OAuthCredential.allObjects()
        }
    }

    func addOAuthCredential(id: String,
        token:String,
        secret:String) {
            //        RLMRealm.useInMemoryDefaultRealm()
            let realm = RLMRealm.defaultRealm()
            let r = OAuthCredential()
            r.id = id
            r.api_key_token = token
            r.api_key_secret = secret
            realm.transactionWithBlock(){
                realm.addOrUpdateObject(r)
            }
    }
}
