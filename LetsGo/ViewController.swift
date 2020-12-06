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
    //var callbackText: (_ data: CovidData?) -> Void = { _ in}
    
    var text:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textLabel?.text = data?.destination
        map.layer.cornerRadius = 10.0;
        // Do any additional setup after loading the view.
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
    }

}

