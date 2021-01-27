//
//  MypageWrittenInfoViewController.swift
//  ikeeperApp
//
//  Created by 김혜진 on 2021/01/27.
//

import UIKit
import Firebase
//import FirebaseAuth

class MypageWrittenInfoViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func setList() {
        let user = Auth.auth().currentUser
        if user != nil {
            let uid: String = user!.uid
            print(uid)
        } else {
            print("no user")
        }
    }

}
