//
//  InformationDetailViewController.swift
//  ikeeperApp
//
//  Created by 김혜진 on 2020/12/20.
//

import UIKit
import Firebase

class InformationDetailViewController: UIViewController {

    @IBOutlet weak var titleValue: UITextField!
    @IBOutlet weak var writerValue: UITextField!
    @IBOutlet weak var dateValue: UITextField!
    @IBOutlet weak var timeValue: UITextField!
    @IBOutlet weak var viewsValue: UITextField!
    @IBOutlet weak var contentValue: UITextField!
    @IBOutlet weak var editBarButton: UIBarButtonItem!
    @IBOutlet weak var completeButton: UIButton!
    var dataList = [String: Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        completeButton.isHidden = true
        setDisabled()
        setValue()
        print(dataList)
    }
    
    func setEnabled() {
        titleValue.isEnabled = true
        writerValue.isEnabled = true
        dateValue.isEnabled = true
        timeValue.isEnabled = true
        //viewsValue.isEnabled = true
        contentValue.isEnabled = true
    }
    
    func setDisabled() {
        titleValue.isEnabled = false
        writerValue.isEnabled = false
        dateValue.isEnabled = false
        timeValue.isEnabled = false
        viewsValue.isEnabled = false
        contentValue.isEnabled = false
    }
    
    func setValue() {
        titleValue.text = dataList["title"] as? String
        writerValue.text = dataList["writer"] as? String
        dateValue.text = dataList["date"] as? String
        timeValue.text = dataList["time"] as? String
        viewsValue.text = String((dataList["views"] as? Int)!)
        contentValue.text = dataList["content"] as? String
    }

    @IBAction func editButton(_ sender: UIBarButtonItem) {
        editBarButton.title = ""
        editBarButton.isEnabled = false
        completeButton.isHidden = false
        setEnabled()
    }
    
    @IBAction func completeButton(_ sender: UIButton) {
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
        guard let views: String = viewsValue.text, views.isEmpty == false else {
            showAlert(message: "빈칸을 채워주세요")
            return
        }
        guard let content: String = contentValue.text, content.isEmpty == false else {
            showAlert(message: "빈칸을 채워주세요")
            return
        }
        
        let modifyData = ["title": titleValue.text!, "writer": writerValue.text!, "date": dateValue.text!, "time": timeValue.text!, "content": contentValue.text!]
        let id = dataList["id"] as! String
        print(modifyData, id)
        
        let db = Firestore.firestore()
        db.collection("infoList").document("\(id)").updateData(modifyData) { (error) in
            if error != nil {
                print("check for error : \(error!.localizedDescription)")
            } else {
                print("success")
            }
        }
        editBarButton.title = "edit"
        editBarButton.isEnabled = true
        completeButton.isHidden = true
        setDisabled()
    }
    
    @IBAction func deleteButton(_ sender: UIBarButtonItem) {
        let id = dataList["id"] as! String
        
        let db = Firestore.firestore()
        db.collection("infoList").document("\(id)").delete { (error) in
            if error != nil {
                print("check for error : \(error!.localizedDescription)")
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