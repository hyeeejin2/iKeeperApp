//
//  LoginViewController.swift
//  ikeeperApp
//
//  Created by 김혜진 on 2020/11/05.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet weak var emailValue: UITextField!
    @IBOutlet weak var pwValue: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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
                self.showAlert(message: "이메일 또는 비밀번호를 확인해주세요")
            } else {
//                let user = Auth.auth().currentUser
//                if let user = user {
//                    let uid = user.uid
//                    print(uid)
//                }
                self.transitionHome()
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
    
    func transitionHome() {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let homeViewController = storyboard.instantiateViewController(withIdentifier: Constants.Storyboard.homeViewController)
        let rootViewController = UINavigationController(rootViewController: homeViewController)
        
        view.window?.rootViewController = rootViewController
        view.window?.makeKeyAndVisible()
        
        //self.navigationController?.popToRootViewController(animated: true)
/*
        // navigation stack에 homeView push
        let homeViewController = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC")
        self.navigationController?.pushViewController(homeViewController!, animated: true)
 */
        
/*
        self.navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
        self.navigationController?.popToRootViewController(animated: true)
*/
        
/*
        // homeViewController에 대한 참조 상수
        let homeViewController = storyboard?.instantiateViewController(identifier:
                                                                        Constants.Storyboard.homeViewController)
                                                                        as? HomeViewController
        
        view.window?.rootViewController = homeViewController // rootViewController 속성에 homeViewController 할당
        view.window?.makeKeyAndVisible() // makekeyAndVisible() 메서드 호출
 */
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}
