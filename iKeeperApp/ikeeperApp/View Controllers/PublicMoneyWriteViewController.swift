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
    @IBOutlet weak var dateValue: UITextField!
    @IBOutlet weak var writerValue: UITextField!
    @IBOutlet weak var memoValue: UITextField!
    var sum: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setDate()
        getSum()
    }
    
    func setDate() {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd"
        let dateString = formatter.string(from: Date())
        dateValue.text = "\(dateString)"
        dateValue.isEnabled = false
    }
    
    func getSum() {
        let db = Firestore.firestore()
        db.collection("publicMoney").document("sum").getDocument { (document, error) in
            if error == nil {
                if document != nil && document!.exists {
                    let documentData = document!.data()
                    self.sum = documentData?["sum"] as! String
                    print("getSum is \(self.sum)")
                }
            }
        }
    }
    
    @IBAction func writeButton(_ sender : UIButton) {
        guard let amount: String = amountValue.text, amount.isEmpty == false else {
            showAlert(message: "빈칸을 채워주세요")
            return
        }
        guard let date: String = dateValue.text, date.isEmpty == false else {
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
        
        let calendar = Calendar.current
        let year = calendar.component(.year, from: Date())
        let month = calendar.component(.month, from: Date())
        let day = calendar.component(.day, from: Date())
        
        var category = ""
        if self.categoryControl.selectedSegmentIndex == 0 {
            category = "수입"
            if let amountInt = Int(amount), let sumInt = Int(sum) {
                sum = String(sumInt + amountInt)
                print("current sum is \(sum)")
            }
        } else {
            category = "지출"
            if let amountInt = Int(amount), let sumInt = Int(sum) {
                guard sumInt-amountInt >= 0 else {
                    self.showAlert(message: "합계가 0보다 작을 수 없음")
                    return
                }
                sum = String(sumInt - amountInt)
                print("current sum is \(sum)")
            }
        }

        // update sum(document)
        let db = Firestore.firestore()
        db.collection("publicMoney").document("sum").updateData(["sum": sum]) { (error) in
            if error != nil {
                print("check for error : \(error!.localizedDescription)")
            } else {
                print("success")
            }
        }
            
        // add data
        let newDocument = db.collection("publicMoney").document()
        newDocument.setData(["id": newDocument.documentID, "category": category, "amount": amount, "sum": sum, "date": date, "year":year, "month":month, "day": day, "writer": writer, "memo": memo]) { (error) in
            if error != nil {
                print("check for error : \(error!.localizedDescription)")
                self.showAlert(message: "공금내역 등록 실패")
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
