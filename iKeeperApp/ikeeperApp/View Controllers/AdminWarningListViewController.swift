//
//  AdminWarningListViewController.swift
//  ikeeperApp
//
//  Created by 김혜진 on 2021/02/05.
//

import UIKit
import Firebase

class AdminWarningListViewController: UIViewController {

    @IBOutlet weak var warningListTableView: UITableView!
    let statusLabel = UILabel(frame: CGRect(x: 0, y: 100, width: 414, height: 40))
    var dataList = [[String: Any]]()
    var numbering = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        warningListTableView.delegate = self
        warningListTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        dataList = [[String: Any]]()
        numbering = 1
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
                    } else {
                        self.getWarningList()
                    }
                }
            }
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func getWarningList() {
        statusLabel.removeFromSuperview()
        
        let db = Firestore.firestore()
        db.collection("warningList").order(by: "created", descending: true).getDocuments { (snapshot, error) in
            if error != nil {
                print("check for error : \(error!.localizedDescription)")
            } else {
                if snapshot?.isEmpty == false {
                    for document in snapshot!.documents {
                        let documentData = document.data()
                        self.dataList.append(documentData)
                    }
                } else {
                    self.statusLabel.textAlignment = .center
                    self.statusLabel.text = "경고 내역이 없습니다."
                    self.view.addSubview(self.statusLabel)
                }
                self.warningListTableView.reloadData()
            }
        }
    }
}

extension AdminWarningListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // cell은 as 키워드로 앞서 만든 AdminWarningListCustomCell 클래스화
        let cell = tableView.dequeueReusableCell(withIdentifier: "AdminWarningListCustomCell", for: indexPath) as! AdminWarningListCustomCell

        // cell에 데이터 삽입
        let data = dataList[indexPath.row]
        cell.numLabel?.text = String(numbering)
        numbering += 1
        cell.userNameLabel?.text = data["userName"] as? String
        cell.departmentLabel?.text = data["department"] as? String
        cell.gradeLabel?.text = data["grade"] as? String
        cell.dateLabel?.text = data["create date"] as? String
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let data = dataList[indexPath.row]
        let adminWarningDetailViewController = self.storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.adminWarningDetailViewController) as! AdminWarningDetailViewController
        adminWarningDetailViewController.data = data
        self.navigationController?.pushViewController(adminWarningDetailViewController, animated: true)
    }
    
}
