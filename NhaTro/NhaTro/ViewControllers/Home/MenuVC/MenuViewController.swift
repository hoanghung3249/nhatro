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
    
    fileprivate var arrTitle:[String] = ["Thông tin", "Phòng trọ", "Lịch sử", "Đăng xuất"]
    fileprivate var arrImgIcon:[String] = ["user", "home-1", "history", "logout"]
    
    //MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setupTableView()
    }
    
    
    //MARK:- Support functions
    
    private func setupTableView() {
        self.tbvMenu.delegate = self
        self.tbvMenu.dataSource = self
        self.tbvMenu.register(UINib(nibName: "MenuCell", bundle: nil), forCellReuseIdentifier: "MenuCell")
        self.tbvMenu.separatorStyle = .none
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
        case 3:
            let loginVC = Storyboard.main.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            self.present(loginVC, animated: true, completion: nil)
            break
        default:
            print("test")
        }
    }
    
    
}
