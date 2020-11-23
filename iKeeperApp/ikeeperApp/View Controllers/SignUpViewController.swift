//
//  SignUpViewController.swift
//  ikeeperApp
//
//  Created by 김혜진 on 2020/11/06.
//

import UIKit
import Firebase
import FirebaseAuth

class SignUpViewController: UIViewController {

    @IBOutlet weak var studentIDValue: UITextField!
    @IBOutlet weak var nameValue: UITextField!
    @IBOutlet weak var pwValue: UITextField!
    @IBOutlet weak var pwCheckValue: UITextField!
    @IBOutlet weak var departmentValue: UITextField!
    @IBOutlet weak var gradeValue: UITextField!
    @IBOutlet weak var phoneNumberValue: UITextField!
    @IBOutlet weak var emailValue: UITextField!
    @IBOutlet weak var partControl: UISegmentedControl!
    @IBOutlet weak var statusControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    @IBAction func signUpButton(_ sender: UIButton) {
        guard let studentID: String = studentIDValue.text, studentID.isEmpty == false else {
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
        guard let email: String = emailValue.text, email.isEmpty == false else {
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
        // email 형식 검사 추가
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
                self.showAlert(message: "이미 가입된 이메일입니다. \n 다른 이메일 주소를 사용해주세요")
            } else {
                
                let db = Firestore.firestore()
                db.collection("users").addDocument(data: ["email": email, "name": name, "password": pw, "studentID": studentID, "department": department, "grade": grade, "phoneNumber": phoneNumber, "part": part, "status": status, "uid":result!.user.uid]) { (error) in
                    
                    if error != nil {
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
