//
//  AdminUserListViewController.swift
//  ikeeperApp
//
//  Created by 김혜진 on 2021/02/04.
//

import UIKit
import Firebase

class AdminUserListViewController: UIViewController {

    @IBOutlet weak var deleteBarButton: UIBarButtonItem!
    @IBOutlet weak var userListTableView: UITableView!
    let statusLabel = UILabel(frame: CGRect(x: 0, y: 90, width: 414, height: 40))
    var dataList = [[String: Any]]()
    var numbering = 1
    var currentPW: String = ""
    
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
                        for document in snapshot!.documents {
                            let documentData = document.data()
                            self.currentPW = documentData["password"] as! String
                        }
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
    
    @IBAction func deleteBarButton(_ sender: UIBarButtonItem) {
        if userListTableView.isEditing {
            userListTableView.isEditing = false
            deleteBarButton.image = UIImage(systemName: "person.crop.circle.badge.minus")
            deleteBarButton.tintColor = .systemRed
        } else {
            userListTableView.isEditing = true
            deleteBarButton.image = UIImage(systemName: "checkmark.circle")
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let data = dataList[indexPath.row]
        let adminUserInfoDetailViewController = self.storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.adminUserInfoDetailViewController) as! AdminUserInfoDetailViewController
        adminUserInfoDetailViewController.dataList = data
        self.navigationController?.pushViewController(adminUserInfoDetailViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            let data = dataList[indexPath.row]
            let name = data["name"] as! String
            showAlertForUserDelete(name: name, indexpath: indexPath ,index: indexPath.row)
        }
    }
    
    func showAlertForUserDelete(name: String, indexpath: IndexPath, index: Int) {
        let alert = UIAlertController(title: "회원 강제 탈퇴",
                                      message: "\(name) 회원을 강제로 탈퇴시키겠습니까?",
                                      preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: "확인", style: .default) { (action) in
            self.showAlertForPasswordCheck(name: name, indexpath: indexpath, index: index)
        }
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func showAlertForPasswordCheck(name: String, indexpath: IndexPath, index: Int) {
        let alert = UIAlertController(title: "관리자 비밀번호 확인",
                                        message: "비밀번호를 입력하세요",
                                        preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: "확인", style: .default) { (action) in
            if let alertPW: String = alert.textFields?[0].text {
                if alertPW == self.currentPW {
                    self.deleteUser(name: name, indexpath: indexpath, index: index)
                } else {
                    self.showAlert(message: "비밀번호를 확인하세요")
                }
            }
        }
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        alert.addTextField { (pwValue) in
            pwValue.placeholder = "password"
            pwValue.isSecureTextEntry = true
        }
        self.present(alert, animated: true, completion: nil)
    }
    
    func deleteUser(name: String, indexpath: IndexPath, index: Int) {
        let documentID = dataList[index]["id"] as! String
        let db = Firestore.firestore()
        db.collection("users").document("\(documentID)").delete { (error) in
            if error != nil {
                print("check for error : \(error!.localizedDescription)")
            } else {
                self.numbering = 1
                self.dataList.remove(at: index)
                self.userListTableView.deleteRows(at: [indexpath], with: .automatic)
                if self.dataList.count == 0 {
                    self.statusLabel.textAlignment = .center
                    self.statusLabel.text = "회원이 없습니다."
                    self.view.addSubview(self.statusLabel)
                    self.userListTableView.isEditing = false
                    self.deleteBarButton.image = nil
                    self.deleteBarButton.isEnabled = false
                }
                self.userListTableView.reloadData()
                self.showAlertDeleteUser(name: name)
            }
        }
    }
    
    func showAlertDeleteUser(name: String) {
        let alert = UIAlertController(title: "회원탈퇴 완료",
                                      message: "\(name)님의 회원탈퇴가 완료되었습니다.",
                                      preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "알림",
                                      message: message,
                                      preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
}
