//
//  MypageViewController.swift
//  ikeeperApp
//
//  Created by 김혜진 on 2021/01/17.
//

import UIKit
import Firebase

class MypageViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var departmentLabel: UILabel!
    @IBOutlet weak var gradeLabel: UILabel!
    @IBOutlet weak var partLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setProfile()
    }
    
    func setProfile() {
        let user = Auth.auth().currentUser
        if user != nil {
            let uid: String = user!.uid
            let db = Firestore.firestore()
            db.collection("users").whereField("uid", isEqualTo: uid).getDocuments { (snapshot, error) in
                if error == nil && snapshot?.isEmpty == false {
                    for document in snapshot!.documents {
                        let documentData = document.data()
                        print(documentData)
                        self.nameLabel.text = documentData["name"] as? String
                        self.departmentLabel.text = documentData["department"] as? String
                        self.gradeLabel.text = documentData["grade"] as? String
                        self.partLabel.text = documentData["part"] as? String
                        self.statusLabel.text = documentData["status"] as? String
                    }
                }
            }
        }
    }
    
    @IBAction func logout(_ sender: UIButton) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
}
