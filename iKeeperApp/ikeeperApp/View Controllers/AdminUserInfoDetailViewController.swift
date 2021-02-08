//
//  AdminUserInfoDetailViewController.swift
//  ikeeperApp
//
//  Created by 김혜진 on 2021/02/04.
//

import UIKit
import Firebase

class AdminUserInfoDetailViewController: UIViewController {

    @IBOutlet weak var emailValue: UITextField!
    @IBOutlet weak var nameValue: UITextField!
    @IBOutlet weak var pwValue: UITextField!
    @IBOutlet weak var studentIDValue: UITextField!
    @IBOutlet weak var departmentValue: UITextField!
    @IBOutlet weak var gradeValue: UITextField!
    @IBOutlet weak var phoneNumberValue: UITextField!
    @IBOutlet weak var permissionValue: UITextField!
    @IBOutlet weak var warningValue: UITextField!
    @IBOutlet weak var partControl: UISegmentedControl!
    @IBOutlet weak var statusControl: UISegmentedControl!
    @IBOutlet weak var editBarButton: UIBarButtonItem!
    @IBOutlet weak var completeButton: UIButton!
    var dataList = [String: Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
     
        completeButton.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setUser()
        print(dataList)
        print(dataList["id"] as! String)
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
                        self.setValue()
                        self.setDisabled()
                    }
                }
            }
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }

    func setValue() {
        self.emailValue.text = dataList["email"] as? String
        self.nameValue.text = dataList["name"] as? String
        self.pwValue.text = dataList["password"] as? String
        self.studentIDValue.text = dataList["studentID"] as? String
        self.departmentValue.text = dataList["department"] as? String
        self.gradeValue.text = dataList["grade"] as? String
        self.phoneNumberValue.text = dataList["phoneNumber"] as? String
        
        let userUid: String = dataList["uid"] as! String
        let db = Firestore.firestore()
        db.collection("warningList").whereField("userUid", isEqualTo: userUid).getDocuments { (snapshot, error) in
            if error != nil {
                print("check for error : \(error!.localizedDescription)")
            } else {
                if snapshot?.isEmpty == false {
                    self.warningValue.text = String(snapshot!.count)
                } else {
                    self.warningValue.text = "0"
                }
            }
        }
        
        if dataList["part"] as! String == "개발" {
            self.partControl.selectedSegmentIndex = 0
        } else {
            self.partControl.selectedSegmentIndex = 1
        }
        if dataList["status"] as! String == "재학" {
            self.statusControl.selectedSegmentIndex = 0
        } else {
            self.statusControl.selectedSegmentIndex = 1
        }
        if dataList["permission"] as! Bool == true {
            self.permissionValue.text = "관리자"
        } else {
            self.permissionValue.text = "회원"
        }
    }
    
    func setEnabled() {
        partControl.isEnabled = true
        statusControl.isEnabled = true
    }
    
    func setDisabled() {
        emailValue.isEnabled = false
        nameValue.isEnabled = false
        pwValue.isEnabled = false
        studentIDValue.isEnabled = false
        departmentValue.isEnabled = false
        gradeValue.isEnabled = false
        phoneNumberValue.isEnabled = false
        permissionValue.isEnabled = false
        warningValue.isEnabled = false
        partControl.isEnabled = false
        statusControl.isEnabled = false
    }
    
    @IBAction func editBarButton(_ sender: UIBarButtonItem) {
        editBarButton.image = nil
        editBarButton.isEnabled = false
        completeButton.isHidden = false
        setEnabled()
    }
    
    @IBAction func completeButton(_sender: UIBarButtonItem) {
        var part: String = ""
        var status: String = ""
        
        if partControl.selectedSegmentIndex == 0 {
            part = "개발"
        } else {
            part = "보안"
        }
        if statusControl.selectedSegmentIndex == 0 {
            status = "재학"
        } else {
            status = "휴학"
        }
        let modifyData = ["part": part, "status": status]
        let id: String = dataList["id"] as! String
        print(id, modifyData)
        
        let db = Firestore.firestore()
        db.collection("users").document("\(id)").updateData(modifyData) { (error) in
            if error != nil {
                print("check for error : \(error!.localizedDescription)")
            } else {
                self.showAlertForUserInfoModify()
            }
        }
        
        editBarButton.image = UIImage(systemName: "pencil.slash")
        editBarButton.isEnabled = true
        completeButton.isHidden = true
        setDisabled()
    }
    
    func showAlertForUserInfoModify() {
        let alert = UIAlertController(title: "수정 완료",
                                      message: "회원정보가 수정되었습니다",
                                      preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default) { (action) in
            self.navigationController?.popViewController(animated: true)
        }
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
}
