//
//  Result.swift
//  muso
//
//  Created by John May on 12/10/2014.
//  Copyright (c) 2014 John May. All rights reserved.
//

import Foundation

struct SearchResult {
    var title: String
    var result_id: Int
    var thumb: String
    init(title: String, result_id: Int, thumb: String) {
        self.title = title
        self.result_id = result_id
        self.thumb = thumb
    }
}