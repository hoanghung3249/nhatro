//
//  DownloadSession.swift
//  NhaTro
//
//  Created by HOANGHUNG on 12/22/17.
//  Copyright © 2017 HOANG HUNG. All rights reserved.
//

import Foundation

class DownloadSession: NSObject {
    
    private var session: URLSession?
    let motelDownload: Motel
    
    // MARK: - Singleton
    /* init */
    init(with file: Motel) {
        motelDownload = file
        super.init()
    }
    
    private func getSession() -> URLSession {
        if session == nil {
            let configuration = URLSessionConfiguration.background(withIdentifier: "downloadFavoritePost")
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
    
    func downloadFile() {
        let session = getSession()
        
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
            if let url = URL(string: "") {
                let downloadTask = session.downloadTask(with: url)
                downloadTask.resume()
                print("START OK: ")
            } else {
                print("START FAIL: ")
                strongSelf.cancel()
            }
        })
    }
}

// MARK: - URLSession Download Delegate
extension DownloadSession: URLSessionDownloadDelegate {
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        
    }
    
}
