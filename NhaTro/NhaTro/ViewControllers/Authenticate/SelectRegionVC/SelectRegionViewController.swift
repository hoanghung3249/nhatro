//
//  SelectRegionViewController.swift
//  NhaTro
//
//  Created by HOANGHUNG on 3/9/18.
//  Copyright © 2018 HOANG HUNG. All rights reserved.
//

import UIKit

protocol SelectRegionDelegate: class {
    func callGMSPlacse()
}

class SelectRegionViewController: UIViewController {
    
    // MARK: - Outlets and Variables
    @IBOutlet weak var tbvRegion: UITableView!
    fileprivate let arrRegion = ["Miền Bắc", "Miền Trung", "Miền Nam"]
    var isLoginView = true
    weak var delegate: SelectRegionDelegate?
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("end view")
    }
    
    // MARK: - Support functions
    private func setupTableView() {
        tbvRegion.dataSource = self
        tbvRegion.delegate = self
    }

}

// MARK: - Tableview Datasource and Delegate
extension SelectRegionViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrRegion.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RegionCell", for: indexPath)
        cell.textLabel?.text = arrRegion[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let region = arrRegion[indexPath.row]
        let regionVC = Storyboard.main.instantiateViewController(ofType: RegionViewController.self)
        regionVC.region = region
        regionVC.isLoginView = isLoginView
        regionVC.delegate = self
        navigationController?.pushViewController(regionVC, animated: true)
    }
}

// MARK: - RegionViewController Delegate
extension SelectRegionViewController: RegionVCDelegate {
    
    func dismissVC() {
        navigationController?.popViewController(animated: true)
    }
    
}
