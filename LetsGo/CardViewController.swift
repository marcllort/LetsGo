//
//  CardViewController.swift
//  LetsGo
//
//  Created by Marc Llort Maulion on 06/12/2020.
//

import UIKit
import Cards
import Foundation

class CardViewController: UIViewController {
    
    @IBOutlet weak var second: CardHighlight!
    
    let colors = [
        
        UIColor.red,
        UIColor.yellow,
        UIColor.blue,
        UIColor.green,
        UIColor.gray,
        UIColor.brown,
        UIColor.purple,
        UIColor.orange
        
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        
        second.delegate = self
        let cardContent = storyboard?.instantiateViewController(withIdentifier: "CardContent")
        second.shouldPresent(cardContent, from: self, fullscreen: true)
        
        
    }
    
    func random(min: Int, max:Int) -> Int {
        return min + Int(arc4random_uniform(UInt32(max - min + 1)))
    }
}


extension CardViewController: CardDelegate {
    
    func cardDidTapInside(card: Card) {
        
        
            print("Hey, I'm the second one :)")
        
    }
    
    func cardHighlightDidTapButton(card: CardHighlight, button: UIButton) {
        
        card.buttonText = "OPEN!"
        
        if card == self.second {
            card.open()
        }
    }
    
}



