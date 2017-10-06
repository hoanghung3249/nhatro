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
    
    fileprivate let arrTitle:[String] = ["Thông tin", "Phòng trọ", "Lịch sử", "Đăng xuất"]
    fileprivate let arrImgIcon:[String] = ["user", "home-1", "history", "logout"]
    
    //MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "Menu"
        self.tabBarController?.tabBar.isHidden = false
    }

    
    //MARK:- Support functions
    
    private func setupTableView() {
        self.tbvMenu.delegate = self
        self.tbvMenu.dataSource = self
        self.tbvMenu.register(UINib(nibName: "MenuCell", bundle: nil), forCellReuseIdentifier: "MenuCell")
        self.tbvMenu.separatorStyle = .none
    }
    
    fileprivate func showInfoVC() {
        let infoVC = Storyboard.home.instantiateViewController(withIdentifier: "InfoViewController") as! InfoViewController
        self.tabBarController?.tabBar.isHidden = true
        self.navigationItem.title = ""
        self.navigationController?.pushViewController(infoVC, animated: true)
    }
    
    

}


//MARK:- Tableview Delegate & Datasource
extension MenuViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrTitle.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath) as! MenuCell
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
        case 3:
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
        guard let user = USER else { return }
        ProgressView.shared.show((self.parent?.view)!)
        
        NetworkService.requestWithHeader(.get, user.token, url: Constant.APIKey.logOut, parameters: nil) { [weak self] (data, error, code) in
            guard let strongSelf = self else { return }
            ProgressView.shared.hide()
            if error != nil {
                if let code = code {
                    if code == StatusCode.success {
                        USER?.logOut()
                        URLCache.shared.removeAllCachedResponses()
                        URLCache.shared.diskCapacity = 0
                        URLCache.shared.memoryCapacity = 0
                        let loginVC = Storyboard.main.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                        DispatchQueue.main.async {
                            strongSelf.present(loginVC, animated: true, completion: nil)
                        }
                    } else {
                        strongSelf.showAlert(with: error!)
                    }
                }
            }
        }
    }
    
}




