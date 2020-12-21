//
//  InformationWriteViewController.swift
//  ikeeperApp
//
//  Created by 김혜진 on 2020/12/20.
//

import UIKit
import Firebase

class InformationWriteViewController: UIViewController {

    @IBOutlet weak var titleValue: UITextField!
    @IBOutlet weak var writerValue: UITextField!
    @IBOutlet weak var dateValue: UITextField!
    @IBOutlet weak var timeValue: UITextField!
    @IBOutlet weak var contentValue: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func writeButton(_ sender: UIButton) {
        guard let title: String = titleValue.text, title.isEmpty == false else {
            showAlert(message: "빈칸을 채워주세요")
            return
        }
        guard let writer: String = writerValue.text, writer.isEmpty == false else {
            showAlert(message: "빈칸을 채워주세요")
            return
        }
        guard let date: String = dateValue.text, date.isEmpty == false else {
            showAlert(message: "빈칸을 채워주세요")
            return
        }
        guard let time: String = timeValue.text, time.isEmpty == false else {
            showAlert(message: "빈칸을 채워주세요")
            return
        }
        guard let content: String = contentValue.text, content.isEmpty == false else {
            showAlert(message: "빈칸을 채워주세요")
            return
        }
        
        let views: Int = 0
        let db = Firestore.firestore()
        let newDocument = db.collection("infoList").document()
        newDocument.setData(["id": newDocument.documentID,"title": title, "writer": writer, "date": date, "time": time, "views": views, "content": content]) { (error) in
            if error != nil {
                print("check for error : \(error!.localizedDescription)")
                self.showAlert(message: "게시글 등록 실패")
            } else {
                self.navigationController?.popViewController(animated: true)
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
