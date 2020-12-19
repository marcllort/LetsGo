//
//  PlaceAnnotation.swift
//  LetsGo
//
//  Created by Marc Llort Maulion on 19/12/20.
//

import MapKit

class PlaceAnnotation: NSObject, MKAnnotation {
    @objc dynamic var coordinate: CLLocationCoordinate2D
    
    var title: String?
    var url: URL?
    
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
        super.init()
    }
}
