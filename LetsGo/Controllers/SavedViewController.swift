//
//  SavedViewController.swift
//  LetsGo
//
//  Created by Marc Llort Maulion on 08/12/2020.
//

import UIKit

class SavedViewController: UITableViewController {

    @IBOutlet var table: UITableView!
    var pointsOfInterest = [PointOfInterest]()
    private let keyUserDefaults = "saved_data"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getSavedPointsOfInterest()
        table.rowHeight = 85
        table.estimatedRowHeight = 95
        table.tableFooterView = UIView()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pointsOfInterest.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "poiCell", for: indexPath) as! PointOfInterestCell
        
        cell.poiTitleLabel.text = pointsOfInterest[indexPath.row].poiName
        cell.poiImageView.image = pointsOfInterest[indexPath.row].poiIsSaved ? UIImage(systemName: "star.fill") : UIImage(systemName: "star")
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if !pointsOfInterest[indexPath.row].poiIsSaved {
            let alert = UIAlertController(title: "Favourite", message: nil, preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Save as favourite", style: .default, handler: { _ in
                self.pointsOfInterest[indexPath.row].poiIsSaved = true
                self.removePointsOfInterest()
                self.savePointsOfInterest()
                tableView.reloadData()
            }))
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        }else{
            let alert = UIAlertController(title: "Action", message: nil, preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Unfavourite", style: .default, handler: { _ in
                self.pointsOfInterest[indexPath.row].poiIsSaved = false
                self.removePointsOfInterest()
                self.savePointsOfInterest()
                tableView.reloadData()
                
            }))
            alert.addAction(UIAlertAction(title: "Delete", style: .cancel, handler: { _ in
                self.pointsOfInterest.remove(at: indexPath.row)
                self.removePointsOfInterest()
                self.savePointsOfInterest()
                tableView.reloadData()
            }))
            present(alert, animated: true, completion: nil)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    

    func addPointOfInterest(newPoint: PointOfInterest) {
        pointsOfInterest.append(newPoint)
        
        let userDefaults = UserDefaults.standard
        userDefaults.removeObject(forKey: "saved")
        
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(pointsOfInterest) {
            userDefaults.setValue(encoded, forKey: "saved")
            tableView.reloadData()
        }
    }
    
    func savePointsOfInterest() {
        removePointsOfInterest()
        let userDefaults = UserDefaults.standard
        
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(pointsOfInterest) {
            userDefaults.setValue(encoded, forKey: "saved")
        }
    }
    
    func removePointsOfInterest() {
        let userDefaults = UserDefaults.standard
        userDefaults.removeObject(forKey: "saved")
    }
    
    func userDataExist() -> Bool {
        return UserDefaults.standard.object(forKey: "saved") != nil
    }
    
    func getSavedPointsOfInterest() {
        let userDefaults = UserDefaults.standard
        if let savedData = userDefaults.object(forKey: "saved") as? Data {
            let decoder = JSONDecoder()
            if let points = try? decoder.decode([PointOfInterest].self, from: savedData) {
                pointsOfInterest = points
            }
        }
    }

}
