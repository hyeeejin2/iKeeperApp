//
//  PublicMoneyViewController.swift
//  ikeeperApp
//
//  Created by 김혜진 on 2021/01/02.
//

import UIKit

class PublicMoneyViewController: UIViewController {

    @IBOutlet weak var dateValue: UITextField!
    //let datePicker: UIPickerView = UIPickerView()
    let year = ["-- year --", "2018년", "2019년", "2020년", "2021년", "2022년"]
    let month = ["-- month --", "1월", "2월", "3월", "4월", "5월", "6월", "7월", "8월", "9월", "10월", "11월", "12월"]
    var selectedYear = ""
    var selectedMonth = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        createPickerView()
        dismissPickerView()
    }
    
    func createPickerView() {
        let datePicker: UIPickerView = UIPickerView()
        datePicker.delegate = self
        datePicker.dataSource = self
        dateValue.inputView = datePicker // pickerView 추가
    }
    
    func dismissPickerView() {
        let pickerToolBar = UIToolbar()
        pickerToolBar.sizeToFit() // 서브뷰만큼 툴바 크기 맞춤
        pickerToolBar.isTranslucent = true // 툴바 반투명(true), 투명(false)
        let btnDone = UIBarButtonItem(title: "확인", style: .done, target: self, action: #selector(pickerDone))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        pickerToolBar.setItems([space, btnDone], animated: true) // 툴바에 버튼 추가
        pickerToolBar.isUserInteractionEnabled = true // 사용자 클릭 이벤트
        dateValue.inputAccessoryView = pickerToolBar // picerkView 툴바 추가
    }
    
    @objc func pickerDone() {
        dateValue.text = "\(selectedYear) \(selectedMonth)"
        //selectedYear = ""
        //selectedMonth = ""
        self.view.endEditing(true)
        //categoryValue.resignFirstResponder() // 키보드 내려감
    }
    
}
extension PublicMoneyViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return year.count
        } else {
            return month.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return year[row]
        } else {
            return month[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            if row != 0 {
                selectedYear = year[row]
            } else {
                selectedYear = "" // "-- year --" 선택하면
            }
        } else {
            if row != 0 {
                selectedMonth = month[row]
            } else {
                selectedMonth = "" // "-- month --" 선택하면
            }
        }
    }
}
