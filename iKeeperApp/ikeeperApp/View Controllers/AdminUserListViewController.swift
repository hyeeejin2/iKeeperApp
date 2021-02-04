//
//  AdminUserListViewController.swift
//  ikeeperApp
//
//  Created by 김혜진 on 2021/02/04.
//

import UIKit
import Firebase

class AdminUserListViewController: UIViewController {

    @IBOutlet weak var userListTableView: UITableView!
    let statusLabel = UILabel(frame: CGRect(x: 0, y: 90, width: 414, height: 40))
    var dataList = [[String: Any]]()
    var numbering = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        userListTableView.delegate = self
        userListTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        dataList = [[String:Any]]()
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
                        self.getUserList()
                    }
                }
            }
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func getUserList() {
        statusLabel.removeFromSuperview()
        
        let db = Firestore.firestore()
        db.collection("users").getDocuments { (snapshot, error) in
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
                    self.statusLabel.text = "회원이 없습니다."
                    self.view.addSubview(self.statusLabel)
                }
                self.userListTableView.reloadData()
            }
        }
    }
}

extension AdminUserListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // cell은 as 키워드로 앞서 만든 AdminUserListCustomCell 클래스화
        let cell = tableView.dequeueReusableCell(withIdentifier: "AdminUserListCustomCell", for: indexPath) as! AdminUserListCustomCell

        // cell에 데이터 삽입
        let data = dataList[indexPath.row]
        cell.numLabel?.text = String(numbering)
        numbering += 1
        cell.nameLabel?.text = data["name"] as? String
        cell.studentIDLabel?.text = data["studentID"] as? String
        cell.departmentLabel?.text = data["department"] as? String
        cell.gradeLabel?.text = data["grade"] as? String
        return cell
    }
}
