//
//  TableViewCell.swift
//  calendarView
//
//  Created by sathish on 01/06/20.
//  Copyright © 2020 sathish. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    @IBOutlet weak var dashedView: UIView!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var barImage: UIImageView!
    @IBOutlet weak var restauranType: UILabel!
    @IBOutlet weak var restaurantName: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var deliverytime: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var acceptBtn: UIButton!
    @IBOutlet weak var declineBtn: UIButton!

    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.acceptBtn.addRoundCorners(10)
        self.declineBtn.addRoundCorners(10)
        self.bgView.addShadow(radius: 5)

        // Initialization code
        let topPoint = CGPoint(x: dashedView.frame.midX, y: dashedView.bounds.minY)
        let bottomPoint = CGPoint(x: dashedView.frame.midX, y: dashedView.bounds.maxY)

        dashedView.createDashedLine(from: topPoint, to: bottomPoint, color: .black, strokeLength: 4, gapLength: 6, width: 2)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}


extension UIView {

    func createDashedLine(from point1: CGPoint, to point2: CGPoint, color: UIColor, strokeLength: NSNumber, gapLength: NSNumber, width: CGFloat) {
        let shapeLayer = CAShapeLayer()

        shapeLayer.strokeColor = color.cgColor
        shapeLayer.lineWidth = width
        shapeLayer.lineDashPattern = [strokeLength, gapLength]

        let path = CGMutablePath()
        path.addLines(between: [point1, point2])
        shapeLayer.path = path
        layer.addSublayer(shapeLayer)
    }
}
