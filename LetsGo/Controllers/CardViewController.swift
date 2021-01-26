//
//  CardViewController.swift
//  LetsGo
//
//  Created by Marc Llort Maulion on 06/12/2020.
//

import UIKit
import Cards
import Foundation

class CardViewController: UIViewController, UISearchBarDelegate {
    
    @IBOutlet weak var second: CardHighlight!
    @IBOutlet weak var originText: UISearchBar!
    @IBOutlet weak var destinationText: UISearchBar!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var searchCard: CardHighlight!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var savedButton: UITabBarItem!
    @IBOutlet weak var mapButton: UITabBarItem!
    
    
    var covidRes: CovidData?
    var cardContent: ViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        originText.delegate=self
        destinationText.delegate=self
        
        self.spinner.isHidden=true
        second.delegate = self
        searchButton.layer.cornerRadius = 5.0
        
        
        cardContent = (storyboard?.instantiateViewController(withIdentifier: "CardContent") as!ViewController)
        second.shouldPresent(cardContent, from: self, fullscreen: true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        if searchBar.restorationIdentifier != "origin" {
            apiCall()
        }

    }
    
    func apiCall(){
        let params1 = "{\n    \"destination\": \""
        let params2 = "\",\n    \"origin\": \""
        let params3="\" \n}\n\n"
        let requestParams=params1+destinationText.text!+params2+originText.text!+params3
        
        let alert = UIAlertController(title: "Incomplete request", message: "Message", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        
        if originText.text!.isEmpty {
            alert.message = "Origin textbox is empty. The destination country should be written."
            self.present(alert, animated: true, completion: nil)
        }else if destinationText.text!.isEmpty{
            alert.message = "Destination textbox is empty. The destination country should be written."
            self.present(alert, animated: true, completion: nil)
        }else{
            self.spinner.isHidden=false
            print(requestParams)
            
            let postData = requestParams.data(using: .utf8)
            
            var request = URLRequest(url: URL(string: "https://canitravelto.wtf/travel")!,timeoutInterval: Double.infinity)
            request.addValue("SUPER_SECRET_API_KEY", forHTTPHeaderField: "X-Auth-Token")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("__cfduid=d59cffa497fa1f2020f55be31c8f17aa71607253145", forHTTPHeaderField: "Cookie")
            
            request.httpMethod = "POST"
            request.httpBody = postData
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data else {
                    print(String(describing: error))
                    return
                }
                do {
                    self.covidRes = try JSONDecoder().decode(CovidData.self, from: data)
                } catch let error {
                    print(error)
                }
                
            }.resume()
            
            self.spinner.isHidden=true
            self.searchCard.isHidden=false
        }
    }
    
    @IBAction func searchCall(_ sender: Any) {
        apiCall()
    }
    
    func random(min: Int, max:Int) -> Int {
        return min + Int(arc4random_uniform(UInt32(max - min + 1)))
    }
}


extension CardViewController: CardDelegate {
    func cardDidTapInside(card: Card) {
        cardContent?.data=covidRes
        cardContent?.reload()
    }
    
    func cardHighlightDidTapButton(card: CardHighlight, button: UIButton) {
        if card == self.second{
            card.open()
        }
    }
}
