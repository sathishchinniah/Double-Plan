//
//  eveningHeaderCell.swift
//  calendarView
//
//  Created by sathish on 01/06/20.
//  Copyright © 2020 sathish. All rights reserved.
//

import UIKit

class eveningHeaderCell: UITableViewCell {
    @IBOutlet weak var hostImage: UIImageView!
    @IBOutlet weak var bgView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.hostImage.roundUp()
        self.bgView.addShadow(radius: 5)

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
