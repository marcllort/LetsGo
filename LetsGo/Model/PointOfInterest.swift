//
//  PointOfInterest.swift
//  LetsGo
//
//  Created by Marc Llort Maulion on 19/12/20.
//
import Foundation




class PointOfInterest: Codable {
    var poiName: String
    var poiIsSaved: Bool
    
    init(poiName: String, poiIsSaved: Bool) {
        self.poiName = poiName
        self.poiIsSaved = poiIsSaved
    }
}


