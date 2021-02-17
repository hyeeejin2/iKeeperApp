//
//  AdminWarningDetailViewController.swift
//  ikeeperApp
//
//  Created by 김혜진 on 2021/02/06.
//

import UIKit
import Firebase

class AdminWarningDetailViewController: UIViewController {

    @IBOutlet weak var userNameValue: UITextField!
    @IBOutlet weak var studentIDValue: UITextField!
    @IBOutlet weak var departmentValue: UITextField!
    @IBOutlet weak var gradeValue: UITextField!
    @IBOutlet weak var partControl: UISegmentedControl!
    @IBOutlet weak var statusControl: UISegmentedControl!
    @IBOutlet weak var reasonValue: UITextField!
    @IBOutlet weak var createDateValue: UITextField!
    @IBOutlet weak var writerValue: UITextField!
    @IBOutlet weak var rightBarButton: UIBarButtonItem!
    @IBOutlet weak var completeButton: UIButton!
    let userListPickerView: UIPickerView = UIPickerView()
    let noUserList = ["-- 회원 없음 --"]
    var dataList = [[String: Any]]()
    var data = [String: Any]()
    var userList: [String] = ["-- 선택 --"]
    var selectedUserUid: String = ""
    var selectedUser: String = ""
    var selectedIndex: Int = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        completeButton.isHidden = true
        createPickerView()
        dismissPickerView()
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
                    } else {
                        self.setDisabled()
                        self.setValue()
                        self.getUserList()
                    }
                }
            }
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func setEnabled() {
        userNameValue.isEnabled = true
        reasonValue.isEnabled = true
    }
    
    func setDisabled() {
        userNameValue.isEnabled = false
        studentIDValue.isEnabled = false
        departmentValue.isEnabled = false
        gradeValue.isEnabled = false
        partControl.isEnabled = false
        statusControl.isEnabled = false
        reasonValue.isEnabled = false
        createDateValue.isEnabled = false
        writerValue.isEnabled = false
    }
    
    func setValue() {
        userNameValue.text = data["userName"] as? String
        studentIDValue.text = data["studentID"] as? String
        departmentValue.text = data["department"] as? String
        gradeValue.text = data["grade"] as? String
        if let part = data["part"] as? String, part == "개발" {
            partControl.selectedSegmentIndex = 0
        } else {
            partControl.selectedSegmentIndex = 1
        }
        if let status = data["status"] as? String, status == "재학" {
            statusControl.selectedSegmentIndex = 0
        } else {
            statusControl.selectedSegmentIndex = 1
        }
        reasonValue.text = data["reason"] as? String
        createDateValue.text = data["create date"] as? String
        writerValue.text = data["writer"] as? String
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
        userListPickerView.selectRow(selectedIndex+1, inComponent: 0, animated: true)
        if selectedIndex != -1 { // 회원ㅇ -> 유저 선택
            userNameValue.text = selectedUser // 유저명
            studentIDValue.text = dataList[selectedIndex]["studentID"] as? String
            departmentValue.text = dataList[selectedIndex]["department"] as? String
            gradeValue.text = dataList[selectedIndex]["grade"] as? String
            if dataList[selectedIndex]["part"] as! String == "개발" {
                partControl.selectedSegmentIndex = 0
            } else {
                partControl.selectedSegmentIndex = 1
            }
            if dataList[selectedIndex]["status"] as! String == "재학" {
                statusControl.selectedSegmentIndex = 0
            } else {
                statusControl.selectedSegmentIndex = 1
            }
            selectedUser = ""
            selectedIndex = -1
        } else { // 회원 ㅇ -> 유저 선택안함 or 회원 x
            userNameValue.text = selectedUser // ""
            studentIDValue.text = ""
            departmentValue.text = ""
            gradeValue.text = ""
            partControl.selectedSegmentIndex = 0
            statusControl.selectedSegmentIndex = 0
        }
        self.view.endEditing(true)
    }
    
    @IBAction func rightBarButton(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "기능 선택", message: nil, preferredStyle: .actionSheet)
        let modify = UIAlertAction(title: "수정", style: .default) { (action) in
            self.rightBarButton.image = nil
            self.rightBarButton.isEnabled = false
            self.completeButton.isHidden = false
            self.setEnabled()
        }
        let delete = UIAlertAction(title: "삭제", style: .destructive) { (action) in
            let id = self.data["id"] as! String
            self.showAlertForDelete(id: id)
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alert.addAction(modify)
        alert.addAction(delete)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func completeButton(_ sender: UIButton) {
        guard let userName: String = userNameValue.text, userName.isEmpty == false else {
            showAlert(message: "빈칸을 채워주세요")
            return
        }
        guard let studentID: String = studentIDValue.text, studentID.isEmpty == false else {
            showAlert(message: "빈칸을 채워주세요")
            return
        }
        guard let department: String = departmentValue.text, department.isEmpty == false else {
            showAlert(message: "빈칸을 채워주세요")
            return
        }
        guard let grade: String = gradeValue.text, grade.isEmpty == false else {
            showAlert(message: "빈칸을 채워주세요")
            return
        }
        guard let reason: String = reasonValue.text, reason.isEmpty == false else {
            showAlert(message: "빈칸을 채워주세요")
            return
        }
        guard let createDate: String = createDateValue.text, createDate.isEmpty == false else {
            showAlert(message: "빈칸을 채워주세요")
            return
        }
        guard let writer: String = writerValue.text, writer.isEmpty == false else {
            showAlert(message: "빈칸을 채워주세요")
            return
        }
        
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
        
        let modifyData = ["userUid": selectedUserUid, "userName": userName, "studentID": studentID, "department": department, "grade": grade, "part": part, "status": status, "reason": reason] as [String: Any]
        let id = data["id"] as! String
        print(modifyData, id)

        let db = Firestore.firestore()
        db.collection("warningList").document("\(id)").updateData(modifyData) { (error) in
            if error != nil {
                print("check for error : \(error!.localizedDescription)")
            } else {
                self.showAlertModifyOrDelete(title: "수정 완료", message: "경고내역 수정이 완료되었습니다")
            }
        }
        
        rightBarButton.image = UIImage(systemName: "pencil.slash")
        rightBarButton.isEnabled = true
        completeButton.isHidden = true
        setDisabled()
    }
    
    func showAlertForDelete(id: String) {
        let alert = UIAlertController(title: "경고내역 삭제",
                                      message: "경고내역을 삭제하시겠습니까?",
                                      preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: "확인", style: .default) { (action) in
            let db = Firestore.firestore()
            db.collection("warningList").document("\(id)").delete { (error) in
                if error != nil {
                    print("check for error : \(error!.localizedDescription)")
                } else {
                    self.showAlertModifyOrDelete(title: "삭제 완료", message: "경고내역 삭제가 완료되었습니다")
                }
            }
        }
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func showAlertModifyOrDelete(title: String, message: String) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default) { (action) in
            self.navigationController?.popViewController(animated: true)
        }
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

extension AdminWarningDetailViewController: UIPickerViewAccessibilityDelegate, UIPickerViewDataSource {
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
        if dataList.count == 0 { // 회원이 없음
            selectedUserUid = ""
            selectedUser = "" // 선택 유저 없음
            selectedIndex = -1
        } else { // 회원 있음
            if row != 0 { // 유저 선택
                selectedUserUid = dataList[row-1]["uid"] as! String
                selectedUser = userList[row] // 유저 이름
                selectedIndex = row-1 // datalist 인덱스
            } else { // -- 선택 --
                selectedUserUid = ""
                selectedUser = "" // 유저 선택 안함
                selectedIndex = -1
            }
        }
    }
}
