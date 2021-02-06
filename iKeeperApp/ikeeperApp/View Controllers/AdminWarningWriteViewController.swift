//
//  AdminWarningWriteViewController.swift
//  ikeeperApp
//
//  Created by 김혜진 on 2021/02/05.
//

import UIKit
import Firebase

class AdminWarningWriteViewController: UIViewController {

    @IBOutlet weak var userNameValue: UITextField!
    @IBOutlet weak var studentIDValue: UITextField!
    @IBOutlet weak var departmentValue: UITextField!
    @IBOutlet weak var gradeValue: UITextField!
    @IBOutlet weak var reasonValue: UITextField!
    @IBOutlet weak var createDateValue: UITextField!
    @IBOutlet weak var writerValue: UITextField!
    let userListPickerView: UIPickerView = UIPickerView()
    let noUserList = ["-- 회원 없음 --"]
    var dataList = [[String: Any]]()
    var userList: [String] = ["-- 선택 --"]
    var selectedUser: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        createPickerView()
        dismissPickerView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        dataList = [[String:Any]]()
        userList = ["-- 선택 --"]
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
                            self.writerValue.text = documentData["name"] as? String
                        }
                        self.setDisabled()
                        self.setDate()
                        self.getUserList()
                    }
                }
            }
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func setDisabled() {
        studentIDValue.isEnabled = false
        departmentValue.isEnabled = false
        gradeValue.isEnabled = false
        createDateValue.isEnabled = false
        writerValue.isEnabled = false
    }
    
    func setDate() {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd"
        let dateString = formatter.string(from: Date())
        self.createDateValue.text = "\(dateString)"
    }
    
    func getUserList() {
        let db = Firestore.firestore()
        db.collection("users").whereField("permission", isEqualTo: false).getDocuments { (snapshot, error) in
            if error != nil {
                print("check for error : \(error!.localizedDescription)")
            } else {
                if snapshot?.isEmpty == false {
                    for document in snapshot!.documents {
                        let documentData = document.data()
                        self.dataList.append(documentData)
                    }
                    for data in self.dataList {
                        let userName = data["name"] as! String
                        self.userList.append(userName)
                    }
                }
                print(self.dataList)
                print(self.userList)
                self.userListPickerView.reloadAllComponents()
                //self.userListPickerView.reloadComponent(<#T##component: Int##Int#>)()
            }
        }
    }
    
    func createPickerView() {
        userListPickerView.delegate = self
        userListPickerView.dataSource = self
        userNameValue.inputView = userListPickerView
    }
    
    func dismissPickerView() {
        let userNamePickerToolBar = UIToolbar()
        userNamePickerToolBar.sizeToFit()
        userNamePickerToolBar.isTranslucent = true
        
        let userNameBtnDone = UIBarButtonItem(title: "확인", style: .done, target: self, action: #selector(userNamePickerDone))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        
        userNamePickerToolBar.setItems([space, userNameBtnDone], animated: true)
        userNamePickerToolBar.isUserInteractionEnabled = true
        userNameValue.inputAccessoryView = userNamePickerToolBar
    }
    
    @objc func userNamePickerDone() {
        userNameValue.text = selectedUser
        selectedUser = ""
        self.view.endEditing(true)
    }
}

extension AdminWarningWriteViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if dataList.count == 0 {
            return noUserList.count
        } else {
            return userList.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if dataList.count == 0 {
            return noUserList[row]
        } else {
            return userList[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if dataList.count == 0 {
            selectedUser = ""
        } else {
            if row != 0 {
                selectedUser = userList[row]
            } else {
                selectedUser = ""
            }
        }
    }
}
