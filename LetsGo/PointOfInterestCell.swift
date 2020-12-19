//
//  PointOfInterestCell.swift
//  LetsGo
//
//  Created by Marc Llort Maulion on 19/12/20.
//

import UIKit

class PointOfInterestCell: UITableViewCell {

    @IBOutlet weak var poiImageView: UIImageView!
    @IBOutlet weak var poiTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let bg = UIView()
        bg.backgroundColor = UIColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 1)
        selectedBackgroundView = bg
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
