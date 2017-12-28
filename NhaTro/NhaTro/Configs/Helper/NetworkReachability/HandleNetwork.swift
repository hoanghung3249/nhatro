//
//  HandleNetwork.swift
//  NhaTro
//
//  Created by HOANGHUNG on 12/27/17.
//  Copyright © 2017 HOANG HUNG. All rights reserved.
//

import Foundation

class HandleNetwork {
    
    // MARK - Variables
    let reachability = Reachability()!
    var networkChange:((_ hasConnection: Bool)->())?
    
    init() {
        setupReachability()
        guard let networkChange = networkChange else { return }
        reachability.whenReachable = { (reach) in
            networkChange(true)
        }
        
        reachability.whenUnreachable = { (_) in
            networkChange(false)
        }
    }
    
    func setupReachability() {
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(_:)), name: .reachabilityChanged, object: reachability)
        do{
            try reachability.startNotifier()
        }catch{
            print("could not start reachability notifier")
        }
    }
    
    @objc func reachabilityChanged(_ noti: Notification) {
        guard let reachInternet = noti.object as? Reachability else { return }
        guard let networkChange = networkChange else { return }
        reachInternet.whenReachable = { (reach) in
            if reach.connection == .wifi || reach.connection == .cellular {
                networkChange(true)
            }
        }
        
        reachInternet.whenUnreachable = { (reach) in
            networkChange(false)
        }
    }
    
    func stopNotifier() {
        reachability.stopNotifier()
        NotificationCenter.default.removeObserver(self, name: .reachabilityChanged, object: reachability)
    }
    
}
