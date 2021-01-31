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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setDate()
        createDatePicker()
        dismissDatePicker()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setUser()
    }
    
    func setUser(){
        let user = Auth.auth().currentUser
        if user != nil {
            let uid: String = user!.uid
            let db = Firestore.firestore()
            db.collection("users").whereField("uid", isEqualTo: uid).whereField("permission", isEqualTo: true).getDocuments { (snapshot, error) in
                if error == nil && snapshot?.isEmpty == false {
                    for document in snapshot!.documents {
                        let documentData = document.data()
                        print(documentData)
                        self.writerValue.text = documentData["name"] as? String
                        self.writerValue.isEnabled = false
                    }
                } else if error == nil && snapshot?.isEmpty == true {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func setDate() {
        formatter.dateFormat = "YYYY-MM-dd"
        let dateString = formatter.string(from: Date())
        createDateValue.text = "\(dateString)"
        createDateValue.isEnabled = false
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
        
        var category: String = ""
        var op: String = ""
        if self.categoryControl.selectedSegmentIndex == 0 {
            category = "수입"
            op = "+"
        } else {
            category = "지출"
            op = "-"
        }
        
        let user = Auth.auth().currentUser
        let uid: String = user!.uid
        let calendar = Calendar.current
        let year = calendar.component(.year, from: self.datePicker.date)
        let month = calendar.component(.month, from: self.datePicker.date)
        let day = calendar.component(.day, from: self.datePicker.date)
        let timestamp = NSDate().timeIntervalSince1970
            
        // add data
        let db = Firestore.firestore()
        let newDocument = db.collection("publicMoney").document()
        newDocument.setData(["id": newDocument.documentID, "uid": uid, "category": category, "amount": amount, "op": op, "create date": createDate, "history date": historyDate, "year":year, "month":month, "day": day, "writer": writer, "memo": memo, "created": timestamp]) { (error) in
            if error != nil {
                print("check for error : \(error!.localizedDescription)")
                self.showAlert(message: "공금내역 등록 실패")
            }
            else {
                self.showAlertForWrite()
            }
        }
    }
    
    func showAlertForWrite() {
        let alert = UIAlertController(title: "등록 완료",
                                      message: "공금내역 등록이 완료되었습니다",
                                      preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default) { (action) in
            self.navigationController?.popViewController(animated: true)
        }
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
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
