//
//  ActivityAnnotation.swift
//  PercepTrail
//
//  Created by imac-2627 on 2024/6/25.
//

import MapKit

class ActivityAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var imageName: String

    init(name: String, coordinate: CLLocationCoordinate2D, imageName: String) {
        self.title = name
        self.coordinate = coordinate
        self.imageName = imageName
    }
}

class DestinationAnnotation: NSObject, MKAnnotation {
    dynamic var coordinate: CLLocationCoordinate2D
    var title: String?
    var imageName: String?

    init(coordinate: CLLocationCoordinate2D, title: String, imageName: String) {
        self.coordinate = coordinate
        self.title = title
        self.imageName = imageName
    }
}

