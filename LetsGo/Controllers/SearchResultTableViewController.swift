//
//  SearchResultTableViewController.swift
//  LetsGo
//
//  Created by Marc Llort Maulion on 19/12/20.
//

import UIKit
import CoreLocation
import MapKit

class SearchResultTableViewController: UITableViewController {
    
    private enum SegueID: String {
        case showDetail
        case showAll
    }
    
    private enum CellReuseID: String {
        case resultCell
    }
    
    private var places: [MKMapItem]? {
        didSet {
            tableView.reloadData()
            viewAllButton.isEnabled = places != nil
        }
    }
    
    private var suggestionController: SuggestionsTableViewController!
    private var searchController: UISearchController!
    
    @IBOutlet private var viewAllButton: UIBarButtonItem!
    
    private let locationManager = CLLocationManager()
    private var currentPlacemark: CLPlacemark?
    private var boundingRegion: MKCoordinateRegion = MKCoordinateRegion(MKMapRect.world)
    
    private var foregroundRestorationObserver: NSObjectProtocol?
    
    private var localSearch: MKLocalSearch? {
        willSet {
            places = nil
            localSearch?.cancel()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        locationManager.delegate = self
        
        suggestionController = SuggestionsTableViewController(style: .grouped)
        suggestionController.tableView.delegate = self
        
        searchController = UISearchController(searchResultsController: suggestionController)
        searchController.searchResultsUpdater = suggestionController
        searchController.searchBar.barStyle = UIBarStyle.black
        
        let name = UIApplication.willEnterForegroundNotification
        foregroundRestorationObserver = NotificationCenter.default.addObserver(forName: name, object: nil, queue: nil, using: { [unowned self] (_) in
            self.requestLocation()
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.delegate = self
        definesPresentationContext = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        requestLocation()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let mapViewController = segue.destination as? MapViewController else {
            return
        }
        
        if segue.identifier == SegueID.showDetail.rawValue {
            guard let selectedItemPath = tableView.indexPathForSelectedRow, let mapItem = places?[selectedItemPath.row] else { return }

            var region = boundingRegion
            region.center = mapItem.placemark.coordinate
            mapViewController.boundingRegion = region
            mapViewController.mapItems = [mapItem]
            
        } else if segue.identifier == SegueID.showAll.rawValue {
            mapViewController.boundingRegion = boundingRegion
            var saved: [MKMapItem] = []
            
            let viewController = UIApplication.shared.windows[0].rootViewController?.children[2] as! SavedViewController
            viewController.getSavedPointsOfInterest()
            for place in viewController.pointsOfInterest {
                let lat:CLLocationDegrees = place.lat
                let long:CLLocationDegrees = place.long
                
                let coordinates = CLLocationCoordinate2DMake(lat, long)
                let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
                
                let mapItem = MKMapItem(placemark: placemark)
                mapItem.name = place.address
                saved.append(mapItem)
            }
            mapViewController.mapItems = saved
        }
    }
    
    private func search(for suggestedCompletion: MKLocalSearchCompletion) {
        let searchRequest = MKLocalSearch.Request(completion: suggestedCompletion)
        search(using: searchRequest)
    }
    
    private func search(for queryString: String?) {
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = queryString
        search(using: searchRequest)
    }
    
    private func search(using searchRequest: MKLocalSearch.Request) {
        searchRequest.region = boundingRegion
        searchRequest.resultTypes = .pointOfInterest
        
        localSearch = MKLocalSearch(request: searchRequest)
        localSearch?.start { [unowned self] (response, error) in
            guard error == nil else {
                self.displaySearchError(error)
                return
            }
            self.places = response?.mapItems
            
            if let updatedRegion = response?.boundingRegion {
                self.boundingRegion = updatedRegion
            }
        }
    }
    
    private func displaySearchError(_ error: Error?) {
        if let error = error as NSError?, let errorString = error.userInfo[NSLocalizedDescriptionKey] as? String {
            let alertController = UIAlertController(title: "Could not find any places.", message: errorString, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alertController, animated: true, completion: nil)
        }
    }
}


extension SearchResultTableViewController {
    private func requestLocation() {
        guard CLLocationManager.locationServicesEnabled() else {
            displayLocationServicesDisabledAlert()
            return
        }
        
        let status = CLLocationManager.authorizationStatus()
        guard status != .denied else {
            displayLocationServicesDeniedAlert()
            return
        }
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    private func displayLocationServicesDisabledAlert() {
        let message = "Location services are not enabled on this device. Please enable location services in Settings."
        let alertController = UIAlertController(title: "Location Services", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    private func displayLocationServicesDeniedAlert() {
        let message = "Location services are not enabled on this device. Please enable location services in Settings."
        let alertController = UIAlertController(title: "Location Services", message: message, preferredStyle: .alert)
        let settingsButtonTitle = "Settings"
        let openSettingsAction = UIAlertAction(title: settingsButtonTitle, style: .default) { (_) in
            if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
            }
        }
        
        let cancelButtonTitle = "Cancel"
        let cancelAction = UIAlertAction(title: cancelButtonTitle, style: .cancel, handler: nil)
        
        alertController.addAction(cancelAction)
        alertController.addAction(openSettingsAction)
        present(alertController, animated: true, completion: nil)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellReuseID.resultCell.rawValue, for: indexPath)
        
        if let mapItem = places?[indexPath.row] {
            cell.textLabel?.text = mapItem.name
            cell.detailTextLabel?.text = mapItem.placemark.formattedAddress
        }
        
        let searchedPoint = PointOfInterest(poiName: (cell.textLabel?.text)!, poiIsSaved: false, lat: (places?[indexPath.row].placemark.coordinate.latitude)!,
                                            long: (places?[indexPath.row].placemark.coordinate.longitude)!, address: (places?[indexPath.row].name)!)
        
        let savedController = UIApplication.shared.windows[0].rootViewController?.children[2] as! SavedViewController
        savedController.addPointOfInterest(newPoint: searchedPoint)
                
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var header = "Search results"
        if let city = currentPlacemark?.locality {
            let templateString = "Search Results Near %@"
            header = String(format: templateString, city)
        }
        
        return header
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if tableView == suggestionController.tableView, let suggestion = suggestionController.completerResults?[indexPath.row] {
            searchController.isActive = false
            searchController.searchBar.text = suggestion.title
            search(for: suggestion)
        }
    }
}

extension SearchResultTableViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { (placemark, error) in
            guard error == nil else { return }
            
            self.currentPlacemark = placemark?.first
            self.boundingRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 12_000, longitudinalMeters: 12_000)
            self.suggestionController.updatePlacemark(self.currentPlacemark, boundingRegion: self.boundingRegion)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    }
}

extension SearchResultTableViewController: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        dismiss(animated: true, completion: nil)
        search(for: searchBar.text)
    }
}
