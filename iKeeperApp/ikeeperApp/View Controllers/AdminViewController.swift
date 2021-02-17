//
//  AdminViewController.swift
//  ikeeperApp
//
//  Created by 김혜진 on 2021/02/03.
//

import UIKit
import Firebase

class AdminViewController: UIViewController {

    @IBOutlet weak var functionTableView: UITableView!
    let tableViewTitle = ["회원", "게시판"]
    let tableViewList1 = ["회원 목록","경고 내역"]
    let tableViewList2 = ["정보게시판 관리", "일정 관리", "공금내역 관리"]
    let space = [" ", " "]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        functionTableView.delegate = self
        functionTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setUser()
    }
    
    func setUser(){
        let user = Auth.auth().currentUser
        if user != nil {
            let uid: String = user!.uid
            let db = Firestore.firestore()
            db.collection("users").whereField("uid", isEqualTo: uid).whereField("permission", isEqualTo: true).getDocuments { (snapshot, error) in
                if error != nil {
                    print("check for error : \(error!.localizedDescription)")
                } else {
                    if snapshot?.isEmpty == true {
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
}

extension AdminViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableViewTitle.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return tableViewList1.count
        } else {
            return tableViewList2.count
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return tableViewTitle[section]
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // cell은 as 키워드로 앞서 만든 AdminCustomCell 클래스화
        let cell = tableView.dequeueReusableCell(withIdentifier: "AdminCustomCell", for: indexPath) as! AdminCustomCell

        // cell에 데이터 삽입
        if indexPath.section == 0 {
            cell.functionLabel?.text = tableViewList1[indexPath.row]
        } else {
            cell.functionLabel?.text = tableViewList2[indexPath.row]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return space[section]
    }
    
    func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        view.tintColor = .clear
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let adminUserListViewController = self.storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.adminUserListViewController) as! AdminUserListViewController
                self.navigationController?.pushViewController(adminUserListViewController, animated: true)
            } else if indexPath.row == 1 {
                let adminWarningListViewController = self.storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.adminWarningListViewController) as! AdminWarningListViewController
                self.navigationController?.pushViewController(adminWarningListViewController, animated: true)
            }
        } else if indexPath.section == 1{
            if indexPath.row == 0 {
                let informationViewController = self.storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.informationViewController) as! InformationViewController
                self.navigationController?.pushViewController(informationViewController, animated: true)
            } else if indexPath.row == 1{
                let calendarViewController = self.storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.calendarViewController) as! CalendarViewController
                self.navigationController?.pushViewController(calendarViewController, animated: true)
            } else if indexPath.row == 2 {
                let publicMoneyViewController = self.storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.publicMoneyViewController) as! PublicMoneyViewController
                self.navigationController?.pushViewController(publicMoneyViewController, animated: true)
            }
        }
    }
}
