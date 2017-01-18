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
*/



final class ApiManager{
    
    static let pathToServer = "http://109.120.159.112:4567/"
    static var myToken = ""
    static var myUserId = ""
    
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
                                            ApiManager.myUserId = json["id"].stringValue
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
                callback(json["resultCode"].stringValue, UserClass(name: json["name"].stringValue, id: id, phone: json["phone"].stringValue))
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
                                    var users: [UserClass]!
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
                                    var users: [UserClass]!
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
    
    static func getLastLocations(token: String, user_id: String, callback: @escaping (_ resultCode: String, _ locations: [LocationClass]) -> Void){
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
                                                                           createdAt: location["created_at"].stringValue))
                                    }
                                    callback(resultCode, lastLocations)
                            })

    }
    
}
