//
//  PointOfInterest.swift
//  LetsGo
//
//  Created by Marc Llort Maulion on 19/12/20.
//
import Foundation


struct PointOfInterest: Codable {
    var poiName: String
    var poiIsSaved: Bool
    var lat: Double
    var long: Double
    var address: String
    
    init(poiName: String, poiIsSaved: Bool, lat: Double, long: Double, address: String) {
        self.poiName = poiName
        self.poiIsSaved = poiIsSaved
        self.lat = lat
        self.long = long
        self.address = address
    }
}


