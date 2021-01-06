//
//  PublicMoneyViewController.swift
//  ikeeperApp
//
//  Created by 김혜진 on 2021/01/02.
//

import UIKit
import Firebase

class PublicMoneyViewController: UIViewController {

    @IBOutlet weak var yearValue: UITextField!
    @IBOutlet weak var monthValue: UITextField!
    let yearPickerView: UIPickerView = UIPickerView()
    let monthPickerView: UIPickerView = UIPickerView()
    let years = ["-- year --", "2018년", "2019년", "2020년", "2021년", "2022년"]
    let months = ["-- month --", "전체", "1월", "2월", "3월", "4월", "5월", "6월", "7월", "8월", "9월", "10월", "11월", "12월"]
    var selectedYear = ""
    var selectedMonth = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        test()
        createPickerView()
        dismissPickerView()
    }
    
    func test() {
        let db = Firestore.firestore()
        db.collection("publicMoney").whereField("year", isEqualTo: "2021").whereField("month", isEqualTo: "1").getDocuments { (snapshot, error) in
            if error == nil && snapshot?.isEmpty == false {
                for document in snapshot!.documents {
                    let documentData = document.data()
                    print(documentData)
                }
            } else {
                print("x")
            }
        }
    }
        
    func createPickerView() {
        yearPickerView.delegate = self
        yearPickerView.dataSource = self
        monthPickerView.delegate = self
        monthPickerView.dataSource = self
        
        yearValue.inputView = yearPickerView
        monthValue.inputView = monthPickerView
        
        yearPickerView.tag = 1
        monthPickerView.tag = 2
    }
    
    func dismissPickerView() {
        let yearPickerToolBar = UIToolbar()
        let monthPickerToolBar = UIToolbar()
        
        yearPickerToolBar.sizeToFit()
        monthPickerToolBar.sizeToFit()
        
        yearPickerToolBar.isTranslucent = true
        monthPickerToolBar.isTranslucent = true

        let yearBtnDone = UIBarButtonItem(title: "확인", style: .done, target: self, action: #selector(yearPickerDone))
        let monthBtnDone = UIBarButtonItem(title: "확인", style: .done, target: self, action: #selector(monthPickerDone))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        
        yearPickerToolBar.setItems([space, yearBtnDone], animated: true)
        monthPickerToolBar.setItems([space, monthBtnDone], animated: true)
        
        yearPickerToolBar.isUserInteractionEnabled = true
        monthPickerToolBar.isUserInteractionEnabled = true
        
        yearValue.inputAccessoryView = yearPickerToolBar
        monthValue.inputAccessoryView = monthPickerToolBar
    }
    
    @objc func yearPickerDone() {
        yearValue.text = selectedYear
        selectedYear = ""
        self.view.endEditing(true)
    }
    
    @objc func monthPickerDone() {
        monthValue.text = selectedMonth
        selectedMonth = ""
        self.view.endEditing(true)
    }
}

extension PublicMoneyViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case 1:
            return years.count
        case 2:
            return months.count
        default:
            return 1
        }
//        if component == 0 {
//            return year.count
//        } else {
//            return month.count
//        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
        case 1:
            return years[row]
        case 2:
            return months[row]
        default:
            return "Data not found"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 1 {
            if row != 0 {
                selectedYear = years[row]
            } else {
                selectedYear = "" // "-- 선택 --" 선택하면
            }
        } else {
            if row != 0 {
                selectedMonth = months[row]
            } else {
                selectedMonth = "" // "-- 선택 --" 선택하면
            }
        }
    }
}
