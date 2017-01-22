//
//  RequestClass.swift
//  GeoGeo
//
//  Created by Kirill Averyanov on 21/01/2017.
//  Copyright © 2017 Иван Трофимов. All rights reserved.
//

import Foundation


class RequestClass{
    var createdTime: String = ""
    var followerId: String = ""
    var followedId: String = ""
    
    init(followerId: String, followedId: String, createdTime: String){
        self.followerId = followerId
        self.followedId = followedId
        self.createdTime = createdTime
    }
}
