//
//  MypageWarningListViewController.swift
//  ikeeperApp
//
//  Created by 김혜진 on 2021/01/27.
//

import UIKit
import Firebase

class MypageWarningListViewController: UIViewController {

    @IBOutlet weak var editBarButton: UIBarButtonItem!
    @IBOutlet weak var warningListTableView: UITableView!
    let statusLabel = UILabel(frame: CGRect(x: 0, y: 100, width: 414, height: 40))
    var dataList = [[String: Any]]()
    var numbering: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        warningListTableView.delegate = self
        warningListTableView.dataSource = self
        warningListTableView.allowsSelection = false
    }
    

    override func viewWillAppear(_ animated: Bool) {
        dataList = [[String:Any]]()
        numbering = 1
        setUser()
    }
    
    func setUser() {
        let user = Auth.auth().currentUser
        if user != nil {
            getList()
        } else {
            editBarButton.image = nil
            editBarButton.isEnabled = false
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func getList() {
        statusLabel.removeFromSuperview()
        
        let user = Auth.auth().currentUser
        let uid: String = user!.uid
        let db = Firestore.firestore()
        db.collection("warningList").whereField("userUid", isEqualTo: uid).order(by: "created", descending: true).getDocuments { (snapshot, error) in
            if error != nil {
                print("check for error : \(error!.localizedDescription)")
            } else {
                if snapshot?.isEmpty == false {
                    for document in snapshot!.documents {
                        let documentData = document.data()
                        self.dataList.append(documentData)
                    }
                    print(self.dataList)
                    self.editBarButton.image = UIImage(systemName: "pencil.slash")
                    self.editBarButton.isEnabled = true
                } else {
                    self.statusLabel.textAlignment = .center
                    self.statusLabel.text = "경고받은 내역이 없습니다."
                    self.view.addSubview(self.statusLabel)
                    self.editBarButton.image = nil
                    self.editBarButton.isEnabled = false
                }
                self.warningListTableView.reloadData()
            }
        }
    }
    
    @IBAction func editBarButton(_ sender: UIBarButtonItem) {
        if warningListTableView.isEditing {
            warningListTableView.isEditing = false
            editBarButton.image = UIImage(systemName: "pencil.slash")
        } else {
            warningListTableView.isEditing = true
            editBarButton.image = UIImage(systemName: "checkmark.circle")
        }
    }
}

extension MypageWarningListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // cell은 as 키워드로 앞서 만든 MypageWarningListCustomCell 클래스화
        let cell = tableView.dequeueReusableCell(withIdentifier: "MypageWarningListCustomCell", for: indexPath) as! MypageWarningListCustomCell

        // cell에 데이터 삽입
        let data = dataList[indexPath.row]
        cell.numLabel?.text = String(numbering)
        numbering += 1
        cell.createDateLabel?.text = data["create date"] as? String
        cell.reasonLabel?.text = data["reason"] as? String
        return cell
    }
    
    
}
