//
//  Artwork.swift
//  Networking_Example
//
//  Created by Ayaan Ruhi on 10/25/18.
//  Copyright © 2018 parth. All rights reserved.
//

import Foundation
import MapKit

class SchoolMap: NSObject, MKAnnotation {
    let title: String?
    let locationName: String
    let coordinate: CLLocationCoordinate2D
    
    init(title: String, locationName: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.locationName = locationName
        self.coordinate = coordinate
    
        super.init()
    }
    
    var subtitle: String? {
        return locationName
    }
}
