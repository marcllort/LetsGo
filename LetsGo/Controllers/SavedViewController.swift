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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.poiGenerator()
        table.rowHeight = 85
        table.estimatedRowHeight = 95
        table.tableFooterView = UIView()
    }
    
    func poiGenerator(){
        pointsOfInterest.append(PointOfInterest(poiName: "prova2", poiIsSaved: false))
        pointsOfInterest.append(PointOfInterest(poiName: "prova1", poiIsSaved: true))
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
                self.tableView.reloadData()
            }))
            alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        }else{
            let alert = UIAlertController(title: "Que vols fer?", message: nil, preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Marcar como incompleta", style: .default, handler: { _ in
                self.pointsOfInterest[indexPath.row].poiIsSaved = false
                self.tableView.reloadData()
            }))
            alert.addAction(UIAlertAction(title: "Eliminar", style: .cancel, handler: { _ in
                self.pointsOfInterest.remove(at: indexPath.row)
                self.tableView.reloadData()
            }))
            present(alert, animated: true, completion: nil)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

}
