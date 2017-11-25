//
//  DetailHostelViewController.swift
//  NhaTro
//
//  Created by DUY on 9/24/17.
//  Copyright © 2017 HOANG HUNG. All rights reserved.
//

import UIKit

class DetailHostelViewController: UIViewController {
    @IBOutlet weak var tbvDetail: UITableView!
    
    fileprivate var colHeight:CGFloat = 0.0
    fileprivate var detailTextViewHeight:CGFloat = 0.0
    fileprivate var isReload = false
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = false
        setupNavigation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "Thông Tin"
        self.tabBarController?.tabBar.isHidden = true
        setupTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            guard let strongSelf = self else { return }
            if let cellHostel = strongSelf.tbvDetail.cellForRow(at: IndexPath(row: 3, section: 0)) as? DetailNearHostelCell, let cellDetail = strongSelf.tbvDetail.cellForRow(at: IndexPath(row: 1, section: 0)) as? DetailCell {
                var tbvHeigth = strongSelf.tbvDetail.contentSize.height
                // Setup height for collection view
                strongSelf.colHeight = cellHostel.cvwHostel.contentSize.height
                tbvHeigth += cellHostel.cvwHostel.contentSize.height
                
                //Setup height for textview cell
                strongSelf.detailTextViewHeight = cellDetail.txvDes.contentSize.height
                tbvHeigth += cellDetail.txvDes.contentSize.height
                cellDetail.txvDes.frame.size.height = strongSelf.detailTextViewHeight
                cellDetail.vwBoundsTextView.frame.size.height += cellDetail.txvDes.contentSize.height
                cellDetail.vwInfo.frame.size.height += cellDetail.vwBoundsTextView.frame.size.height
                strongSelf.tbvDetail.contentSize.height = tbvHeigth
                
                DispatchQueue.main.async {
                    strongSelf.isReload = true
                    strongSelf.view.layoutIfNeeded()
                    strongSelf.tbvDetail.reloadData()
                }
            }
        }
        
    }
    
    
    private func setupTableView() {
        tbvDetail.delegate = self
        tbvDetail.dataSource = self
        tbvDetail.separatorStyle = .none
    }

    private func setupNavigation() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "arrowLeftSimpleLineIcons"), style: .done, target: self, action: #selector(InfoViewController.dismissView))
    }
}
extension DetailHostelViewController:UITableViewDelegate,UITableViewDataSource{
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            if let header = tableView.dequeueReusableCell(withIdentifier: "HeaderImageCell", for: indexPath) as? HeaderImageCell {
                
                return header
            }
        case 1:
            if let detail = tableView.dequeueReusableCell(withIdentifier: "DetailCell", for: indexPath) as? DetailCell {

                return detail
            }
        case 2:
            if let ImageDetailCell = tableView.dequeueReusableCell(withIdentifier: "ImageDetailCell", for: indexPath) as? ImageDetailCell {

                return ImageDetailCell
            }
        default:
            let detailNearHostelCell = tableView.dequeueReusableCell(ofType: DetailNearHostelCell.self, at: indexPath)
            
            return detailNearHostelCell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if !isReload {
            return 0
        }
        switch indexPath.row {
        case 0:
            return 181
        case 1:
            return 600
        case 2:
            return 130            
        case 3:
            return colHeight + 65
        default:
            return 0
        }
    }
}
