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
        let naviPageVC = NhaTroNavigationVC(rootViewController: homePageVC)
        naviPageVC.tabBarItem = UITabBarItem(title: "Trang Chủ", image: UIImage(named: "home"), selectedImage: UIImage(named: "homeSelected"))
        naviPageVC.setupTitle("Home")
        
        
        let likeVC = Storyboard.home.instantiateViewController(withIdentifier: "FavoriteViewController") as! FavoriteViewController
        let naviLikeVC = NhaTroNavigationVC(rootViewController: likeVC)
        naviLikeVC.tabBarItem = UITabBarItem(title: "Yêu Thích", image: UIImage(named: "heart"), selectedImage: UIImage(named:"likeSelected"))
        naviLikeVC.setupTitle("Yêu Thích")
        
        let postVC = Storyboard.home.instantiateViewController(withIdentifier: "PostViewController") as! PostViewController
        let naviPostVC = NhaTroNavigationVC(rootViewController: postVC)
        naviPostVC.tabBarItem = UITabBarItem(title: "Đăng Tin", image: UIImage(named: "plus"), selectedImage: UIImage(named:"postSeledted"))
        naviPostVC.setupTitle("Đăng Tin")
        
        let menuVC = Storyboard.home.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
        let naviMenuVC = NhaTroNavigationVC(rootViewController: menuVC)
        naviMenuVC.tabBarItem = UITabBarItem(title: "Menu", image: UIImage(named: "menu"), selectedImage: UIImage(named:"menu_selected"))
        naviMenuVC.setupTitle("Menu")
        
        self.viewControllers = [naviPageVC, naviLikeVC , naviPostVC, naviMenuVC]
        self.selectedViewController = naviPageVC
        
    }


}
