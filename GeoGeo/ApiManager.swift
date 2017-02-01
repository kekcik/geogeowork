//
//  ApiManager.swift
//  GeoGeo
//
//  Created by Kirill Averyanov on 03/01/2017.
//  Copyright © 2017 Иван Трофимов. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

////default data
/*
 ///#1
 phone = 1234
 name = kirill
 password = kirill
 
 ///#2
 phone = 4321
 name = kirill
 password = kirill
 
 ///#3
 phone = 123456
 name = Kirill2017
 password = kirill
*/



final class ApiManager{
    
    static let pathToServer = "http://109.120.159.112:4567/"
    static var myToken = ""
    static var me = UserClass()
    
    static func getUnixTime() -> String{
        return "\(Int(Date().timeIntervalSince1970))"
    }
    
    static func translateUnixTime(time: Int) -> Date{
        return Date(timeIntervalSince1970: TimeInterval(time))
    }
    
    static func translateToDateFromUnixTime(date: Date) -> Int{
        return Int(date.timeIntervalSince1970)
    }
    
    
    static func makeUnixTimeReadble(time: Int) -> String{
        let date = translateUnixTime(time: time)
        let calendar = NSCalendar.current
        var hour = String(calendar.component(.hour, from: date as Date))
        var minutes = String(calendar.component(.minute, from: date as Date))
        if hour.characters.count == 1{
            hour = "0" + hour
        }
        if minutes.characters.count == 1{
            minutes = "0" + minutes
        }
        return "\(hour):\(minutes)"
    }
    
    static func createChat(with user: UserClass,
                           latestMessageId: String? = nil,
                           latestMessageData: String? = nil,
                           isRead: Bool? = nil,
                           createdTime: String? = nil,
                           callback: @escaping (_ chatView: ChatViewController) -> Void){
        let chatView = ChatViewController()
        chatView.conversation = ConversationClass(senderUser: ApiManager.me,
                                                  recieverUser: user,
                                                  latestMessageId: nil,
                                                  latestMessageData: nil,
                                                  latestMessageType: nil,
                                                  isRead: nil,
                                                  createdTime: nil)
        ApiManager.getDialogWithUser(token: ApiManager.myToken,
                                     user_id: user.id,
                                     count: "1000",
                                     offset: "0",
                                     callback: {resultCode, messages in
                                        if resultCode == "0"{
                                            chatView.conversation.messages = messages
                                            chatView.conversation.messages.reverse()
                                        }
                                        callback(chatView)
        })

    }
    
    static func register(phone: String, name: String, password: String, callback: @escaping (_ resultCode: String) -> Void){
        let path = pathToServer + "user.register"
        Alamofire.request(path,
                          parameters: [
                            "phone": phone,
                            "name": name,
                            "password": password]).responseJSON(completionHandler:
                                        {response in
                                            guard response.result.isSuccess else{
                                                return
                                            }
                                            let json = JSON(response.result.value!)
                                            callback(json["result_code"].stringValue)
                                       })
    }
    
    static func auth(phone: String, password: String, callback: @escaping (_ resultCode: String, _ id: String, _ token: String) -> Void){
        let path = pathToServer + "user.auth"
        Alamofire.request(path,
                          parameters: [
                            "phone": phone,
                            "password": password]).responseJSON(completionHandler:
                                        {response in
                                            guard response.result.isSuccess else{
                                                return
                                            }
                                            let json = JSON(response.result.value!)
                                            ApiManager.myToken = json["token"].stringValue
                                            ApiManager.me.id = json["id"].stringValue
                                            ApiManager.getUserById(token: ApiManager.myToken,
                                                                   id: ApiManager.me.id, callback: {resultCode, user in
                                                                    if resultCode == "0"{
                                                                        ApiManager.me = user
                                                                    }
                                            })
                                            callback(json["result_code"].stringValue, json["id"].stringValue, json["token"].stringValue)
                                       })
    }
    
    static func changePassword(token: String, oldPassword: String, newPassword: String, callback: @escaping (_ resultCode: String) -> Void){
        let path = pathToServer + "user.change_password"
        Alamofire.request(path,
                          parameters: [
                            "token": token,
                            "old_password": oldPassword,
                            "new_password": newPassword]).responseJSON(completionHandler:
            {response in
                guard response.result.isSuccess else{
                    return
                }
                let json = JSON(response.result.value!)
                callback(json["result_code"].stringValue)
        })
    }
    
    
    static func getUserById(token: String, id: String, callback: @escaping (_ resultCode: String, _ user: UserClass) -> Void){
        let path = pathToServer + "user.get_by_id"
        Alamofire.request(path,
                          parameters: [
                            "token": token,
                            "id": id]).responseJSON(completionHandler:
            {response in
                guard response.result.isSuccess else{
                    return
                }
                let json = JSON(response.result.value!)
                callback(json["result_code"].stringValue, UserClass(name: json["name"].stringValue, id: id, phone: json["phone"].stringValue))
        })
    }
    
    
    static func searchUserByPhone(token: String, phone: String, callback: @escaping (_ resultCode: String, _ users: [UserClass]) -> Void){
        let path = pathToServer + "user.search_by_phone"
        Alamofire.request(path,
                          parameters: [
                            "token": token,
                            "phone": phone]).responseJSON(completionHandler:
                                {response in
                                    guard response.result.isSuccess else{
                                        return
                                    }
                                    let json = JSON(response.result.value!)
                                    var users = [UserClass]()
                                    for user in json["users"].arrayValue{
                                        users.append(UserClass(name: user["name"].stringValue,
                                                               id: user["id"].stringValue,
                                                               phone: user["phone"].stringValue))
                                    }
                                    callback(json["result_code"].stringValue, users)
                            })
    }
    
    
    static func searchUserByName(token: String, name: String, callback: @escaping (_ resultCode: String, _ users: [UserClass]) -> Void){
        let path = pathToServer + "user.search_by_name"
        Alamofire.request(path,
                          parameters: [
                            "token": token,
                            "name": name]).responseJSON(completionHandler:
                                {response in
                                    guard response.result.isSuccess else{
                                        return
                                    }
                                    let json = JSON(response.result.value!)
                                    var users = [UserClass]()
                                    for user in json["users"].arrayValue{
                                        users.append(UserClass(name: user["name"].stringValue,
                                                               id: user["id"].stringValue,
                                                               phone: user["phone"].stringValue))
                                    }
                                    callback(json["result_code"].stringValue, users)
                            })
    }

    
    static func setLocationPoint(token: String, location: LocationClass, callback: @escaping (_ resultCode: String) -> Void){
        let path = pathToServer + "location.set_location"
        Alamofire.request(path,
                          parameters: [
                            "token": token,
                            "lat": location.lat!,
                            "lon": location.lon!,
                            "accuracy": location.accuracy!]).responseJSON(completionHandler:
                                {response in
                                    guard response.result.isSuccess else{
                                        return
                                    }
                                    let json = JSON(response.result.value!)
                                    callback(json["result_code"].stringValue)
                            })
    }
    
    static func getLastLocationOfUser(token: String, user_id: String, callback: @escaping (_ resultCode: String, _ location: LocationClass?) -> Void){
        let path = pathToServer + "location.get_location"
        Alamofire.request(path,
                          parameters: [
                            "token": token,
                            "user_id": user_id]).responseJSON(completionHandler:
                                {response in
                                    guard response.result.isSuccess else{
                                        return
                                    }
                                    let json = JSON(response.result.value!)
                                    let resultCode = json["result_code"].stringValue
                                    var lastLocations = [LocationClass]()
                                    for location in json["locations"].arrayValue{
                                        lastLocations.append(LocationClass(lat: location["lat"].stringValue,
                                                                           lon: location["lon"].stringValue,
                                                                           accuracy: location["accuracy"].stringValue,
                                                                           createdAt: ApiManager.makeUnixTimeReadble(time: location["created_at"].intValue)))
                                    }
                                    callback(resultCode, (lastLocations.count == 0 ? nil: lastLocations[0]))
                            })

    }
    
    static func getLocationHistoryOfUser(token: String, user_id: String, timeFrom: String, timeTo: String, step: String,
                                         callback: @escaping (_ resultCode: String, _ locations: [LocationClass]) -> Void){
        let path = pathToServer + "location.get_history"
        Alamofire.request(path,
                          parameters: [
                            "token": token,
                            "user_id": user_id,
                            "time_from": timeFrom,
                            "time_to": timeTo,
                            "step": step]).responseJSON(completionHandler:
                                {response in
                                    guard response.result.isSuccess else{
                                        return
                                    }
                                    let json = JSON(response.result.value!)
                                    let resultCode = json["result_code"].stringValue
                                    var lastLocations = [LocationClass]()
                                    for location in json["locations"].arrayValue{
                                        lastLocations.append(LocationClass(lat: location["lat"].stringValue,
                                                                           lon: location["lon"].stringValue,
                                                                           accuracy: location["accuracy"].stringValue,
                                                                           createdAt: location["created_at"].stringValue))
                                    }
                                    callback(resultCode, lastLocations)
                            })
    }
    
    static func sendMessage(token: String, user_id: String, text: String, callback: @escaping (_ resultCode: String) -> Void){
        let path = pathToServer + "messages.send_message"
        Alamofire.request(path,
                          parameters: [
                            "token": token,
                            "user_id": user_id,
                            "text": text]).responseJSON(completionHandler:
                                {response in
                                    guard response.result.isSuccess else{
                                        return
                                    }
                                    let json = JSON(response.result.value!)
                                    callback(json["result_code"].stringValue)
                            })
    }
    
    
    static func getDialogWithUser(token: String, user_id: String, count: String, offset: String,
                                  callback: @escaping (_ resultCode: String, _ messages: [MessageClass]) -> Void){
        let path = pathToServer + "messages.get_dialog"
        Alamofire.request(path,
                          parameters: [
                            "token": token,
                            "user_id": user_id,
                            "count": count,
                            "offset": offset]).responseJSON(completionHandler:
                                {response in
                                    guard response.result.isSuccess else{
                                        return
                                    }
                                    let json = JSON(response.result.value!)
                                    let resultCode = json["result_code"].stringValue
                                    var messages = [MessageClass]()
                                    for message in json["messages"].arrayValue{
                                        messages.append(MessageClass(id: message["id"].stringValue,
                                                                     senderId: message["sender_id"].stringValue,
                                                                     recieverId: message["reciever_id"].stringValue,
                                                                     isRead: message["readed"].boolValue,
                                                                     createdTime: message["created_at"].stringValue,
                                                                     data: message["data"].stringValue,
                                                                     type: message["type"].stringValue))
                                    }
                                    callback(resultCode, messages)
                            })
    }
    
    
    static func getDialogs(token: String, callback: @escaping (_ resultCode: String, _ dialogs: [ConversationClass]) -> Void){
        let path = pathToServer + "messages.get_dialogs"
        Alamofire.request(path,
                          parameters: [
                            "token": token]).responseJSON(completionHandler:
                                {response in
                                    guard response.result.isSuccess else{
                                        return
                                    }
                                    let json = JSON(response.result.value!)
                                    let resultCodeMain = json["result_code"].stringValue
                                    var dialogs = [ConversationClass]()
                                    for dialog in json["dialogs"].arrayValue{
                                        let senderId = dialog["sender_id"].stringValue
                                        let recieverId = dialog["receiver_id"].stringValue
                                        let nextRecieverId = (senderId == me.id ? recieverId: senderId)
                                        ApiManager.getUserById(token: token, id: nextRecieverId, callback: {resultCode, user in
                                            dialogs.append(ConversationClass(senderUser: ApiManager.me,
                                                                             recieverUser: user,
                                                                             latestMessageId: dialog["id"].stringValue,
                                                                             latestMessageData: dialog["data"].stringValue,
                                                                             latestMessageType: dialog["type"].stringValue,
                                                                             isRead: dialog["readed"].boolValue,
                                                                             createdTime: dialog["created_at"].stringValue))
                                            if dialogs.count == json["dialogs"].arrayValue.count{
                                                dialogs.sort(by: {d1, d2 in d1.createdTime! > d2.createdTime!})
                                                for d in 0 ..< dialogs.count{
                                                    dialogs[d].createdTime = ApiManager.makeUnixTimeReadble(time: Int(dialogs[d].createdTime!)!)
                                                }
                                                callback(resultCodeMain, dialogs)
                                            }
                                        })
                                        
                                    }
                            })
    }
    
    
    static func getLastMessages(token: String,
                                callback: @escaping (_ resultCode: String, _ inId: String, _ outId: String) -> Void){
        let path = pathToServer + "messages.get_last_messages"
        Alamofire.request(path,
                          parameters: [
                            "token": token]).responseJSON(completionHandler:
                                {response in
                                    guard response.result.isSuccess else{
                                        return
                                    }
                                    let json = JSON(response.result.value!)
                                    callback(json["result_code"].stringValue, json["in"].stringValue, json["out"].stringValue)
                            })
    }
    
    
    static func markAsReadedOfUser(token: String, user_id: String, timeStamp: String, callback: @escaping (_ resultCode: String) -> Void){
        let path = pathToServer + "messages.get_last_messages"
        Alamofire.request(path,
                          parameters: [
                            "token": token,
                            "user_id": user_id,
                            "timestamp": timeStamp]).responseJSON(completionHandler:
                                {response in
                                    guard response.result.isSuccess else{
                                        return
                                    }
                                    let json = JSON(response.result.value!)
                                    callback(json["result_code"].stringValue)
                            })
    }
    
    
    static func acceptRequest(token: String, user_id: String, callback: @escaping (_ resultCode: String) -> Void){
        let path = pathToServer + "requests.accept_request"
        Alamofire.request(path,
                          parameters: [
                            "token": token,
                            "user_id": user_id]).responseJSON(completionHandler:
                                {response in
                                    guard response.result.isSuccess else{
                                        return
                                    }
                                    let json = JSON(response.result.value!)
                                    callback(json["result_code"].stringValue)
                            })
    }
    
    static func escapeRequest(token: String, user_id: String, callback: @escaping (_ resultCode: String) -> Void){
        let path = pathToServer + "requests.escape"
        Alamofire.request(path,
                          parameters: [
                            "token": token,
                            "user_id": user_id]).responseJSON(completionHandler:
                                {response in
                                    guard response.result.isSuccess else{
                                        return
                                    }
                                    let json = JSON(response.result.value!)
                                    callback(json["result_code"].stringValue)
                            })
    }
    
    static func followRequest(token: String, user_id: String, callback: @escaping (_ resultCode: String) -> Void){
        let path = pathToServer + "requests.follow"
        Alamofire.request(path,
                          parameters: [
                            "token": token,
                            "user_id": user_id]).responseJSON(completionHandler:
                                {response in
                                    guard response.result.isSuccess else{
                                        return
                                    }
                                    let json = JSON(response.result.value!)
                                    callback(json["result_code"].stringValue)
                            })
    }
    
    
    static func unfollowRequest(token: String, user_id: String, callback: @escaping (_ resultCode: String) -> Void){
        let path = pathToServer + "requests.unfollow"
        Alamofire.request(path,
                          parameters: [
                            "token": token,
                            "user_id": user_id]).responseJSON(completionHandler:
                                {response in
                                    guard response.result.isSuccess else{
                                        return
                                    }
                                    let json = JSON(response.result.value!)
                                    callback(json["result_code"].stringValue)
                            })
    }
    
    static func refuseRequest(token: String, user_id: String, callback: @escaping (_ resultCode: String) -> Void){
        let path = pathToServer + "requests.refuse_request"
        Alamofire.request(path,
                          parameters: [
                            "token": token,
                            "user_id": user_id]).responseJSON(completionHandler:
                                {response in
                                    guard response.result.isSuccess else{
                                        return
                                    }
                                    let json = JSON(response.result.value!)
                                    callback(json["result_code"].stringValue)
                            })
    }
    
    static func getRequests(token: String, callback: @escaping (_ resultCode: String, _ requests: [RequestClass]) -> Void){
        let path = pathToServer + "requests.get_requests"
        Alamofire.request(path,
                          parameters: [
                            "token": token]).responseJSON(completionHandler:
                                {response in
                                    guard response.result.isSuccess else{
                                        return
                                    }
                                    let json = JSON(response.result.value!)
                                    let resultCode = json["result_code"].stringValue
                                    var requests = [RequestClass]()
                                    for request in json["requests"].arrayValue{
                                        requests.append(RequestClass(followerId: request["observer_id"].stringValue,
                                                                     followedId: request["observed_id"].stringValue,
                                                                     createdTime: request["created_at"].stringValue))
                                    }
                                    callback(resultCode, requests)
                            })
    }
    
    static func getFollowers(token: String, callback: @escaping (_ resultCode: String, _ requests: [String]) -> Void){
        let path = pathToServer + "permissions.get_followers"
        Alamofire.request(path,
                          parameters: [
                            "token": token]).responseJSON(completionHandler:
                                {response in
                                    guard response.result.isSuccess else{
                                        return
                                    }
                                    let json = JSON(response.result.value!)
                                    let resultCode = json["result_code"].stringValue
                                    var ids = [String]()
                                    for id in json["followers"].arrayValue{
                                        ids.append(id.stringValue)
                                    }
                                    callback(resultCode, ids)
                            })
    }
    
    static func getFollowed(token: String, callback: @escaping (_ resultCode: String, _ requests: [String]) -> Void){
        let path = pathToServer + "permissions.get_followed"
        Alamofire.request(path,
                          parameters: [
                            "token": token]).responseJSON(completionHandler:
                                {response in
                                    guard response.result.isSuccess else{
                                        return
                                    }
                                    let json = JSON(response.result.value!)
                                    let resultCode = json["result_code"].stringValue
                                    var ids = [String]()
                                    for id in json["followed"].arrayValue{
                                        ids.append(id.stringValue)
                                    }
                                    callback(resultCode, ids)
                            })
    }
    
    
    static func getUserPermissions(token: String, user_id: String, callback: @escaping (_ resultCode: String, _ inAns: Bool, _ outAns: Bool) -> Void){
        let path = pathToServer + "permissions.get_user_permissions"
        Alamofire.request(path,
                          parameters: [
                            "token": token,
                            "id": user_id]).responseJSON(completionHandler:
                                {response in
                                    guard response.result.isSuccess else{
                                        return
                                    }
                                    let json = JSON(response.result.value!)
                                    callback(json["result_code"].stringValue, json["in"].boolValue, json["out"].boolValue)
                            })
    }
    
    
}
