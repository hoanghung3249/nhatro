//
//  DownloadSession.swift
//  NhaTro
//
//  Created by HOANGHUNG on 12/22/17.
//  Copyright © 2017 HOANG HUNG. All rights reserved.
//

import Foundation
import UIKit

class DownloadSession: NSObject {
    
    private var session: URLSession?
    let motelDownload: Motel
    let imgDownloaded: [String:String]
    var identifier = ""
    var url = ""
    
    // MARK: - Singleton
    /* init */
    init(with file: Motel, imgDownload:[String:String]) {
        motelDownload = file
        imgDownloaded = imgDownload
        super.init()
    }
    
    private func getSession(_ identifier: String) -> URLSession {
        if session == nil {
            let configuration = URLSessionConfiguration.background(withIdentifier: identifier)
            configuration.networkServiceType = .background
            if #available(iOS 9.0, *) {
                configuration.shouldUseExtendedBackgroundIdleMode = true
            } else {
                // Fallback on earlier versions
            }
            
            configuration.allowsCellularAccess = true
            configuration.sessionSendsLaunchEvents = true
            configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
            configuration.timeoutIntervalForResource = 2 * 60 * 60
            
            session = URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
        }
        
        return session!
    }
    
    func cancel() {
        session?.invalidateAndCancel()
        session = nil
    }
    
    func downloadFile(identifier: String, url: String) {
        self.identifier = identifier
        self.url = url
        let session = getSession(identifier)
        
        session.getTasksWithCompletionHandler({ [weak self] (_, _, downloadTasks) in
            if let _ = downloadTasks.first(where: { $0.state == .running }) {
                print("   A download task is running")
                return
            }
            if let task = downloadTasks.first(where: { $0.state == .suspended }) {
                print("   A download task was suspend, resume")
                task.resume()
                return
            }
            
            guard let strongSelf = self else { return }
            // To use Alamofire with background downloads, you currently need to not use the response closures and override the SessionDelegate closures.
            if let url = URL(string: url) {
                let downloadTask = session.downloadTask(with: url)
                downloadTask.resume()
                print("START OK: \(url)")
            } else {
                print("START FAIL: \(url)")
                strongSelf.cancel()
            }
        })
    }
    
    // MARK: - Downloaded
    func downloaded(url: String, success: Bool, location: URL?, backgroundTask: UIBackgroundTaskIdentifier?) {
        let realm = RealmUtilities.getRealmInstanse()
        guard let location = location else { return }
        guard let motelRealm = realm.object(ofType: MotelRealm.self, forPrimaryKey: motelDownload.motel_Id) else { return }
        
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileExtension: String = url.components(separatedBy: ".").last ?? ""
        
        let arrImgDownloaded = imgDownloaded.filter { (key, value) -> Bool in
            return value == url
        }
        var saveFileSuccess = true
        RealmUtilities.updateRealmObject { (realm) in
            if success {
                arrImgDownloaded.forEach { (key, value) in
                    let name = "\(key).\(fileExtension)"
                    let destinationURL = documentsURL.appendingPathComponent(name)
                    
                    do {
                        if FileManager.default.fileExists(atPath: destinationURL.path) {
                            try FileManager.default.removeItem(at: destinationURL)
                        }
                        let directory = destinationURL.deletingLastPathComponent()
                        try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
                        try FileManager.default.copyItem(at: location, to: destinationURL)
                    } catch (let err) {
                        print(err.localizedDescription)
                        saveFileSuccess = false
                        return
                    }
                    let imgName = RealmString()
                    imgName.stringValue = name
                    motelRealm.arrImage.append(imgName)
                }
            }
        }
        // Delete temp file
        do {
            if FileManager.default.fileExists(atPath: location.path) {
                try FileManager.default.removeItem(at: location)
            }
        } catch {
            print("Can not delete temp file, url \(url), error: \(error.localizedDescription)")
        }
        
        if success && saveFileSuccess {
            cancel()
        } else {
            downloadFile(identifier: identifier, url: url)
        }
        
        Utilities.shared.endBackgroundTask(backgroundTask)
    }
}

// MARK: - URLSession Download Delegate
extension DownloadSession: URLSessionDownloadDelegate {
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        guard let error = error else { return }
        print(error.localizedDescription)
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        let task = Utilities.shared.beginBackgroundTask()
        guard let requestURL = downloadTask.originalRequest?.url?.absoluteString else {
            return
        }
        
        if let httpResponse = downloadTask.response as? HTTPURLResponse
            , httpResponse.statusCode == 200 {
            downloaded(url: requestURL, success: true, location: location, backgroundTask: task)
        } else {
            downloaded(url: requestURL, success: false, location: location, backgroundTask: task)
        }
    }
}
