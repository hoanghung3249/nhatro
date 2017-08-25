//
//  Utilities.swift
//  Data Entry
//
//  Created by HOANGHUNG on 8/25/17.
//  Copyright © 2017 Apps Cyclone. All rights reserved.
//

import Foundation
import UIKit

struct Utilities {
    
    static let shared = Utilities()
    
    func showAlerControler(title: String?, message: String?, confirmButtonText: String?, cancelButtonText: String?, atController: UIViewController, completion: @escaping (_ isButtonConfirm: Bool) -> Void){
        let alert: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if let cancelStr = cancelButtonText{
            let cancelButton = UIAlertAction(title: cancelStr, style: .default, handler: { (ACTION) -> Void in
                completion(false)
            })
            alert.addAction(cancelButton)
        }
        if let confirmStr = confirmButtonText{
            let confirmButton = UIAlertAction(title: confirmStr, style: .cancel, handler: { (ACTION) -> Void in
                completion(true)
            })
            alert.addAction(confirmButton)
        }
        atController.present(alert, animated: true, completion: nil)
    }
    
    //Create JSON String
    func createJsonRequest(_ paramJsonRequest:[String:AnyObject]) -> [String:AnyObject] {
        var jsonString  = ""
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: paramJsonRequest, options: JSONSerialization.WritingOptions.prettyPrinted)
            let string = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)
            jsonString = string! as String
            
        } catch {
            print(error.localizedDescription)
        }
        return ["jsonRequest": jsonString as AnyObject]
        
    }
    
    //Delay action
    func delayWithSeconds(_ seconds: Double, completion: @escaping () -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            completion()
        }
    }
    
    //MARK: - Calendar Support Functions
    ///output: [JAN 2017, FEB 2017,...]
    func getAllMonthsInCurYear() -> [String]{
        var monthData:[String] = []
        let curYear = Calendar.current.component(.year, from: Date())
        for month in Calendar.current.shortMonthSymbols{
            monthData.append("\(month.uppercased()) \(curYear)")
        }
        return monthData
    }
    
    func getCurrentTime() -> String  {
        var currentDate = ""
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE"
        let curDate = dateFormatter.string(from: date)
        let calendar = Calendar.current
        let curMonth = calendar.component(.month, from: date)
        let arrMonth = calendar.monthSymbols
        let monthString = arrMonth[curMonth - 1]
        let curYear = String(calendar.component(.year, from: date))
        let day = String(calendar.component(.day, from: date))
        currentDate = curDate + ", " + monthString + " " + day + ", " + curYear
        return currentDate
    }
    
    func getCurMonth() -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM yyyy"
        let result = formatter.string(from: date)
        return result
    }
    
    func getMonthsIn1Year() -> [String] {
        var monthData:[String] = []
        let date = Date()
        let calendar = Calendar.current
        let curYear = Calendar.current.component(.year, from: date)
        let curMonth = calendar.component(.month, from: date)
        for month in 0..<Calendar.current.shortMonthSymbols.count {
            if month < curMonth {
                monthData.append("\(Calendar.current.shortMonthSymbols[month]) \(curYear)")
            } else {
                monthData.append("\(Calendar.current.shortMonthSymbols[month]) \(curYear - 1)")
            }
        }
        return monthData
    }
    
    ///Return array of days in 6 weeks (Monday -> Friday). Input: JAN 2017
    func getAllDaysInMonth(weekdays:[Int], month: String) -> [Int]{
        var data:[Int] = []
        ///Monday -> Friday
        let weekdays:[Int] = weekdays
        for i in 0..<6{
            for weekday in weekdays{
                data.append(getDayFrom(weekday: weekday, weekOfYear: getFirstWeekOfMonth(month: month) + i))
            }
        }
        return data
    }
    
    func removeDayNotInCurrentMonth(data:[Int]) -> [Int]{
        var result = data
        for i in 0..<result.count{
            if (result[i] > 15 && i < 10) || (result[i] < 15 && i > result.count - 10){
                result[i] = 0
            }
        }
        return result
    }
    
    private func getFirstWeekOfMonth(month: String) -> Int{
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM yyyy"
        let date:Date = formatter.date(from: month)!
        return Calendar.current.component(.weekOfYear, from: date)
    }
    
    private func getDayFrom(weekday:Int, weekOfYear:Int) -> Int{
        var comp = DateComponents()
        comp.weekOfYear = weekOfYear
        comp.weekday = weekday
        comp.yearForWeekOfYear = Calendar.current.component(.year, from: Date())
        let date = Calendar.current.date(from: comp)
        
        return Calendar.current.component(.day, from: date!)
    }
    
    
    func getStringTerm() -> NSAttributedString {
        let attributedString = NSMutableAttributedString()
        attributedString.append(NSAttributedString(string: "Before you use this service, you must have "))
        attributedString.append(NSAttributedString(string: "\nagreed to the "))
        attributedString.append(NSAttributedString(string: "terms and conditions",
                                                   attributes: [NSUnderlineStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue]))
        attributedString.append(NSAttributedString(string: " of this service"))
        return attributedString
    }
    
    func removeData() {
        let userDefault = UserDefaults.standard
        userDefault.removeObject(forKey: "accessToken")
    }
    
    
}
