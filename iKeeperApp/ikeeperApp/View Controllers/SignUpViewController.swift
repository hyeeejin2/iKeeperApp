//
//  SignUpViewController.swift
//  ikeeperApp
//
//  Created by 김혜진 on 2020/11/06.
//

import UIKit
import Firebase
import FirebaseAuth

class SignUpViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var idValue: UITextField!
    @IBOutlet weak var domainValue: UITextField!
    @IBOutlet weak var nameValue: UITextField!
    @IBOutlet weak var pwValue: UITextField!
    @IBOutlet weak var pwCheckValue: UITextField!
    @IBOutlet weak var studentIDValue: UITextField!
    @IBOutlet weak var departmentValue: UITextField!
    @IBOutlet weak var gradeValue: UITextField!
    @IBOutlet weak var phoneNumberValue: UITextField!
    @IBOutlet weak var partControl: UISegmentedControl!
    @IBOutlet weak var statusControl: UISegmentedControl!
    let domainPickerView: UIPickerView = UIPickerView()
    let departmentPickerView: UIPickerView = UIPickerView()
    let gradePickerView: UIPickerView = UIPickerView()
    let domainKinds = ["-- 선택 --","gmail.com", "naver.com", "nate.com", "daum.net"]
    let departmentKinds = ["-- 선택 --", "컴퓨터소프트웨어학부", "컴퓨터공학전공", "스마트IoT전공", "사이버보안전공", "모바일소프트웨어전공"]
    let gradeKinds = ["-- 선택 --", "1", "2", "3", "4"]
    var selectedDomain:String = ""
    var selectedDepartment: String = ""
    var selectedGrade: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        createPickerView()
        dismissPickerView()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case 1:
            return domainKinds.count
        case 2:
            return departmentKinds.count
        case 3:
            return gradeKinds.count
        default:
            return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
        case 1:
            return domainKinds[row]
        case 2:
            return departmentKinds[row]
        case 3:
            return gradeKinds[row]
        default:
            return "Data not found"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 1 {
            if row != 0 {
                selectedDomain = domainKinds[row]
            } else {
                selectedDomain = "" // "-- 선택 --" 선택하면
            }
        } else if pickerView.tag == 2 {
            if row != 0 {
                selectedDepartment = departmentKinds[row]
            } else {
                selectedDepartment = "" // "-- 선택 --" 선택하면
            }
        } else {
            if row != 0 {
                selectedGrade = gradeKinds[row]
            } else {
                selectedGrade = "" // "-- 선택 --" 선택하면
            }
        }
    }

    func createPickerView() {
        domainPickerView.delegate = self
        domainPickerView.dataSource = self
        departmentPickerView.delegate = self
        departmentPickerView.dataSource = self
        gradePickerView.delegate = self
        gradePickerView.dataSource = self
        
        domainValue.inputView = domainPickerView
        departmentValue.inputView = departmentPickerView
        gradeValue.inputView = gradePickerView
        
        domainPickerView.tag = 1
        departmentPickerView.tag = 2
        gradePickerView.tag = 3
    }
    
    func dismissPickerView() {
        let domainPickerToolBar = UIToolbar()
        let departmentPickerToolBar = UIToolbar()
        let gradePickerToolBar = UIToolbar()
        
        domainPickerToolBar.sizeToFit()
        departmentPickerToolBar.sizeToFit()
        gradePickerToolBar.sizeToFit()
        
        domainPickerToolBar.isTranslucent = true
        departmentPickerToolBar.isTranslucent = true
        gradePickerToolBar.isTranslucent = true
        
        let domainBtnDone = UIBarButtonItem(title: "확인", style: .done, target: self, action: #selector(domainPickerDone))
        let departmentBtnDone = UIBarButtonItem(title: "확인", style: .done, target: self, action: #selector(departmentPickerDone))
        let gradeBtnDone = UIBarButtonItem(title: "확인", style: .done, target: self, action: #selector(gradePickerDone))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        
        domainPickerToolBar.setItems([space, domainBtnDone], animated: true)
        departmentPickerToolBar.setItems([space, departmentBtnDone], animated: true)
        gradePickerToolBar.setItems([space, gradeBtnDone], animated: true)
        
        domainPickerToolBar.isUserInteractionEnabled = true
        departmentPickerToolBar.isUserInteractionEnabled = true
        gradePickerToolBar.isUserInteractionEnabled = true
        
        domainValue.inputAccessoryView = domainPickerToolBar
        departmentValue.inputAccessoryView = departmentPickerToolBar
        gradeValue.inputAccessoryView = gradePickerToolBar
    }
    
    @objc func domainPickerDone() {
        domainValue.text = selectedDomain
        selectedDomain = ""
        self.view.endEditing(true)
    }
    
    @objc func departmentPickerDone() {
        departmentValue.text = selectedDepartment
        selectedDepartment = ""
        self.view.endEditing(true)
    }
    
    @objc func gradePickerDone() {
        gradeValue.text = selectedGrade
        selectedGrade = ""
        self.view.endEditing(true)
    }
    
    // signUpButton
    @IBAction func signUpButton(_ sender: UIButton) {
       
        guard let id: String = idValue.text, id.isEmpty == false else {
            showAlert(message: "빈칸을 채워주세요")
            return
        }
        guard let domain: String = domainValue.text, domain.isEmpty == false else {
            showAlert(message: "빈칸을 채워주세요")
            return
        }
        guard let name: String = nameValue.text, name.isEmpty == false else {
            showAlert(message: "빈칸을 채워주세요")
            return
        }
        guard let pw: String = pwValue.text, pw.isEmpty == false else {
            showAlert(message: "빈칸을 채워주세요")
            return
        }
        guard let pwCheck: String = pwCheckValue.text, pwCheck.isEmpty == false else {
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
        guard let phoneNumber: String = phoneNumberValue.text, phoneNumber.isEmpty == false else {
            showAlert(message: "빈칸을 채워주세요")
            return
        }
        guard pw == pwCheck else {
            showAlert(message: "비밀번호를 확인해주세요")
            return
        }
        guard pw.count >= 7  || pwCheck.count >= 7 else {
            showAlert(message: "비밀번호를 7자 이상 입력해주세요")
            return
        }
        // 비밀번호 규칙 추가
        let email:String = "\(id+"@"+domain)"
        var part: String = ""
        var status: String = ""
        
        if self.partControl.selectedSegmentIndex == 0 {
            part = "개발"
        } else {
            part = "보안"
        }
        if self.statusControl.selectedSegmentIndex == 0 {
            status = "재학"
        } else {
            status = "휴학"
        }
        
        Auth.auth().createUser(withEmail: email, password: pw) { (result, err) in
            
            // check for error
            if err != nil {
                print("check for err : \(err!.localizedDescription)")
                switch err?.localizedDescription {
                case "The email address is already in use by another account.":
                    self.showAlert(message: "이미 가입된 이메일입니다. \n 다른 이메일 주소를 사용해주세요")
                case "The email address is badly formatted.":
                    self.showAlert(message: "올바른 이메일 형식을 작성해주세요")
                default:
                    self.showAlert(message: "회원가입 실패")
                    return
                }
            } else {
                
                let db = Firestore.firestore()
                db.collection("users").addDocument(data: ["email": email, "name": name, "password": pw, "studentID": studentID, "department": department, "grade": grade, "phoneNumber": phoneNumber, "part": part, "status": status, "warning": 0, "permission": false, "uid":result!.user.uid]) { (error) in
                    
                    if error != nil {
                        print("check for err : \(error!.localizedDescription)")
                        self.showAlert(message: "회원가입 실패")
                    }
                }
                self.navigationController?.popViewController(animated: true)
                
            }
        }
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "알림",
                                      message: message,
                                      preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .cancel, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
 }
