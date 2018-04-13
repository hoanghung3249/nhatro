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
    fileprivate var arrRegion: [RegionVN] = []
    var isLoginView = true
    
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
        arrRegion = arrRegion.sorted(by: {$0.region < $1.region})
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
        cell.textLabel?.text = r.region
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let area = arrRegion[indexPath.row]
        switch region {
        case Region.bac.rawValue:
            UserDefaults.setValue(1, forKey: .region)
        case Region.trung.rawValue:
            UserDefaults.setValue(2, forKey: .region)
        case Region.nam.rawValue:
            UserDefaults.setValue(3, forKey: .region)
        default:
            UserDefaults.setValue(0, forKey: .region)
        }
        UserDefaults.setValue(true, forKey: .isRegionSelected)
        UserDefaults.setValue(area.region, forKey: .area)
        if isLoginView {
            let tabbar = TabBarViewController()
            present(tabbar, animated: true, completion: nil)
        } else {
            if let selectRegionVC = parent?.childViewControllers.filter({$0.isKind(of: SelectRegionViewController.self)}).first as? SelectRegionViewController {
                navigationController?.popViewControllerWithHandler {
                    selectRegionVC.delegate?.dismissVC(with: area.location)
                    selectRegionVC.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
}
