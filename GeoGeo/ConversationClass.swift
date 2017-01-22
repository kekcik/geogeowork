//
//  ConversationClass.swift
//  GeoGeo
//
//  Created by Kirill Averyanov on 18/01/2017.
//  Copyright © 2017 Иван Трофимов. All rights reserved.
//

import Foundation


class ConversationClass{
    var senderUser: UserClass = UserClass()
    var recieverUser: UserClass = UserClass()
    var latestMessageId: String? = nil
    var latestMessageData: String? = nil
    var latestMessageType: String? = nil
    var isRead: Bool? = false
    var createdTime: String? = nil
    var messages: [MessageClass] = [MessageClass]()
    
    
    init(senderUser: UserClass, recieverUser: UserClass, latestMessageId: String?,
         latestMessageData: String?, latestMessageType: String?,
         isRead: Bool?, createdTime: String?,
         messages: [MessageClass] = [MessageClass]()){
        self.senderUser = senderUser
        self.recieverUser = recieverUser
        self.latestMessageId = latestMessageId
        self.latestMessageData = latestMessageData
        self.latestMessageType = latestMessageType
        self.isRead = isRead
        self.createdTime = createdTime
        self.messages = messages
    }
    
    init(){}
}
