//
//  MapViewController.swift
//  LetsGo
//
//  Created by Marc Llort Maulion on 08/12/2020.
//

import UIKit
import MapKit

class MapViewController: UIViewController, CLLocationManagerDelegate {

    var locationManager: CLLocationManager?
    var previousLocation: CLLocation?
    @IBOutlet weak var map: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if locationManager==nil {
            locationManager = CLLocationManager()
        }
        
        locationManager!.delegate=self
        locationManager!.requestAlwaysAuthorization()
        locationManager!.requestLocation()
        
        searchLocationForText("Madrid")
    }
    
    func centerOnRegion(_ region: CLLocationCoordinate2D?){
        let diameter = 2000000
        if region == nil{
            let region: MKCoordinateRegion = MKCoordinateRegion(center: previousLocation!.coordinate, latitudinalMeters: CLLocationDistance(diameter), longitudinalMeters: CLLocationDistance(diameter))
            map.setRegion(region, animated: true)
        }else{
            let region: MKCoordinateRegion = MKCoordinateRegion(center: region!, latitudinalMeters: CLLocationDistance(diameter), longitudinalMeters: CLLocationDistance(diameter))
            map.setRegion(region, animated: true)
        }
    }
    
    func setPinOnCoordinate(_ point: CLLocationCoordinate2D, _ string: String){
        let annotation = MKPointAnnotation()
        annotation.coordinate = point
        annotation.title = string
        map.addAnnotation(annotation)
    }
    
    func searchLocationForText(_ string: String){
        
        let searchRequest = MKLocalSearch.Request()
        
        searchRequest.naturalLanguageQuery=string
        let search = MKLocalSearch(request: searchRequest)
        
        search.start { response, error in
            
            guard let response = response else {
                print("Error: \(error?.localizedDescription ?? "Unknown error").")
                return
            }
            
            if response.mapItems.count==0{return}
            
            let relevantItem = response.mapItems[0]
            self.centerOnRegion(relevantItem.placemark.coordinate)
            self.setPinOnCoordinate(relevantItem.placemark.coordinate, string)
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations
                            locations: [CLLocation]) {
        if locations.count == 0 {
            return
        }
        let location = locations.first!
        previousLocation = location
        centerOnRegion(nil)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("ERROR")
    }
}

