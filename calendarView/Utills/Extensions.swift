
//  Extensions.swift

import UIKit

extension UITextField {
    func underlineIt() {
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: self.frame.height - 1, width: self.frame.width, height: 1)
        bottomLine.backgroundColor = UIColor.darkGray.cgColor
        self.borderStyle = .none
        self.layer.addSublayer(bottomLine)
    }
}

extension UILabel {
    func textWidth() -> CGFloat {
        return UILabel.textWidth(label: self)
    }
    
    class func textWidth(label: UILabel) -> CGFloat {
        return textWidth(label: label, text: label.text!)
    }
    
    class func textWidth(label: UILabel, text: String) -> CGFloat {
        return textWidth(font: label.font, text: text)
    }
    
    class func textWidth(font: UIFont, text: String) -> CGFloat {
        let myText = text as NSString
        
        let rect = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
        let labelSize = myText.boundingRect(with: rect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: UIFont(name: "Assistant-SemiBold", size: 12) as Any], context: nil)
        return ceil(labelSize.width)
    }
}


extension Date {
    
    var millisecondsSince1970:Int64 {
        return Int64((self.timeIntervalSince1970 * 1000.0).rounded())
//        return Int64((self.timeIntervalSinceNow * 1000.0).rounded())
    }
    
    init(milliseconds:Int64) {
//        self = Date(timeIntervalSinceNow: TimeInterval(milliseconds) / 1000)
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
    }
    
    func offsetFrom(date : Date) -> String {
        
        let dayHourMinuteSecond: Set<Calendar.Component> = [.day, .hour, .minute, .second]
        let difference = NSCalendar.current.dateComponents(dayHourMinuteSecond, from: self, to: date);
        
        let seconds = "\(abs(difference.second ?? 0))"
        let minutes = "\(abs(difference.minute ?? 0))"
        let hours = "\(abs(difference.hour ?? 0))"
        let days = "\(abs(difference.day ?? 0))"
    
        if days != "" && days != "0" {
//            if hours != "" && hours != "0" {
//                return "\(days) days & \(hours) hours"
//            }else{
                return "\(days) days"
//            }
            
        }else if hours != "" && hours != "0"{
//            if minutes != "" && minutes != "0" {
//                return "\(hours) hours & \(minutes) minutes"
//            }else{
                return "\(hours) hours"
//            }
            
        }else if minutes != "" && minutes != "0" {
//            if seconds != "" && seconds != "0" {
//                return "\(minutes) minutes & \(seconds) seconds"
//            }else{
                return "\(minutes) minutes"
//            }
            
        }else if seconds != "" && seconds != "0"{
            return "few seconds"
        }else{
            return ""
        }
    }
    
    func WordDate() -> String {
        let dayFormat =  DateFormatter()
        dayFormat.dateFormat = "EEEE"
        
        let monthFormat =  DateFormatter()
        monthFormat.dateFormat = "LLLL"
        
        let calendar = Calendar.current
        
        return "\(dayFormat.string(from: self)) \(calendar.component(.day, from: self))\(String().daySuffix(from: self)) \(monthFormat.string(from: self))"
    }
    
    func ChangeFromat(_ format : String) -> String {
        let Formatter =  DateFormatter()
        Formatter.dateFormat = format
        let farray = (Formatter.string(from: self)).components(separatedBy: " ")
        return "\(farray[0]) \(farray[1])\(String().daySuffix(from: self)) \(farray[2])"
    }
    
    //GET GMT STRING FROM DATE
    func getGMTstring() -> String {
        let GMTformatter = DateFormatter()
        GMTformatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        GMTformatter.timeZone = TimeZone(identifier:"GMT")
        return GMTformatter.string(from: self)
    }
    
    func getGMTime() -> String {
        let GMTformatter = DateFormatter()
        GMTformatter.dateFormat = "hh:mm a"
        GMTformatter.timeZone = TimeZone(identifier:"GMT")
        return GMTformatter.string(from: self)
    }
}

extension UIAlertController {
    
    class func actionWithMessage(_ message: String? = nil, title: String?  = nil, type: UIAlertController.Style, buttons: [String], buttonStyles: [UIAlertAction.Style] = [],controller: UIViewController ,block:@escaping (_ tapped: String)->()) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: type)
        for (idx,btn) in buttons.enumerated() {
            var style = UIAlertAction.Style.default
            if !buttonStyles.isEmpty && idx < buttonStyles.count{
                style = buttonStyles[idx]
            }
            alert.addAction(UIAlertAction(title: btn, style: style, handler: { (action) -> Void in
                block(btn)
            }))
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        controller.present(alert, animated: true, completion: nil)
    }
}


extension String {
    
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
    
    func ReturnFontedText(inRed : Bool, size : CGFloat?) -> NSAttributedString {
        if inRed {
            if let currentfont = UIFont(name: "OpenSans-Light", size: size ?? 14) {
                return NSAttributedString(string: self, attributes: [NSAttributedString.Key.foregroundColor : UIColor.red, NSAttributedString.Key.font : currentfont])
            }else{
                return NSAttributedString(string: self, attributes: [NSAttributedString.Key.foregroundColor : UIColor.red])
            }
        } else {
            if let currentfont = UIFont(name: "OpenSans-Light", size: size ?? 14) {
                return NSAttributedString(string: self, attributes: [NSAttributedString.Key.font : currentfont])
            }else{
                return NSAttributedString(string: self, attributes: [:])
            }
        }
    }
    
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    func localize() -> String {
        return NSLocalizedString(self, comment: "")
    }
    
    var mapValues: Double {
        return (self as NSString).doubleValue
    }
    
    func convertCurrency() -> String {
        
        var shortenedAmount = Double(self)!
        
        var suffix = ""
        
        if(shortenedAmount >= 10000000.0) {
            suffix = "C"
            shortenedAmount /= 10000000.0
        } else if(shortenedAmount >= 1000000.0) {
            suffix = "M"
            shortenedAmount /= 1000000.0
        } else if(shortenedAmount >= 100000.0) {
            suffix = "L"
            shortenedAmount /= 100000.0
        } else if(shortenedAmount >= 1000.0) {
            suffix = "K"
            shortenedAmount /= 1000.0;
        }
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        
        let numberAsString = numberFormatter.string(from: NSNumber(floatLiteral: shortenedAmount) )
        
        let requiredString = "\(numberAsString!) \(suffix)"
        
        return requiredString
    }
    
}

extension UIButton {
    func fitImage() {
        self.contentMode = .scaleAspectFit
        self.imageView?.contentMode = .scaleAspectFit
    }
    
    private func actionHandleBlock(action:(() -> Void)? = nil) {
        struct __ {
            static var action :(() -> Void)?
        }
        if action != nil {
            __.action = action
        } else {
            __.action?()
        }
    }
    
    @objc private func triggerActionHandleBlock() {
        self.actionHandleBlock()
    }
    
    func actionHandle(controlEvents control :UIControl.Event, ForAction action:@escaping () -> Void) {
        self.actionHandleBlock(action: action)
        self.addTarget(self, action: #selector(UIButton.triggerActionHandleBlock), for: control)
    }
    
}


extension UIView {
    func fadeIn(finished: @escaping () -> ()) {
        UIView.animate(withDuration: 0.4, animations: {
            self.alpha = 1
        }) { (finish) in
            if finish {
                finished()
            }
        }
        
    }
    func fadeOut(finished: @escaping () -> ()) {
        UIView.animate(withDuration: 0.4, animations: {
            self.alpha = 0
        }) { (finish) in
            if finish {
                finished()
            }
        }
    }
    
    func addShadow() {
        self.layer.cornerRadius = 0
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOpacity = 0.3
        self.layer.shadowRadius = 3
        self.layer.shadowOffset = CGSize(width: 0, height: 5)
    }
    
    func addBorder() {
       // self.layer.cornerRadius = 0
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.borderWidth = 1
    }
    
    func greenBorder() {
       // self.layer.cornerRadius = 0
        self.layer.borderColor = UIColor.green.cgColor
        self.layer.borderWidth = 1
    }
    
    func addRoundCorners(_ radius : CGFloat) {
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
    
    func roundUp() {
        self.layer.cornerRadius = self.frame.height / 2
        self.layer.masksToBounds = true
    }
    
    func addShadow(radius : CGFloat) {
        self.layer.cornerRadius = radius
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 3
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
    }
    
    func addShadowWithOffset(offset : CGSize) {
        self.layer.cornerRadius = 0
        self.layer.shadowColor = UIColor(red: 0.192, green: 0.478, blue: 0.882, alpha: 0.15).cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 1
        self.layer.shadowOffset = offset
    }
    
}

extension String {
    
    func makeBigWord() -> String {
        let arra = self.components(separatedBy: "_")
        var fullStr = ""
        for item in arra {
            fullStr.append(item.capitalized)
            fullStr.append(" ")
        }
            
        return fullStr
    }
    
    func polarityColor() -> NSAttributedString {
        if self.isNegativeNumber() {
            return NSAttributedString(string: self, attributes: [NSAttributedString.Key.foregroundColor : UIColor.red])
        }else{
            return NSAttributedString(string: self, attributes: [NSAttributedString.Key.foregroundColor : UIColor(red: 0.3098, green: 0.7529, blue: 0.2431, alpha: 1)])
        }
    }
    
    func isNegativeNumber() -> Bool {
        if self.contains("-") {
            return true
        }else{
            return false
        }
    }
    
    
    func getTwoDecimalString() -> String {
        let myDouble = Double(self)
        let percentage = String(format: "%.2f", myDouble ?? 0.0)
        return percentage
    }
    
    func getIntegerString() -> String {
        let myDouble = Int(self)
        let percentage = "\(myDouble ?? 0)"
        return percentage
    }
    
    func getDifference() -> String {
        let tmdate = Date(milliseconds: Int64(self)! )
        let abc = tmdate.getGMTstring()
        return abc.datePlease()
    }
    
    func getTimeOnly() -> String {
        let tmdate = Date(milliseconds: Int64(self)! )
        let abc = tmdate.getGMTime()
        
        return abc
    }
    
    func datePlease() -> String {
        let thestringdate = self.dateRaw()
        let thedate = thestringdate.ConvertToCustomDate()
        
        let abc = Date().getGMTstring()
        print( abc )
        print( abc.getGMTdate() )
        
        let vdate = thedate.offsetFrom(date: abc.getGMTdate()! )
        return vdate
    }
    
    func dateRaw() -> String {
        var thestringdate = ""
        let abc = self.components(separatedBy: "T")
        var time = [String]()
        if abc.count > 1 {
            time = abc[1].components(separatedBy: "Z")
            thestringdate = "\(abc[0]) \(time[0])"
        }else{
            thestringdate = "\(abc[0])"
        }

        return thestringdate
    }
    
    //GET GMT DATE FROM STRING
    func getGMTdate() -> Date? {
        let GMTformatter = DateFormatter()
        GMTformatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        GMTformatter.timeZone = TimeZone(identifier:"GMT")
        return GMTformatter.date(from: self)
    }
    
    func daySuffix(from date: Date) -> String {
        let calendar = Calendar.current
        let dayOfMonth = calendar.component(.day, from: date)
        switch dayOfMonth {
        case 1, 21, 31: return "st"
        case 2, 22: return "nd"
        case 3, 23: return "rd"
        default: return "th"
        }
    }
    
    func ConvertToCustomDate() -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.locale =  Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateStyle = DateFormatter.Style.long
        
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        
        var convertedDate : Date?
        
        convertedDate = dateFormatter.date(from: self)
        
        if convertedDate == nil {
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            convertedDate = dateFormatter.date(from: self)
        }
        
        return convertedDate!
    }
    
    func ConvertToCustomDateString(_ fullformat : Bool? ) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.locale =  Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateStyle = DateFormatter.Style.long
        
        if fullformat! {
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        }else{
            dateFormatter.dateFormat = "yyyy-MM-dd"
        }
        
        let convertedDate = dateFormatter.date(from: self)
        
        if convertedDate?.ChangeFromat("LLL dd yyyy") != nil {
            return (convertedDate?.ChangeFromat("LLL dd yyyy"))!
        }else{
            return ""
        }
    }

}

extension UIColor {
    
    convenience init(hex:Int, alpha:CGFloat = 1.0) {
        self.init(
            red:   CGFloat((hex & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((hex & 0x00FF00) >> 8)  / 255.0,
            blue:  CGFloat((hex & 0x0000FF) >> 0)  / 255.0,
            alpha: alpha
        )
    }
    
}

extension UIView {

    func rotate(_ toValue: CGFloat, duration: CFTimeInterval = 0.2) {
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        
        animation.toValue = toValue
        animation.duration = duration
        animation.isRemovedOnCompletion = false
        animation.fillMode = CAMediaTimingFillMode.forwards
        
        self.layer.add(animation, forKey: nil)
    }

}
