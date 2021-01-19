//
//  PublicMoneyWriteViewController.swift
//  ikeeperApp
//
//  Created by 김혜진 on 2021/01/02.
//

import UIKit
import Firebase

class PublicMoneyWriteViewController: UIViewController {

    @IBOutlet weak var categoryControl: UISegmentedControl!
    @IBOutlet weak var amountValue: UITextField!
    @IBOutlet weak var historyDateValue: UITextField!
    @IBOutlet weak var createDateValue: UITextField!
    @IBOutlet weak var writerValue: UITextField!
    @IBOutlet weak var memoValue: UITextField!
    let datePicker: UIDatePicker = UIDatePicker()
    let formatter = DateFormatter()
    var sum: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setDate()
        getSum()
        createDatePicker()
        dismissDatePicker()
    }
    
    func setDate() {
        formatter.dateFormat = "YYYY-MM-dd"
        let dateString = formatter.string(from: Date())
        createDateValue.text = "\(dateString)"
        createDateValue.isEnabled = false
    }
    
    func getSum() {
        let db = Firestore.firestore()
        db.collection("publicMoney").document("sum").getDocument { [self] (document, error) in
            if error == nil {
                if document != nil && document!.exists {
                    let documentData = document!.data()
                    self.sum.append((documentData?["sum"] as? String)!) //error
                    print("getSum is \(self.sum)")
                }
            }
        }
    }
    
    // datePicker - date
    func createDatePicker() {
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        datePicker.datePickerMode = .date
        datePicker.locale = NSLocale(localeIdentifier: "ko_KO") as Locale // 한글로 변환
        historyDateValue.inputView = datePicker
    }
    
    func dismissDatePicker() {
        let dateToolBar = UIToolbar()
        dateToolBar.sizeToFit()
        dateToolBar.isTranslucent = true
        let btnDone = UIBarButtonItem(title: "확인", style: .done, target: self, action: #selector(dateDone))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        dateToolBar.setItems([space, btnDone], animated: true)
        dateToolBar.isUserInteractionEnabled = true
        historyDateValue.inputAccessoryView = dateToolBar
    }
    
    @objc func dateDone() {
        formatter.dateFormat = "YYYY-MM-dd"
        let dateString = formatter.string(from: datePicker.date)
        historyDateValue.text = "\(dateString)"
        self.view.endEditing(true)
    }
    
    @IBAction func writeButton(_ sender : UIButton) {
        guard let amount: String = amountValue.text, amount.isEmpty == false else {
            showAlert(message: "빈칸을 채워주세요")
            return
        }
        guard let createDate: String = createDateValue.text, createDate.isEmpty == false else {
            showAlert(message: "빈칸을 채워주세요")
            return
        }
        guard let historyDate: String = historyDateValue.text, historyDate.isEmpty == false else {
            showAlert(message: "빈칸을 채워주세요")
            return
        }
        guard let writer: String = writerValue.text, writer.isEmpty == false else {
            showAlert(message: "빈칸을 채워주세요")
            return
        }
        guard let memo: String = memoValue.text, memo.isEmpty == false else {
            showAlert(message: "빈칸을 채워주세요")
            return
        }
        
        var category = ""
        var op: Bool = true
        if self.categoryControl.selectedSegmentIndex == 0 {
            category = "수입"
            op = true
//            if let amountInt = Int(amount), let sumInt = Int(sum) {
//                sum = String(sumInt + amountInt)
//                print("current sum is \(sum)")
//            }
        } else {
            category = "지출"
            op = false
//            if let amountInt = Int(amount), let sumInt = Int(sum) {
//                sum = String(sumInt - amountInt)
//                print("current sum is \(sum)")
//            }
        }
        
        let calendar = Calendar.current
        let year = calendar.component(.year, from: self.datePicker.date)
        let month = calendar.component(.month, from: self.datePicker.date)
        let day = calendar.component(.day, from: self.datePicker.date)
        let timestamp = NSDate().timeIntervalSince1970

        // update sum(document)
        let db = Firestore.firestore()
        db.collection("publicMoney").document("sum").updateData(["sum": amount]) { (error) in
            if error != nil {
                print("check for error : \(error!.localizedDescription)")
            } else {
                print("success")
            }
        }
            
        // add data
        let newDocument = db.collection("publicMoney").document()
        newDocument.setData(["id": newDocument.documentID, "category": category, "amount": amount, "create date": createDate, "history date": historyDate, "year":year, "month":month, "day": day, "writer": writer, "memo": memo, "created": timestamp]) { (error) in
            if error != nil {
                print("check for error : \(error!.localizedDescription)")
                self.showAlert(message: "공금내역 등록 실패")
            }
//            else {
//                self.navigationController?.popViewController(animated: true)
//            }
        }
        
        // getDocuments
        db.collection("publicMoney").whereField("year", isGreaterThanOrEqualTo: year).order(by: "year", descending: false).order(by: "month", descending: false).order(by: "day", descending: false).order(by: "created", descending: false).getDocuments { (snapshot, error) in
            if error == nil && snapshot?.isEmpty == false {
                for document in snapshot!.documents {
                    let documentData = document.data()
                    if documentData["month"] as! Int >= month && documentData["day"] as! Int > day {
                        if let amountInt = Int(amount), let id = documentData["id"] as? String {
                            print(amountInt, id)
//                            db.collection("publicMoney").document("\(id)").updateData(["sum" : self.calculator(left: sumInt, right: amountInt , op: op)]) { (error) in
//                                if error != nil {
//                                    print("check for error : \(error!.localizedDescription)")
//                                } else {
//                                    print("success")
//                                }
//                            }
                        }
                    }
                }
                self.navigationController?.popViewController(animated: true)
                //db.collection("publicMoney").document("sum").updateData["sum": ]
            } else if error == nil && snapshot?.isEmpty == true {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    func calculator(left: Int, right: Int, op: Bool) -> String {
        if op {
            return String(left + right)
        } else {
            return String(left - right)
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
