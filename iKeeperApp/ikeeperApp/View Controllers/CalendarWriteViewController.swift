//
//  CalendarWriteViewController.swift
//  ikeeperApp
//
//  Created by 김혜진 on 2020/11/13.
//

import UIKit

class CalendarWriteViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var titleValue: UITextField!
    @IBOutlet weak var writerValue: UITextField!
    @IBOutlet weak var categoryValue: UITextField!
    @IBOutlet weak var dateValue: UITextField!
    @IBOutlet weak var startValue: UITextField!
    @IBOutlet weak var endValue: UITextField!
    @IBOutlet weak var placeValue: UITextField!
    @IBOutlet weak var contentValue: UITextField!
    let datePicker: UIDatePicker = UIDatePicker()
    let category = ["-- 선택 --","스터디", "세미나", "교육", "대회", "기타"]
    var selectedCategory:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        createPickerView()
        dismissPickerView()
        createDatePicker()
        dismissDatePicker()
    }
    
    // 선택 가능한 리스트 개수
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // pickerView에 표시될 항목 개수 반환
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return category.count
    }
    
    // pickerView 내에서 특정한 위치(row)를 가르키면 해당 위치의 문자열을 반환
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return category[row]
    }
    
    // pickerView에서 특정 위치(row)가 선택될 때 어떤 행동을 할지 정의
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("select")
        if row != 0 {
            selectedCategory = category[row]
        } else {
            selectedCategory = "" // "-- 선택 --" 선택하면
        }
    }
    
    func createPickerView() {
        let pickerView: UIPickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        categoryValue.inputView = pickerView // pickerView 추가
    }
    
    func dismissPickerView() {
        let pickerToolBar = UIToolbar()
        pickerToolBar.sizeToFit() // 서브뷰만큼 툴바 크기 맞춤
        pickerToolBar.isTranslucent = true // 툴바 반투명(true), 투명(false)
        let btnDone = UIBarButtonItem(title: "확인", style: .done, target: self, action: #selector(pickerDone))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        pickerToolBar.setItems([space, btnDone], animated: true) // 툴바에 버튼 추가
        pickerToolBar.isUserInteractionEnabled = true // 사용자 클릭 이벤트
        categoryValue.inputAccessoryView = pickerToolBar // picerkView 툴바 추가
    }
    
    @objc func pickerDone() {
        categoryValue.text = selectedCategory
        selectedCategory = ""
        self.view.endEditing(true)
        //categoryValue.resignFirstResponder() // 키보드 내려감
    }

    func createDatePicker() {
        //let DatePicker: UIDatePicker = UIDatePicker()
        dateValue.inputView = datePicker
    }
    
    func dismissDatePicker() {
        let dateToolBar = UIToolbar()
        dateToolBar.sizeToFit()
        dateToolBar.isTranslucent = true
        let btnDone = UIBarButtonItem(title: "확인", style: .done, target: self, action: #selector(dateDone))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        dateToolBar.setItems([space, btnDone], animated: true)
        dateToolBar.isUserInteractionEnabled = true
        dateValue.inputAccessoryView = dateToolBar
    }
    
    @objc func dateDone() {
        dateValue.text = "\(datePicker.date)"
        self.view.endEditing(true)
    }
    
    @IBAction func writeButton(_ sender: UIButton) {
        guard let title = titleValue.text, title.isEmpty == false else {
            showAlert(message: "빈칸을 채워주세요")
            return
        }
        guard let writer = writerValue.text, writer.isEmpty == false else {
            showAlert(message: "빈칸을 채워주세요")
            return
        }
        guard let category = categoryValue.text, category.isEmpty == false else {
            showAlert(message: "빈칸을 채워주세요")
            return
        }
        guard let date = dateValue.text, date.isEmpty == false else {
            showAlert(message: "빈칸을 채워주세요")
            return
        }
        guard let start = startValue.text, start.isEmpty == false else {
            showAlert(message: "빈칸을 채워주세요")
            return
        }
        guard let end = endValue.text, end.isEmpty == false else {
            showAlert(message: "빈칸을 채워주세요")
            return
        }
        guard let place = placeValue.text, place.isEmpty == false else {
            showAlert(message: "빈칸을 채워주세요")
            return
        }
        guard let content = contentValue.text, content.isEmpty == false else {
            showAlert(message: "빈칸을 채워주세요")
            return
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "알림",
                                      message: message,
                                      preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .cancel, handler: nil)
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
