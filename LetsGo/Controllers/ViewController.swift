//
//  ViewController.swift
//  LetsGo
//
//  Created by Marc Llort Maulion on 01/12/2020.
//

import UIKit
import MapKit

class ViewController: UIViewController {

    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var origin: UILabel!
    @IBOutlet weak var cases: UILabel!
    @IBOutlet weak var infotext: UITextView!
    @IBOutlet weak var map: MKMapView!
    
    var data: CovidData?
    var text:String = ""
    var locationManager: CLLocationManager?
    var previousLocation: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textLabel?.text = data?.destination
        map.layer.cornerRadius = 10.0;
        
        if locationManager==nil {
            locationManager = CLLocationManager()
        }
        
        locationManager!.delegate=self
        locationManager!.requestAlwaysAuthorization()
        locationManager!.requestLocation()
        
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
    
    func setPinOnCoordinate(_ point: CLLocationCoordinate2D){
        let annotation = MKPointAnnotation()
        annotation.coordinate = point
        annotation.title = data!.destination
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
            self.setPinOnCoordinate(relevantItem.placemark.coordinate)
        }
    }
    
    func reload() {
        if data!.allowed {
            textLabel?.textColor=UIColor.green
        }else{
            textLabel?.textColor=UIColor.red
        }
        
        textLabel?.text = "Destination: " + data!.destination
        origin.text = "Origin: " + data!.origin
        cases.text = "New daily cases: " + String(data!.covid.newConfirmed)
        infotext.text = data!.info
        searchLocationForText(data!.destination)
    }

}

extension ViewController: CLLocationManagerDelegate{
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
