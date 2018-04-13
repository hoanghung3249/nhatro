//
//  Utilities.swift
//  Data Entry
//
//  Created by HOANGHUNG on 8/25/17.
//  Copyright © 2017 Apps Cyclone. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

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
    
    func getRegion(_ region: String) -> [RegionVN] {
        var arrRegion = [RegionVN]()
        guard let path = Bundle.main.path(forResource: "khuvuc", ofType: "json") else { return [] }
        let pathURL = URL(fileURLWithPath: path)
        do {
            let data = try Data(contentsOf: pathURL)
            guard let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String: Any] else { return [] }
            let jsonData = JSON(json)
            var keyRegion = ""
            switch region {
            case "Miền Bắc":
                keyRegion = "Bac"
            case "Miền Trung":
                keyRegion = "Trung"
            case "Miền Nam":
                keyRegion = "Nam"
            default:
                keyRegion = ""
            }
            guard let regions = jsonData[keyRegion].array else { return [] }
            for r in regions {
                let region = RegionVN(r)
                arrRegion.append(region)
            }
            return arrRegion
        } catch (let error) {
            print(error.localizedDescription)
            return []
        }
    }
    
    func beginBackgroundTask() -> UIBackgroundTaskIdentifier? {
        
        var backgroundTask: UIBackgroundTaskIdentifier?
        backgroundTask = UIApplication.shared.beginBackgroundTask(expirationHandler: {
            Utilities.shared.endBackgroundTask(backgroundTask)
        })
        
        return backgroundTask
    }
    
    func endBackgroundTask(_ task: UIBackgroundTaskIdentifier?) {
        
        guard let backgroundTask = task else {return}
        print("+++++++++End background \(backgroundTask)")
        UIApplication.shared.endBackgroundTask(backgroundTask)
    }
    
    func saveMotelLocal(_ motel: Motel) {
        RealmUtilities.updateRealmObject { (realm) in
            let motelRealm = MotelRealm()
            motelRealm.addOrUpdate(realm, motel: motel)
        }
        
        var imgDownload = [String:String]()
        imgDownload.updateValue(motel.avatar, forKey: "\(motel.motel_Id)img0")
        for index in 0..<motel.images.count {
            imgDownload.updateValue(motel.images[index].sub_image, forKey: "\(motel.motel_Id)img\(index + 1)")
            imgDownload.updateValue(motel.images[index].sub_image_thumb, forKey: "\(motel.motel_Id)img\(index + 1)thumb")
        }
        let download = DownloadSession(with: motel, imgDownload: imgDownload)
        for (key, value) in imgDownload {
            download.downloadFile(identifier: key, url: value)
        }
    }
    
    func getURL(with localName: String, urlString: String) -> URL? {
        guard let streamURL = URL(string: urlString) else { return nil }
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        let fileURL: URL
        
        let localURL = documentsURL.appendingPathComponent(localName)
        if FileManager.default.fileExists(atPath: localURL.path) {
            fileURL = localURL
        } else {
            fileURL = streamURL
        }
        return fileURL
    }
    
    func deleteLocalFile(fileName: String?) {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        if let name = fileName {
            let fileURL = documentsURL.appendingPathComponent("\(name)")
            do {
                try FileManager.default.removeItem(at: fileURL)
                print("\nDeleted local file: \(name)")
            } catch let error {
                print("Delete file fail: \(error.localizedDescription)")
            }
        }
    }
    
    func removeCache() {
        URLCache.shared.removeAllCachedResponses()
        URLCache.shared.diskCapacity = 0
        URLCache.shared.memoryCapacity = 0
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
                                                   attributes: [NSAttributedStringKey.underlineStyle: NSUnderlineStyle.styleSingle.rawValue]))
        attributedString.append(NSAttributedString(string: " of this service"))
        return attributedString
    }
    
    func removeData() {
        let userDefault = UserDefaults.standard
        userDefault.removeObject(forKey: "accessToken")
    }
    
    
}
