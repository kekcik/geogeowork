//
//  LocationClass.swift
//  GeoGeo
//
//  Created by Kirill Averyanov on 18/01/2017.
//  Copyright © 2017 Иван Трофимов. All rights reserved.
//

import Foundation


class LocationClass{
    var lat: String? = nil
    var lon: String? = nil
    var accuracy: String? = nil
    var createdAt: String? = nil
    
    init(lat: String?, lon: String?, accuracy: String?, createdAt: String?){
        self.lat = lat
        self.lon = lon
        self.accuracy = accuracy
        self.createdAt = createdAt
    }
}
