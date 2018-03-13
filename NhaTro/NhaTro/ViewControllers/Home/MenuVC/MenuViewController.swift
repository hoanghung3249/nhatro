//
//  MenuViewController.swift
//  NhaTro
//
//  Created by HOANGHUNG on 9/25/17.
//  Copyright © 2017 HOANG HUNG. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    @IBOutlet weak var tbvMenu: UITableView!
    
    fileprivate let arrTitle:[String] = ["Thông tin", "Phòng trọ", "Bài đăng", "Bảo mật" ,"Đăng xuất"]
    fileprivate let arrImgIcon:[String] = ["user", "home-1", "history","lock","logout"]
    
    //MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "Menu"
        self.tabBarController?.tabBar.isHidden = false
        self.setupTableView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = ""
    }
    
    //MARK:- Support functions
    private func setupTableView() {
        self.tbvMenu.delegate = self
        self.tbvMenu.dataSource = self
        self.tbvMenu.register(UINib(nibName: "MenuCell", bundle: nil), forCellReuseIdentifier: "MenuCell")
        self.tbvMenu.separatorStyle = .none
    }
    
    fileprivate func showInfoVC() {
        let infoVC = Storyboard.home.instantiateViewController(ofType: InfoViewController.self)
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.pushViewController(infoVC, animated: true)
    }
    
    fileprivate func showChangePassVC() {
        let changePassVC = Storyboard.home.instantiateViewController(ofType: ChangePassViewController.self)
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.pushViewController(changePassVC, animated: true)
    }
    
    fileprivate func showMotelRoomVC() {
        let motelRoomVC = Storyboard.home.instantiateViewController(ofType: MotelRoomViewController.self)
        self.tabBarController?.tabBar.isHidden = true
        navigationController?.pushViewController(motelRoomVC, animated: true)
    }
    
    fileprivate func showPostedMotelVC() {
        let postedVC = Storyboard.home.instantiateViewController(ofType: PostedMotelViewController.self)
        self.tabBarController?.tabBar.isHidden = true
        navigationController?.pushViewController(postedVC, animated: true)
    }
    
}

//MARK:- Tableview Delegate & Datasource
extension MenuViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrTitle.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(ofType: MenuCell.self, at: indexPath)
        cell.selectionStyle = .none
        let title = self.arrTitle[indexPath.row]
        let icon = self.arrImgIcon[indexPath.row]
        cell.setupMenuCell(title, icon)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch (indexPath.row) {
        case 0:
            self.showInfoVC()
            break
        case 1:
            self.showMotelRoomVC()
            break
        case 2:
            self.showPostedMotelVC()
            break
        case 3:
            self.showChangePassVC()
            break
        case 4:
            self.callAPILogOut()
            break
        default:
            print("test")
        }
    }
    
}

//MARK:- Support API
extension MenuViewController {
    
    fileprivate func callAPILogOut() {
        ProgressView.shared.show((self.parent?.view)!)
        DataCenter.shared.callAPILogOut { [weak self] (success, err) in
            guard let `self` = self else { return }
            ProgressView.shared.hide()
            if success {
                USER?.logOut()
                guard let loginVC = Storyboard.main.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController else { return }
                DispatchQueue.main.async {
                    self.present(loginVC, animated: true, completion: nil)
                }
            } else {
                guard let err = err else { return }
                self.showAlert(with: err)
            }
        }
    }
}
