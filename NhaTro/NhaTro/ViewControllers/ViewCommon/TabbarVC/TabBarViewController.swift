//
//  TabBarViewController.swift
//  NhaTro
//
//  Created by DUY on 9/17/17.
//  Copyright © 2017 HOANG HUNG. All rights reserved.
//

import UIKit
//import AsyncDisplayKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.barTintColor = Color.mainColor()
        self.setupViewController()
        self.delegate = self
    }
    
    private func setupViewController() {
        let homePageVC = Storyboard.home.instantiateViewController(ofType: HomePageViewController.self)
        let naviPageVC = NhaTroNavigationVC(rootViewController: homePageVC)
        naviPageVC.tabBarItem = UITabBarItem(title: "Trang Chủ", image: UIImage(named: "home"), selectedImage: UIImage(named: "homeSelected"))
        naviPageVC.setupTitle("Trang Chủ")
        
        let likeVC = Storyboard.home.instantiateViewController(ofType: FavoriteViewController.self)
        let naviLikeVC = NhaTroNavigationVC(rootViewController: likeVC)
        naviLikeVC.tabBarItem = UITabBarItem(title: "Yêu Thích", image: UIImage(named: "heart"), selectedImage: UIImage(named:"likeSelected"))
        naviLikeVC.setupTitle("Yêu Thích")
        
        let postVC = Storyboard.home.instantiateViewController(ofType: PostViewController.self)
        let naviPostVC = NhaTroNavigationVC(rootViewController: postVC)
        naviPostVC.tabBarItem = UITabBarItem(title: "Đăng Tin", image: UIImage(named: "plus"), selectedImage: UIImage(named:"postSeledted"))
        naviPostVC.setupTitle("Đăng Tin")
        
        let menuVC = Storyboard.home.instantiateViewController(ofType: MenuViewController.self)
        let naviMenuVC = NhaTroNavigationVC(rootViewController: menuVC)
        naviMenuVC.tabBarItem = UITabBarItem(title: "Menu", image: UIImage(named: "menu"), selectedImage: UIImage(named:"menu_selected"))
        naviMenuVC.setupTitle("Menu")
        
        self.viewControllers = [naviPageVC, naviLikeVC , naviPostVC, naviMenuVC]
        self.selectedViewController = naviPageVC
    }
    
}

// MARK: - Extension TabbarController Delegate
extension TabBarViewController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        self.tabBar.isHidden = false
    }
    
}
