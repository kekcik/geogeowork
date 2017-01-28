//
//  LocationAnnotation.swift
//  GeoGeo
//
//  Created by Kirill Averyanov on 28/01/2017.
//  Copyright © 2017 Иван Трофимов. All rights reserved.
//

import Foundation
import MapKit
import UIKit


class LocationAnnotation: NSObject, MKAnnotation{
    var coordinate: CLLocationCoordinate2D
    var title: String? = ""
    var subtitle: String? = ""
    
    init(coordinate: CLLocationCoordinate2D, title: String?, subtitle: String?) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
    }
}
