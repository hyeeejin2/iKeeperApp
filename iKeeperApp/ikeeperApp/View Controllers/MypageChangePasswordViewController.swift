//
//  MypageChangePasswordViewController.swift
//  ikeeperApp
//
//  Created by 김혜진 on 2021/01/26.
//

import UIKit
import Firebase
import FirebaseAuth

class MypageChangePasswordViewController: UIViewController {

    @IBOutlet weak var CurrentValue: UITextField!
    @IBOutlet weak var NewValue: UITextField!
    @IBOutlet weak var NewCheckValue: UITextField!
    var documentID: String = ""
    var currentPW: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        getValue()
    }
    
    func getValue() {
        let user = Auth.auth().currentUser
        if user != nil {
            let uid: String = user!.uid
            let db = Firestore.firestore()
            db.collection("users").whereField("uid", isEqualTo: uid).getDocuments { (snapshot, error) in
                if error == nil && snapshot?.isEmpty == false {
                    for document in snapshot!.documents {
                        let documentData = document.data()
                        self.documentID = document.documentID
                        self.currentPW = documentData["password"] as! String
                    }
                }
            }
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func changeButton(_ sender: UIButton) {
        guard let current = CurrentValue.text, current.isEmpty == false else {
            showAlert(message: "빈칸을 채워주세요")
            return
        }
        guard let new = NewValue.text, new.isEmpty == false else {
            showAlert(message: "빈칸을 채워주세요")
            return
        }
        guard let newCheck = NewCheckValue.text, newCheck.isEmpty == false else {
            showAlert(message: "빈칸을 채워주세요")
            return
        }
        // 현재 비밀번호가 틀리면
        guard currentPW == current else {
            showAlert(message: "현재 비밀번호를 확인해주세요")
            return
        }
        // 새 비밀번호와 새 비밀번호 확인이 다르면
        guard new == newCheck else {
            showAlert(message: "새 비밀번호를 확인해주세요")
            return
        }
        // 현재 비밀번호가 새 비밀번호와 같으면
        guard current != new else {
            showAlert(message: "현재 비밀번호와 새 비밀번호가 같습니다")
            return
        }
        guard new.count >= 7  || newCheck.count >= 7 else {
            showAlert(message: "비밀번호를 7자 이상 입력해주세요")
            return
        }
        // 비밀번호 규칙 추가
        
        let modifyData = ["password": new]
        print(modifyData)
        
        Auth.auth().currentUser?.updatePassword(to: new) { (err) in
            if err != nil {
                print("check for err : \(err!.localizedDescription)")
            } else {
                let db = Firestore.firestore()
                db.collection("users").document("\(self.documentID)").updateData(modifyData) { (error) in
                    if error != nil {
                        print("check for error : \(error!.localizedDescription)")
                    } else {
                        print("success")
                        self.showAlert(message: "비밀번호 변경 성공")
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
