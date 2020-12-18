//
//  CalendarDetailViewController.swift
//  ikeeperApp
//
//  Created by 김혜진 on 2020/12/17.
//

import UIKit
import Firebase

class CalendarDetailViewController: UIViewController {

    @IBOutlet weak var titleValue: UITextField!
    @IBOutlet weak var writerValue: UITextField!
    @IBOutlet weak var categoryValue: UITextField!
    @IBOutlet weak var dateValue: UITextField!
    @IBOutlet weak var startValue: UITextField!
    @IBOutlet weak var endValue: UITextField!
    @IBOutlet weak var placeValue: UITextField!
    @IBOutlet weak var contentValue: UITextField!
    @IBOutlet weak var editBarButton: UIBarButtonItem!
    @IBOutlet weak var completeButton: UIButton!
    var data = [String: Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        completeButton.isHidden = true
        setDisabled()
        setValue()
    }
    
    func setEnabled() {
        titleValue.isEnabled = true
        writerValue.isEnabled = true
        categoryValue.isEnabled = true
        dateValue.isEnabled = true
        startValue.isEnabled = true
        endValue.isEnabled = true
        placeValue.isEnabled = true
        contentValue.isEnabled = true
    }
    
    func setDisabled() {
        titleValue.isEnabled = false
        writerValue.isEnabled = false
        categoryValue.isEnabled = false
        dateValue.isEnabled = false
        startValue.isEnabled = false
        endValue.isEnabled = false
        placeValue.isEnabled = false
        contentValue.isEnabled = false
    }
    
    func setValue() {
        titleValue.text = data["title"] as? String
        writerValue.text = data["writer"] as? String
        categoryValue.text = data["category"] as? String
        dateValue.text = data["date"] as? String
        startValue.text = data["startTime"] as? String
        endValue.text = data["endTime"] as? String
        placeValue.text = data["place"] as? String
        contentValue.text = data["content"] as? String
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
        guard let category: String = categoryValue.text, category.isEmpty == false else {
            showAlert(message: "빈칸을 채워주세요")
            return
        }
        guard let date: String = dateValue.text, date.isEmpty == false else {
            showAlert(message: "빈칸을 채워주세요")
            return
        }
        guard let startTime: String = startValue.text, startTime.isEmpty == false else {
            showAlert(message: "빈칸을 채워주세요")
            return
        }
        guard let endTime: String = endValue.text, endTime.isEmpty == false else {
            showAlert(message: "빈칸을 채워주세요")
            return
        }
        guard let place: String = placeValue.text, place.isEmpty == false else {
            showAlert(message: "빈칸을 채워주세요")
            return
        }
        guard let content: String = contentValue.text, content.isEmpty == false else {
            showAlert(message: "빈칸을 채워주세요")
            return
        }
        
        let modifyData = ["title": titleValue.text!, "writer": writerValue.text!, "category":categoryValue.text!, "date": dateValue.text!, "startTime": startValue.text!, "endTime": endValue.text!, "place": placeValue.text!, "content": contentValue.text!]
        let id = data["id"] as! String
        print(modifyData, id)
        
        let db = Firestore.firestore()
        db.collection("calendar").document("\(id)").updateData(modifyData) { (error) in
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
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "알림",
                                      message: message,
                                      preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
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
