//
//  EveningCell.swift
//  calendarView
//
//  Created by sathish on 01/06/20.
//  Copyright © 2020 sathish. All rights reserved.
//

import UIKit

class EveningCell: UITableViewCell, UITableViewDataSource, UITableViewDelegate {
       @IBOutlet weak var bgView: UIView!
       @IBOutlet weak var time: UILabel!
       @IBOutlet weak var timeImage: UIImageView!
       @IBOutlet weak var collapseBtn: UIButton!
       @IBOutlet weak var temperature: UILabel!
       @IBOutlet weak var tableview: UITableView!
    
       var status = [false, false, false, false]
       var acceptstatus = [false, false, false, false]
       var rejectstatus = [false, false, false, false]

    override func awakeFromNib() {
        super.awakeFromNib()
        
        let defaults = UserDefaults.standard
        defaults.set(status.count - 2, forKey: "count")
        if #available(iOS 11.0, *) {
           self.bgView.clipsToBounds = true
           bgView.layer.cornerRadius = 20
           bgView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        }
        // Initialization code
        tableview.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "TableViewCell")
        tableview.register(UINib(nibName: "eveningFooterCell", bundle: nil), forCellReuseIdentifier: "eveningFooterCell")
        tableview.register(UINib(nibName: "eveningHeaderCell", bundle: nil), forCellReuseIdentifier: "eveningHeaderCell")

    }
        func viewDidLayoutSubviews() {
            self.bgView.setNeedsLayout()
            self.bgView.layoutIfNeeded()
        }
       
    func roundedButton(){
        let maskPath1 = UIBezierPath(roundedRect: bounds,
            byRoundingCorners: [.topLeft , .topRight],
            cornerRadii: CGSize(width: 8, height: 8))
        let maskLayer1 = CAShapeLayer()
        maskLayer1.frame = bounds
        maskLayer1.path = maskPath1.cgPath
        layer.mask = maskLayer1
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return status.count
    }
        
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if indexPath.row == 0
        {
            return 80
        }else if indexPath.row == self.status.count - 1
        {
            return 200
        }
        else
        {
            return 250
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if indexPath.row == 0
        {
           let header = tableView.dequeueReusableCell(withIdentifier:"eveningHeaderCell") as! eveningHeaderCell
           return header
        }
        else if indexPath.row == self.status.count - 1
        {
            let cellID = "eveningFooterCell"
                       let cell = tableView.dequeueReusableCell(withIdentifier:cellID, for: indexPath) as! eveningFooterCell
                       return cell
        }
        else
        {
            let cellID = "TableViewCell"
            let cell = tableView.dequeueReusableCell(withIdentifier:cellID, for: indexPath) as! TableViewCell
            cell.acceptBtn.addTarget(self, action: #selector(accepted(sender:)), for: .touchUpInside)
            cell.declineBtn.addTarget(self, action: #selector(rejected(sender:)), for: .touchUpInside)
            cell.acceptBtn.isHidden = false
            cell.declineBtn.isHidden = false
            cell.acceptBtn.tag = indexPath.row
            cell.declineBtn.tag = indexPath.row
            if status[indexPath.row] == false
            {
                cell.acceptBtn.isHidden = false
                cell.declineBtn.isHidden = false
            }else
            {
                if acceptstatus[indexPath.row] == true
                {
                    cell.acceptBtn.setTitle("Accepted", for: .normal)
                    cell.acceptBtn.greenBorder()
                    cell.acceptBtn.backgroundColor = UIColor.white
                    cell.acceptBtn.setTitleColor(.green, for: .normal)
                    cell.declineBtn.isHidden = true
                }
                if rejectstatus[indexPath.row] == true
                {
                    cell.acceptBtn.setTitle("Declined", for: .normal)
                    cell.declineBtn.isHidden = true
                }
            }
            return cell
        }

    }
    
    @objc func accepted(sender: UIButton){
        acceptstatus [sender.tag] = true
        status[sender.tag] = true
        self.tableview.reloadData()
        
    }
    
    @objc func rejected(sender: UIButton){
        let defaults = UserDefaults.standard
        rejectstatus[sender.tag] = true
        status.remove(at: sender.tag)
        acceptstatus.remove(at: sender.tag)
        rejectstatus.remove(at: sender.tag)
        defaults.set(defaults.integer(forKey: "count") - 1, forKey: "count")
        NotificationCenter.default.post(name: Notification.Name("refreshTable"), object: nil)
        self.tableview.reloadData()
    }
}
