//
//  headerCell.swift
//  calendarView
//
//  Created by sathish on 01/06/20.
//  Copyright © 2020 sathish. All rights reserved.
//

import UIKit

class headerCell: UITableViewCell {
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var timeImage: UIImageView!
    @IBOutlet weak var collapseBtn: UIButton!
    @IBOutlet weak var temperature: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.bgView.addRoundCorners(8)
        self.bgView.addShadow(radius: 5)
       // self.collapseBtn.roundUp()
        self.collapseBtn.addShadow(radius: self.collapseBtn.frame.height / 2)


    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
