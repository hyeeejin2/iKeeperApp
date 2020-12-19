//
//  CalendarWriteViewController.swift
//  ikeeperApp
//
//  Created by 김혜진 on 2020/11/13.
//

import UIKit
import Firebase
import FirebaseAuth

class CalendarWriteViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var titleValue: UITextField!
    @IBOutlet weak var writerValue: UITextField!
    @IBOutlet weak var categoryValue: UITextField!
    @IBOutlet weak var dateValue: UITextField!
    @IBOutlet weak var startValue: UITextField!
    @IBOutlet weak var endValue: UITextField!
    @IBOutlet weak var placeValue: UITextField!
    @IBOutlet weak var contentValue: UITextField!
    //let writer: String = ""
    let datePicker: UIDatePicker = UIDatePicker()
    let startPicker: UIDatePicker = UIDatePicker()
    let endPicker: UIDatePicker = UIDatePicker()
    let category = ["-- 선택 --","스터디", "세미나", "교육", "대회", "기타"]
    var selectedCategory:String = ""
    let formatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //userSetting()
        createPickerView()
        dismissPickerView()
        createDatePicker()
        dismissDatePicker()
        createStartPicker()
        dismissStartPicker()
        createEndPicker()
        dismissEndPicker()
    }
    
    func userSetting() {
        let user = Auth.auth().currentUser
        writerValue?.text = user?.displayName
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
        if row != 0 {
            selectedCategory = category[row]
        } else {
            selectedCategory = "" // "-- 선택 --" 선택하면
        }
    }
    
    // pickerView
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

    // datePicker - date
    func createDatePicker() {
        if #available(iOS 13.4, *) {
                datePicker.preferredDatePickerStyle = .wheels
        }
        datePicker.datePickerMode = .date
        datePicker.locale = NSLocale(localeIdentifier: "ko_KO") as Locale // 한글로 변환
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
        formatter.dateFormat = "YYYY-MM-dd"
        let dateString = formatter.string(from: datePicker.date)
        dateValue.text = "\(dateString)"
        self.view.endEditing(true)
    }
    
    // datePicker - time(start)
    func createStartPicker() {
        if #available(iOS 13.4, *) {
                startPicker.preferredDatePickerStyle = .wheels
        }
        startPicker.datePickerMode = .time
        //startPicker.locale = NSLocale(localeIdentifier: "ko_KO") as Locale
        startValue.inputView = startPicker
    }
    
    func dismissStartPicker() {
        let startToolBar = UIToolbar()
        startToolBar.sizeToFit()
        startToolBar.isTranslucent = true
        let btnDone = UIBarButtonItem(title: "확인", style: .done, target: self, action: #selector(startDone))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        startToolBar.setItems([space, btnDone], animated: true)
        startToolBar.isUserInteractionEnabled = true
        startValue.inputAccessoryView = startToolBar
    }
    
    @objc func startDone() {
        formatter.dateFormat = "hh:mm a"
        let startString = formatter.string(from: startPicker.date)
        startValue.text = "\(startString)"
        self.view.endEditing(true)
    }
    
    // datePicker - time(end)
    func createEndPicker() {
        if #available(iOS 13.4, *) {
                endPicker.preferredDatePickerStyle = .wheels
        }
        endPicker.datePickerMode = .time
        //endPicker.locale = NSLocale(localeIdentifier: "ko_KO") as Locale
        endValue.inputView = endPicker
    }
    
    func dismissEndPicker() {
        let endToolBar = UIToolbar()
        endToolBar.sizeToFit()
        endToolBar.isTranslucent = true
        let btnDone = UIBarButtonItem(title: "확인", style: .done, target: self, action: #selector(endDone))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        endToolBar.setItems([space, btnDone], animated: true)
        endToolBar.isUserInteractionEnabled = true
        endValue.inputAccessoryView = endToolBar
    }
    
    @objc func endDone() {
        formatter.dateFormat = "hh:mm a"
        let endString = formatter.string(from: endPicker.date)
        endValue.text = "\(endString)"
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
        
        let db = Firestore.firestore()
        let newDocument = db.collection("calendar").document()
        newDocument.setData(["id": newDocument.documentID,"title": title, "writer": writer, "category": category, "date": date, "startTime": start, "endTime": end, "place": place, "content": content]) { (error) in
            
            if error != nil {
                print("check for error : \(error!.localizedDescription)")
                self.showAlert(message: "일정 등록 실패")
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
