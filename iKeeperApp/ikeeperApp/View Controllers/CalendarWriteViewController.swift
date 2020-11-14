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
    @IBOutlet weak var placeValue: UITextField!
    @IBOutlet weak var contentValue: UITextField!
    let category = ["동아리", "외부"]
    let clubCategory = ["스터디", "세미나", "교육", "대회", "기타"]
    let externalCategory = ["세미나", "교육", "대회", "기타"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        createPickerView()
        dismissPickerView()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func writeButton(_ sender: UIButton) {
        print("write")
        self.navigationController?.popViewController(animated: true)
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
        categoryValue.text = category[row]
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
        let btnDone = UIBarButtonItem(title: "확인", style: .plain, target: self, action: #selector(pickerDone))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let btnCancel = UIBarButtonItem(title: "취소", style: .done, target: self, action: #selector(pickerCancel))
        pickerToolBar.setItems([btnCancel, space, btnDone], animated: true) // 툴바에 버튼 추가
        pickerToolBar.isUserInteractionEnabled = true // 사용자 클릭 이벤트
        categoryValue.inputAccessoryView = pickerToolBar // picerkView 툴바 추가
    }
    
    @objc func pickerDone(_sender: Any) {
        self.view.endEditing(true)
    }
    @objc func pickerCancel() {
        self.view.endEditing(true)
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
