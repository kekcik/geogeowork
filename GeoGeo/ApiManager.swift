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
 phone = 1234
 name = kirill
 password = kirill
*/



final class ApiManager{
    
    static let pathToServer = "http://109.120.159.112:4567/"
    
    static func register(phone: String, name: String, password: String, callback: @escaping (_ resultCode: String) -> Void){
        let path = "\(pathToServer)user.auth?phone=\(phone)&name=\(name)&password=\(password)"
        Alamofire.request(path).responseJSON(completionHandler:
                                        {response in
                                            guard response.result.isSuccess else{
                                                return
                                            }
                                            let json = JSON(response.result.value!)
                                            callback(json["result_code"].stringValue)
                                       })
    }
    
    static func auth(phone: String, password: String, callback: @escaping (_ resultCode: String, _ id: String, _ token: String) -> Void){
        let path = "\(pathToServer)user.auth?phone=\(phone)&password=\(password)"
        Alamofire.request(path).responseJSON(completionHandler:
                                        {response in
                                            guard response.result.isSuccess else{
                                                return
                                            }
                                            let json = JSON(response.result.value!)
                                            callback(json["result_code"].stringValue, json["id"].stringValue, json["token"].stringValue)
                                       })
    }
}
