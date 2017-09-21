//
//  MapViewController.swift
//  NhaTro
//
//  Created by DUY on 9/21/17.
//  Copyright © 2017 HOANG HUNG. All rights reserved.
//

import UIKit

class MapViewController: UIViewController,UISearchBarDelegate {
    lazy var searchBar:UISearchBar = UISearchBar()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchBar()
        tabBarController?.tabBar.isHidden = true
        navigationController?.navigationBar.tintColor = .white
        navigationItem.backBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "arrowLeftSimpleLineIcons"), style: .plain, target: nil, action: nil)


        // Do any additional setup after loading the view.
    }

    
    private func setupSearchBar() {
        searchBar.searchBarStyle = UISearchBarStyle.prominent
        searchBar.placeholder = "Search"
        searchBar.sizeToFit()
        searchBar.isTranslucent = false
        searchBar.delegate = self
        navigationItem.titleView = searchBar
    }


}
