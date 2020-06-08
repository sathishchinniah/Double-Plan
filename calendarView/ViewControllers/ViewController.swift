//
//  ViewController.swift
//  calendarView
//
//  Created by sathish on 01/06/20.
//  Copyright © 2020 sathish. All rights reserved.
//

import UIKit
import FSCalendar

class ViewController: UIViewController, FSCalendarDelegate, FSCalendarDataSource, UITableViewDelegate, UITableViewDataSource, FSCalendarDelegateAppearance{
    
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var cityButton: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var eveningtableView: UITableView!
    
    var expand = false
    var collapsedarray = [Bool]()
    var selectdates = [Date]()
    var datesWithEvent = [String]()
    var divideday = ["Morning", "Noon", "Afternoon", "Evening", "Night"]
    
    fileprivate lazy var dateFormatter2: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "My Plan"
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: Notification.Name("refreshTable"), object: nil)
        
        self.cityButton.addShadow(radius: 15)
        tableView.register(UINib(nibName: "headerCell", bundle: nil), forCellReuseIdentifier: "headerCell")
        tableView.register(UINib(nibName: "EveningCell", bundle: nil), forCellReuseIdentifier: "EveningCell")
        
        
        calendar.dataSource = self
        calendar.delegate = self
        calendar.today = nil
        calendar.appearance.caseOptions = [.headerUsesUpperCase,.weekdayUsesSingleUpperCase]
        calendar.appearance.eventDefaultColor = .red
        calendar.select(Date())
        calendar.scope = FSCalendarScope.week
    }
    
    @objc func methodOfReceivedNotification(notification: Notification) {
        self.tableView.reloadData()
        self.tableView.layoutIfNeeded()
        
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        let dateString = self.dateFormatter2.string(from: date)
        if self.datesWithEvent.contains(dateString)
        {
            return 1
        }
        return 0
    }
    
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillDefaultColorFor date: Date) -> UIColor? {
        let dateString = self.dateFormatter2.string(from: date)
        if self.datesWithEvent.contains(dateString)
        {
            return UIColor(red: 96.0/255.0, green: 208.0/255.0, blue: 218.0/255.0, alpha: 1.0)
        }
        else
        {
            return UIColor(red: 213.0/255.0, green: 247.0/255.0, blue: 248.0/255.0, alpha: 1.0)
        }
    }
    
    
    //    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillSelectionColorFor date: Date) -> UIColor? {
    //        print("datesWithEvent",datesWithEvent)
    //        let dateString = self.dateFormatter2.string(from: date)
    //        if self.datesWithEvent.contains(dateString)
    //            {
    //                return UIColor(red: 213.0/255.0, green: 247.0/255.0, blue: 248.0/255.0, alpha: 1.0)
    //        }
    //        return appearance.selectionColor
    //    }
    //    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventDefaultColorsFor date: Date) -> [UIColor]? {
    //          let dateString = self.dateFormatter2.string(from: date)
    //           if self.datesWithEvent.contains(dateString)
    //               {
    //                return [UIColor(red: 213.0/255.0, green: 247.0/255.0, blue: 248.0/255.0, alpha: 1.0)]
    //           }
    //           return [appearance.selectionColor]
    //       }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        datesWithEvent = []
        datesWithEvent.append(self.dateFormatter2.string(from: date))
        selectdates.append(date)
        let newdate : Date = date.add(.day, value: 7)!
        selectdates.append(newdate)
        
        let dateString = self.dateFormatter2.string(from: newdate as Date)
        datesWithEvent.append(dateString)
        self.calendar.reloadData()
        
    }

    @IBAction func btnExpandTap(sender:UIButton)
    {
        DispatchQueue.main.async
            {
                if self.expand {
                    self.expand = false
                }else{
                    self.expand = true
                }
                self.tableView.reloadData()
        }
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 5
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if indexPath.row == 3
        {
            if expand
            {
                let defaults = UserDefaults.standard
                let count = defaults.integer(forKey: "count")
                
                return  CGFloat(count * 250 + 350)
            }
            else
            {
                return 62
            }
        }else
        {
            return 75
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if indexPath.row == 3
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "EveningCell", for: indexPath) as! EveningCell
            cell.collapseBtn.addTarget(self, action: #selector(collapsed(sender:)), for: .touchUpInside)
            
            return cell
        }else
        {
            let header = tableView.dequeueReusableCell(withIdentifier:"headerCell") as! headerCell
            header.selectionStyle = .none
            header.collapseBtn.tag = indexPath.row
            header.time.text = divideday[indexPath.row]
            return header
            
        }
    }
    @objc func collapsed(sender: UIButton){
        if expand
        {
            expand = false
        }else
        {
            expand = true
        }
        self.tableView.reloadData()
    }
}

extension Date {
    func add(_ unit: Calendar.Component, value: Int) -> Date? {
        return Calendar.current.date(byAdding: unit, value: value, to: self)
    }
}
