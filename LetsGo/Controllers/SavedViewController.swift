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
        self.poiGenerator()
        table.rowHeight = 85
        table.estimatedRowHeight = 95
        table.tableFooterView = UIView()
    }
    
    func poiGenerator(){
       /* pointsOfInterest.append(PointOfInterest(poiName: "prova2", poiIsSaved: false))
        pointsOfInterest.append(PointOfInterest(poiName: "prova1", poiIsSaved: true))
    */
        if userDataExist() {
            getSavedPointsOfInterest()
        }
        else {
            
        }
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
            let alert = UIAlertController(title: "Marcar com a completeada", message: nil, preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Marcar como completa", style: .default, handler: { _ in
                self.pointsOfInterest[indexPath.row].poiIsSaved = true
                self.savePointsOfInterest()
                self.tableView.reloadData()
            }))
            alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        }else{
            let alert = UIAlertController(title: "Que vols fer?", message: nil, preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Marcar como incompleta", style: .default, handler: { _ in
                self.pointsOfInterest[indexPath.row].poiIsSaved = false
                self.savePointsOfInterest()
                self.tableView.reloadData()
            }))
            alert.addAction(UIAlertAction(title: "Eliminar", style: .cancel, handler: { _ in
                self.pointsOfInterest.remove(at: indexPath.row)
                self.savePointsOfInterest()
                self.tableView.reloadData()
                //self.savePointsOfInterest()
            }))
            present(alert, animated: true, completion: nil)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    

    func addPointOfInterest(newPoint: PointOfInterest) {
        pointsOfInterest.append(newPoint)
        
        //Borrar datos de user defaults y añadir el array de nuevo con el nuevo dato
        let newData = SavedData(points: pointsOfInterest)

        //let userDefaults = UserDefaults.standard
        
        removePointsOfInterest()
        let userDefaults = UserDefaults.standard
        
        do {
            let encodedData = try NSKeyedArchiver.archivedData(withRootObject: newData, requiringSecureCoding: false)

            try userDefaults.set(encodedData, forKey: keyUserDefaults)
            userDefaults.synchronize()

        } catch {
            print(error.localizedDescription)
        }
        tableView.reloadData()
    }
    
    func savePointsOfInterest() {
        let newData = SavedData(points: pointsOfInterest)
        //let userDefaults = UserDefaults.standard
        
        removePointsOfInterest()
        let userDefaults = UserDefaults.standard
        
        do {
            let encodedData = try NSKeyedArchiver.archivedData(withRootObject: newData, requiringSecureCoding: false)

            try userDefaults.set(newData, forKey: keyUserDefaults)
            userDefaults.synchronize()

        } catch  {
            print(error.localizedDescription)
        }
        
        tableView.reloadData()
    }
    
    func removePointsOfInterest() {
        if userDataExist() {
            let userDefaults = UserDefaults.standard
            userDefaults.removeObject(forKey: keyUserDefaults)
        }
        tableView.reloadData()
    }
    
    func userDataExist() -> Bool {
        return UserDefaults.standard.object(forKey: keyUserDefaults) != nil
    }
    
    func getSavedPointsOfInterest() {
        let userDefaults = UserDefaults.standard
        
        if userDataExist() {
            do {
                let savedData = try userDefaults.data(forKey: keyUserDefaults)
                let decodedData = NSKeyedUnarchiver.unarchiveObject(with: savedData!) as! SavedData

                pointsOfInterest = decodedData.points
            } catch {
                print(error.localizedDescription)
            }
        }
    }

}
