//
//  TabBarViewController.swift
//  NhaTro
//
//  Created by DUY on 9/17/17.
//  Copyright © 2017 HOANG HUNG. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class TabBarViewController: ASTabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.barTintColor = Color.mainColor()
        self.setupViewController()
        // Do any additional setup after loading the view.
    }
    
    
    private func setupViewController() {
        let homePageVC = Storyboard.home.instantiateViewController(withIdentifier: "HomePageViewController") as! HomePageViewController
        let naviPageVC = UINavigationController(rootViewController: homePageVC)
        naviPageVC.tabBarItem = UITabBarItem(title: "Trang Chủ", image: UIImage(named: "home"), selectedImage: UIImage(named: "homeSelected"))
        
        
        let likeVC = Storyboard.home.instantiateViewController(withIdentifier: "FavoriteViewController") as! FavoriteViewController
        let naviLikeVC = UINavigationController(rootViewController: likeVC)
        naviLikeVC.tabBarItem = UITabBarItem(title: "Yêu Thích", image: UIImage(named: "heart"), selectedImage: UIImage(named:"likeSelected"))
        
        let postVC = Storyboard.home.instantiateViewController(withIdentifier: "PostViewController") as! PostViewController
        let naviPostVC = UINavigationController(rootViewController: postVC)
        naviPostVC.tabBarItem = UITabBarItem(title: "Đăng Tin", image: UIImage(named: "plus"), selectedImage: UIImage(named:"postSeledted"))
        
        let infoVC = Storyboard.home.instantiateViewController(withIdentifier: "InfoViewController") as! InfoViewController
        let naviInfoVC = UINavigationController(rootViewController: infoVC)
        naviInfoVC.tabBarItem = UITabBarItem(title: "Thông Tin", image: UIImage(named: "avatar"), selectedImage: UIImage(named:"infoSelected"))
        
        self.viewControllers = [naviPageVC, naviLikeVC , naviPostVC, naviInfoVC]
        self.selectedViewController = naviPageVC
        
    }


}
