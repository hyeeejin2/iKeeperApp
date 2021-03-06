//
//  LoginViewController.swift
//  ikeeperApp
//
//  Created by 김혜진 on 2020/11/05.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet weak var emailValue: UITextField!
    @IBOutlet weak var pwValue: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func loginButton(_ sender: UIButton) {
        guard let email: String = emailValue.text, email.isEmpty == false else {
            showAlert(message: "빈칸을 채워주세요")
            return
        }
        guard let pw: String = pwValue.text, pw.isEmpty == false else {
            showAlert(message: "빈칸을 채워주세요")
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: pw) { (result, error) in
            if error != nil {
                print("check for error : \(error!.localizedDescription)")
                switch error!.localizedDescription {
                case "There is no user record corresponding to this identifier. The user may have been deleted.":
                    self.showAlert(message: "존재하지 않는 사용자입니다")
                case "The password is invalid or the user does not have a password.":
                    self.showAlert(message: "이메일 또는 비밀번호를 확인해주세요")
                default:
                    self.showAlert(message: "로그인 실패")
                    return
                }
            } else {
                let user = Auth.auth().currentUser
                let uid: String = user!.uid
                let db = Firestore.firestore()
                db.collection("users").whereField("uid", isEqualTo: uid).getDocuments { (snapshot, error) in
                    if error != nil {
                        print("check for error : \(error!.localizedDescription)")
                    } else {
                        if snapshot!.isEmpty == true {
                            Auth.auth().currentUser?.delete(completion: { (err) in
                                if err != nil {
                                    print("check for error : \(err!.localizedDescription)")
                                } else {
                                    self.showAlert(message: "존재하지 않는 사용자입니다")
                                }
                            })
                        } else {
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                }
            }
        }

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
