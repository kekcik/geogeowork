//
//  UserAnnotation.swift
//  GeoGeo
//
//  Created by Kirill Averyanov on 24/01/2017.
//  Copyright © 2017 Иван Трофимов. All rights reserved.
//

import Foundation
import MapKit
import UIKit

class UserAnnotation: NSObject, MKAnnotation{
    var user: UserClass = UserClass()
    var coordinate: CLLocationCoordinate2D
    var title: String? = ""
    var subtitle: String? = ""
    
    init(user: UserClass){
        self.user = user
        self.title = user.name
        self.subtitle = user.phone
        self.coordinate = CLLocationCoordinate2D(latitude: Double(user.lat)!, longitude: Double(user.lon)!)
    }
}
