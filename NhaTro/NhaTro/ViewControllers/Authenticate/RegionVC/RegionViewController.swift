//
//  RegionViewController.swift
//  NhaTro
//
//  Created by HOANGHUNG on 3/9/18.
//  Copyright © 2018 HOANG HUNG. All rights reserved.
//

import UIKit
import SwiftyJSON

class RegionViewController: UIViewController {

    // MARK: - Outlets and Variables
    
    @IBOutlet weak var tbvRegion: UITableView!
    var region: String = ""
    fileprivate var arrRegion: [String] = []
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupNavigation()
        loadRegion()
    }
    
    // MARK:- Support Functions
    private func setupTableView() {
        tbvRegion.dataSource = self
        tbvRegion.delegate = self
    }
    
    private func setupNavigation() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "arrowLeftSimpleLineIcons"), style: .done, target: self, action: #selector(RegionViewController.dismissView))
        self.navigationItem.title = region
        self.tabBarController?.tabBar.isHidden = true
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    private func loadRegion() {
        for r in Utilities.shared.getRegion(region) {
            arrRegion.append(r)
        }
        arrRegion = arrRegion.sorted()
        DispatchQueue.main.async {
            self.tbvRegion.reloadData()
        }
    }

    // MARK: - Action buttons
    @objc func dismissView() {
        navigationController?.popViewController(animated: true)
    }
    
}

// MARK: - TableView Datasource and Delegate
extension RegionViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrRegion.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RegionCell", for: indexPath)
        let r = arrRegion[indexPath.row]
        cell.textLabel?.text = r
        return cell
    }
    
}
