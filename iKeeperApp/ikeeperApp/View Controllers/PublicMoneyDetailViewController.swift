//
//  PublicMoneyDetailViewController.swift
//  ikeeperApp
//
//  Created by 김혜진 on 2021/01/19.
//

import UIKit
import Firebase

class PublicMoneyDetailViewController: UIViewController {

    @IBOutlet weak var categoryControl: UISegmentedControl!
    @IBOutlet weak var amountValue: UITextField!
    @IBOutlet weak var historyDateValue: UITextField!
    @IBOutlet weak var createDateValue: UITextField!
    @IBOutlet weak var writerValue: UITextField!
    @IBOutlet weak var memoValue: UITextField!
    @IBOutlet weak var editBarButton: UIBarButtonItem!
    @IBOutlet weak var completeButton: UIButton!
    let datePicker: UIDatePicker = UIDatePicker()
    let formatter = DateFormatter()
    var dataList = [String: Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        print(dataList)
        completeButton.isHidden = true
        setDisabled()
        setValue()
        createDatePicker()
        dismissDatePicker()
    }
    
    func setEnabled() {
        categoryControl.isEnabled = true
        amountValue.isEnabled = true
        historyDateValue.isEnabled = true
        memoValue.isEnabled = true
    }
    
    func setDisabled() {
        categoryControl.isEnabled = false
        amountValue.isEnabled = false
        historyDateValue.isEnabled = false
        createDateValue.isEnabled = false
        writerValue.isEnabled = false
        memoValue.isEnabled = false
    }
    
    func setValue() {
        let category = dataList["category"] as? String
        if category == "수입" {
            categoryControl.selectedSegmentIndex = 0
        } else {
            categoryControl.selectedSegmentIndex = 1
        }
        amountValue.text = dataList["amount"] as? String
        historyDateValue.text = dataList["history date"] as? String
        createDateValue.text = dataList["create date"] as? String
        writerValue.text = dataList["writer"] as? String
        memoValue.text = dataList["memo"] as? String
    }
    
    // datePicker - date
    func createDatePicker() {
        if #available(iOS 13.4, *) {
                datePicker.preferredDatePickerStyle = .wheels
        }
        datePicker.datePickerMode = .date
        datePicker.locale = NSLocale(localeIdentifier: "ko_KO") as Locale // 한글로 변환
        if let date: String = dataList["history date"] as? String {
            formatter.dateFormat = "YYYY-MM-dd"
            datePicker.date = formatter.date(from: date)!
        }
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
    
    @IBAction func editButton(_ sender: UIBarButtonItem) {
        editBarButton.title = ""
        editBarButton.image = nil
        editBarButton.isEnabled = false
        completeButton.isHidden = false
        setEnabled()
    }
    
    @IBAction func completeButton(_ sender: UIButton) {
        guard let amount: String = amountValue.text, amount.isEmpty == false else {
            showAlert(message: "빈칸을 채워주세요")
            return
        }
        guard let historyDate: String = historyDateValue.text, historyDate.isEmpty == false else {
            showAlert(message: "빈칸을 채워주세요")
            return
        }
        guard let createDate: String = createDateValue.text, createDate.isEmpty == false else {
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
    
        let calendar = Calendar.current
        let year = calendar.component(.year, from: self.datePicker.date)
        let month = calendar.component(.month, from: self.datePicker.date)
        let day = calendar.component(.day, from: self.datePicker.date)
        
        let modifyData = ["category": category, "amount":amount, "op": op, "history date": historyDate, "year":year, "month": month, "day": day, "memo": memo] as [String: Any]
        let id = dataList["id"] as! String
        print(modifyData, id)
        
        let db = Firestore.firestore()
        db.collection("publicMoney").document("\(id)").updateData(modifyData) { (error) in
            if error != nil {
                print("check for error : \(error!.localizedDescription)")
            } else {
                print("success")
            }
        }
        
        editBarButton.title = "edit"
        editBarButton.image = UIImage(systemName: "pencil.slash")
        editBarButton.isEnabled = true
        completeButton.isHidden = true
        setDisabled()
    }
    
    @IBAction func deleteButton(_ sender: UIBarButtonItem) {
        let id = dataList["id"] as! String
        
        let db = Firestore.firestore()
        db.collection("publicMoney").document("\(id)").delete { (error) in
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
