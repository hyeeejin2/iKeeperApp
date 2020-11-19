//
//  SignUpViewController.swift
//  ikeeperApp
//
//  Created by 김혜진 on 2020/11/06.
//

import UIKit

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
        
        var data: [String: String] = ["studentID": studentID, "name": name, "pw": pw,
                                      "pwCheck" : pwCheck, "department": department,
                                      "grade": grade, "phoneNumber": phoneNumber, "email": email]
        if partControl.selectedSegmentIndex == 0 {
            data["part"] = "개발"
        } else {
            data["part"] = "보안"
        }
        if statusControl.selectedSegmentIndex == 0 {
            data["status"] = "재학"
        } else {
            data["status"] = "휴학"
        }
        print("sign up data \(data)")
        
        guard let url = URL(string: "http://192.168.137.222:3000/signUpProcess") else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
            
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
        } catch {
            print(error.localizedDescription)
        }
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept-Type")
        
        let session = URLSession.shared
        session.dataTask(with: request) {(data, response, error) in
            DispatchQueue.main.async() {
                if let result = String(data: data!, encoding: .utf8), result == "Success" {
                    //self.showAlert(message: "회원가입 성공")
                    self.navigationController?.popViewController(animated: true)
                } else {
                    self.showAlert(message: "회원가입 실패")
                }
            }
        }.resume()
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "알림",
                                      message: message,
                                      preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .cancel, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    */
 }
