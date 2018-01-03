//
//  DetailHostelViewController.swift
//  NhaTro
//
//  Created by DUY on 9/24/17.
//  Copyright © 2017 HOANG HUNG. All rights reserved.
//

import UIKit
import AXPhotoViewer

class DetailHostelViewController: UIViewController {
    
    // MARK: - Outlets and Variables
    @IBOutlet weak var tbvDetail: UITableView!
    fileprivate var colHeight:CGFloat = 0.0
    fileprivate var detailTextViewHeight:CGFloat = 0.0
    fileprivate var isReload = false
    var motel:Motel?
    
    var arrImg = [PhotoProtocol]()
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = false
        setupNavigation()
        setupTableView()
        setupUI()
        setupArrImg()
    }
    
    // MARK: - Support functions
    
    private func setupTableView() {
        tbvDetail.delegate = self
        tbvDetail.dataSource = self
        tbvDetail.separatorStyle = .none
    }
    
    private func setupArrImg() {
        guard let motel = motel else { return }
        if motel.images.count > 0 {
            for img in motel.images {
                let photo = Photo(attributedTitle: nil, attributedDescription: nil, attributedCredit: nil, imageData: nil, image: nil, url: URL(string: "\(Constant.APIKey.baseUrl)\(img.sub_image)"))
                arrImg.append(photo)
            }
        }
    }

    private func setupNavigation() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "arrowLeftSimpleLineIcons"), style: .done, target: self, action: #selector(DetailHostelViewController.dismissView))
        self.navigationItem.title = "Thông Tin"
        self.tabBarController?.tabBar.isHidden = true
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    private func setupUI() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            guard let strongSelf = self else { return }
            if let cellHostel = strongSelf.tbvDetail.cellForRow(at: IndexPath(row: 3, section: 0)) as? DetailNearHostelCell, let cellDetail = strongSelf.tbvDetail.cellForRow(at: IndexPath(row: 1, section: 0)) as? DetailCell {
                var tbvHeigth = strongSelf.tbvDetail.contentSize.height
                // Setup height for collection view
                strongSelf.colHeight = cellHostel.cvwHostel.contentSize.height
                tbvHeigth += cellHostel.cvwHostel.contentSize.height
                
                //Setup height for textview cell
                strongSelf.detailTextViewHeight = cellDetail.txvDes.contentSize.height
                cellDetail.txvDes.frame.size.height = strongSelf.detailTextViewHeight //Expand textview
                
                cellDetail.vwBoundsTextView.frame.size.height += cellDetail.txvDes.contentSize.height //Expand view bound textview

                cellDetail.vwInfo.frame.size.height += cellDetail.vwBoundsTextView.frame.size.height // Expand view info
                cellDetail.vwContent.frame.size.height += cellDetail.vwInfo.frame.size.height //Expand view content
                tbvHeigth += cellDetail.vwContent.frame.size.height //Expand tableview height

                strongSelf.detailTextViewHeight = cellDetail.vwContent.frame.size.height //Set height for cell content 
                strongSelf.tbvDetail.contentSize.height = tbvHeigth
                
                DispatchQueue.main.async {
                    strongSelf.isReload = true
                    strongSelf.tbvDetail.reloadData()
                }
            }
        }
    }
    
    // MARK: - Action buttons
    @objc func dismissView() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - Tableview Datasource and Delegate
extension DetailHostelViewController:UITableViewDelegate,UITableViewDataSource{
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let motel = motel else { return UITableViewCell() }
        switch indexPath.row {
        case 0:
            let headerCell = tableView.dequeueReusableCell(ofType: HeaderImageCell.self, at: indexPath)
            headerCell.configHeaderCell(motel)
            headerCell.actionButton = { [weak self] (sender) in
                guard let strongSelf = self else { return }
                strongSelf.handleHeaderAction(headerCell, sender)
            }
            return headerCell
        case 1:
            let detailCell = tableView.dequeueReusableCell(ofType: DetailCell.self, at: indexPath)
            detailCell.contentView.layoutIfNeeded()
            detailCell.configDetailCell(motel)
            return detailCell
        case 2:
            let imageDetailCell = tableView.dequeueReusableCell(ofType: ImageDetailCell.self, at: indexPath)
            imageDetailCell.configImageDetailCell(motel)
            imageDetailCell.completionHandler = { [weak self] (index) in
                guard let strongSelf = self else { return }
                strongSelf.presentPhotoVC(index, arrImage: strongSelf.arrImg)
            }
            return imageDetailCell
        default:
            let detailNearHostelCell = tableView.dequeueReusableCell(ofType: DetailNearHostelCell.self, at: indexPath)
            return detailNearHostelCell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if !isReload {
            return 0
        }
        switch indexPath.row {
        case 0:
            return 181
        case 1:
            return detailTextViewHeight
        case 2:
            return 130            
        case 3:
            return colHeight + 65
        default:
            return 0
        }
    }
    
    private func presentPhotoVC(_ indexPath:IndexPath, arrImage:[PhotoProtocol]) {
        let dataSource = PhotosDataSource(photos: arrImage, initialPhotoIndex: indexPath.row)
        let photosViewController = PhotosViewController(dataSource: dataSource)
        photosViewController.view.backgroundColor = .clear
        photosViewController.overlayView.topStackContainer.backgroundColor = Color.mainColor(with: 1.0)
        photosViewController.overlayView.backgroundColor = .clear
        photosViewController.overlayView.toolbar.clipsToBounds = true
        photosViewController.overlayView.toolbar.layer.shadowOpacity = 0
//        photosViewController.overlayView.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "arrowLeftSimpleLineIcons"), style: .done, target: nil, action: nil)
        photosViewController.overlayView.rightBarButtonItem? = UIBarButtonItem(title: nil, style: .done, target: nil, action: nil)
        DispatchQueue.main.async {
            self.pushTo(photosViewController)
        }
    }
    
    private func handleHeaderAction(_ cell: HeaderImageCell, _ sender: UIButton) {
        if sender == cell.btnLike {
            print("like")
        } else {
            print("share")
        }
    }
}
