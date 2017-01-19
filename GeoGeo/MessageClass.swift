//
//  MessageClass.swift
//  GeoGeo
//
//  Created by Kirill Averyanov on 19/01/2017.
//  Copyright © 2017 Иван Трофимов. All rights reserved.
//

import Foundation


class MessageClass{
    var id: String? = ""
    var senderId: String? = ""
    var recieverId: String? = ""
    var isRead: Bool = false
    var createdTime: String = ""
    var data: String = ""
    var type: String? = ""
    var senderName: String? = ""
    
    init(id: String?, senderId: String?, recieverId: String?, isRead: Bool,
         createdTime: String, data: String, type: String?, senderName: String? = ""){
        self.id = id
        self.senderId = senderId
        self.recieverId = recieverId
        self.isRead = isRead
        self.createdTime = createdTime
        self.data = data
        self.type = type
        self.senderName = senderName
    }
}
