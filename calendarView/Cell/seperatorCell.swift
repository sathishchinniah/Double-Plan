//
//  seperatorCell.swift
//  calendarView
//
//  Created by sathish on 03/06/20.
//  Copyright © 2020 Minkle Garg. All rights reserved.
//

import UIKit

class seperatorCell: UITableViewCell {

    @IBOutlet weak var seperatorCornerView: UIView! {
        didSet {
            seperatorCornerView.layer.cornerRadius = 20
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
