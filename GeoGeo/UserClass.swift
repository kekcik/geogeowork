//
//  UserClass.swift
//  GeoGeo
//
//  Created by Kirill Averyanov on 03/01/2017.
//  Copyright © 2017 Иван Трофимов. All rights reserved.
//

import Foundation


class UserClass{
    var name: String = ""
    var id: String = ""
    var phone: String = ""
    var flag: Bool = false
    
    init(name: String, id: String, phone: String){
        self.name = name
        self.id = id
        self.phone = phone
    }
    
    init(){}
}
