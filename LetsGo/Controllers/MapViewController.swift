//
//  MapViewController.swift
//  LetsGo
//
//  Created by Marc Llort Maulion on 08/12/2020.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    private enum AnnotationReuseID: String {
        case pin
    }
    
    @IBOutlet private var mapView: MKMapView!
    
    var mapItems: [MKMapItem]?
    var boundingRegion: MKCoordinateRegion?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let region = boundingRegion {
            mapView.region = region
        }
        mapView.delegate = self
        
        // Show the compass button in the navigation bar.
        let compass = MKCompassButton(mapView: mapView)
        compass.compassVisibility = .visible
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: compass)
        mapView.showsCompass = false
    
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: AnnotationReuseID.pin.rawValue)
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier)
            
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        guard let mapItems = mapItems else { return }
        
        if mapItems.count == 1, let item = mapItems.first {
            title = item.name
        } else {
            title = "All Places"
        }
        
        // Turn the array of MKMapItem objects into an annotation with a title and URL that can be shown on the map.
        let annotations = mapItems.compactMap { (mapItem) -> PlaceAnnotation? in
            guard let coordinate = mapItem.placemark.location?.coordinate else { return nil }
            
            let annotation = PlaceAnnotation(coordinate: coordinate)
            annotation.title = mapItem.name
            annotation.url = mapItem.url
            
            return annotation
        }
        mapView.addAnnotations(annotations)
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapViewDidFailLoadingMap(_ mapView: MKMapView, withError error: Error) {
        print("Error: \(error)")
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? PlaceAnnotation else { return nil }
        
        let view = mapView.dequeueReusableAnnotationView(withIdentifier: AnnotationReuseID.pin.rawValue, for: annotation) as? MKMarkerAnnotationView
        view?.canShowCallout = true
        view?.clusteringIdentifier = "searchResult"
        
        return view
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let annotation = view.annotation as? PlaceAnnotation else { return }
        if let url = annotation.url {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
