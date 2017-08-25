//
//  ProgressView.swift
//  Data Entry
//
//  Created by HOANGHUNG on 8/25/17.
//  Copyright © 2017 Apps Cyclone. All rights reserved.
//

import Foundation
import NVActivityIndicatorView

class ProgressView{
    
    static let shared = ProgressView()
    var indicator = NVActivityIndicatorView(frame: CGRect(x: 0,y: 0,width: 60,height: 60))
    var containerView = UIView()
    
    func show(_ view: UIView){
        
        containerView.frame = view.frame
        containerView.center = view.center
        containerView.backgroundColor = UIColor(hex: 0x000000, alpha: 0.4)
//        containerView.backgroundColor = UIColor.clear
        
        indicator.type = .ballScaleMultiple
//        indicator.color = UIColor(red: 29.0/255.0, green: 79.0/255.0, blue: 131.0/255.0, alpha: 1)
        indicator.color = UIColor.white
        indicator.center = CGPoint(x: view.bounds.width/2,y: view.bounds.height/2)
        indicator.startAnimating()
        containerView.addSubview(indicator)
        
        view.addSubview(containerView)
    }
    
    func hide(){
        indicator.stopAnimating()
        containerView.removeFromSuperview()
    }
    
}

