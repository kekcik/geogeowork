//
//  ChatManager.swift
//  GeoGeo
//
//  Created by Kirill Averyanov on 19/01/2017.
//  Copyright © 2017 Иван Трофимов. All rights reserved.
//

import Foundation
import JSQMessagesViewController


final class ChatManager{
    
    static func translateMessageClassToJSQMessage(message: MessageClass) -> JSQMessage{
        return JSQMessage(senderId: message.senderId!,
                          senderDisplayName: message.senderName!,
                          date: ApiManager.translateUnixTime(time: Int(message.createdTime)!),
                          text: message.data)
    }
    
    static func translateJSQMessageToMessageClass(message: JSQMessage) -> MessageClass{
        return MessageClass(id: nil,
                            senderId: message.senderId,
                            recieverId: nil,
                            isRead: false,
                            createdTime: "\(ApiManager.translateToDateFromUnixTime(date: message.date))",
                            data: message.text,
                            type: nil)
    }
    
    static func createAvatar(initials: String, backgroundColor: UIColor) -> JSQMessagesAvatarImage{
        return JSQMessagesAvatarImageFactory().avatarImage(withUserInitials: initials,
                                                           backgroundColor: backgroundColor,
                                                           textColor: UIColor.white,
                                                           font: UIFont.systemFont(ofSize: 12))
    }
    
    static func createSenderAvatarColor() -> UIColor{
        return UIColor.jsq_messageBubbleGreen()
    }
    
    static func createRecieverAvatarColor() -> UIColor{
        return UIColor.gray
    }
    
}
