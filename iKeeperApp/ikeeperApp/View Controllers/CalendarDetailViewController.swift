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
    @IBOutlet weak var rightBarButton: UIBarButtonItem!
    @IBOutlet weak var completeButton: UIButton!
    let datePicker: UIDatePicker = UIDatePicker()
    let startPicker: UIDatePicker = UIDatePicker()
    let endPicker: UIDatePicker = UIDatePicker()
    let category = ["-- 선택 --","스터디", "세미나", "교육", "대회", "기타"]
    var selectedCategory:String = ""
    let formatter = DateFormatter()
    var dataList = [String: Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        completeButton.isHidden = true
        setDisabled()
        setValue()
        createPickerView()
        dismissPickerView()
        createDatePicker()
        dismissDatePicker()
        createStartPicker()
        dismissStartPicker()
        createEndPicker()
        dismissEndPicker()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setUser()
    }
    
    func setUser(){
        let user = Auth.auth().currentUser
        if user != nil {
            let uid: String = user!.uid
            let documentID: String = dataList["id"] as! String
            let db = Firestore.firestore()
            db.collection("calendar").whereField("id", isEqualTo: documentID).whereField("uid", isEqualTo: uid).getDocuments { (snapshot, error) in
                if error == nil && snapshot?.isEmpty == true {
                    db.collection("users").whereField("uid", isEqualTo: uid).whereField("permission", isEqualTo: true).getDocuments { (snapshot, error) in
                        if error == nil && snapshot?.isEmpty == true {
                            self.setBarButtonDisabled()
                        }
                    }
                }
            }
        } else {
            setBarButtonDisabled()
        }
    }
    
    func setBarButtonDisabled() {
        rightBarButton.image = nil
        rightBarButton.isEnabled = false
    }
    
    func setEnabled() {
        titleValue.isEnabled = true
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
        titleValue.text = dataList["title"] as? String
        writerValue.text = dataList["writer"] as? String
        categoryValue.text = dataList["category"] as? String
        dateValue.text = dataList["date"] as? String
        startValue.text = dataList["startTime"] as? String
        endValue.text = dataList["endTime"] as? String
        placeValue.text = dataList["place"] as? String
        contentValue.text = dataList["content"] as? String
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
    
    @IBAction func rightBarButton(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "기능 선택", message: nil, preferredStyle: .actionSheet)
        let modify = UIAlertAction(title: "수정", style: .default) { (action) in
            self.rightBarButton.image = nil
            self.rightBarButton.isEnabled = false
            self.completeButton.isHidden = false
            self.setEnabled()
        }
        let delete = UIAlertAction(title: "삭제", style: .destructive) { (action) in
            let id = self.dataList["id"] as! String
            self.showAlertForDelete(id: id)
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alert.addAction(modify)
        alert.addAction(delete)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
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
        
        let modifyData = ["title": title, "category":category, "date": date, "startTime": startTime, "endTime": endTime, "place": place, "content": content]
        let id = dataList["id"] as! String
        print(modifyData, id)
        
        let db = Firestore.firestore()
        db.collection("calendar").document("\(id)").updateData(modifyData) { (error) in
            if error != nil {
                print("check for error : \(error!.localizedDescription)")
            } else {
                self.showAlertModifyOrDelete(title: "수정 완료", message: "일정 수정이 완료되었습니다")
            }
        }
        rightBarButton.image = UIImage(systemName: "pencil.slash")
        rightBarButton.isEnabled = true
        completeButton.isHidden = true
        setDisabled()
    }
    
    func showAlertForDelete(id: String) {
        let alert = UIAlertController(title: "일정 삭제",
                                      message: "일정을 삭제하시겠습니까?",
                                      preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: "확인", style: .default) { (action) in
            let db = Firestore.firestore()
            db.collection("calendar").document("\(id)").delete { (error) in
                if error != nil {
                    print("check for error : \(error!.localizedDescription)")
                } else {
                    self.showAlertModifyOrDelete(title: "삭제 완료", message: "일정 삭제가 완료되었습니다")
                }
            }
        }
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func showAlertModifyOrDelete(title: String, message: String) {
        let alert = UIAlertController(title: title,
                                      message: message,
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

extension CalendarDetailViewController: UIPickerViewDelegate, UIPickerViewDataSource {
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
}
