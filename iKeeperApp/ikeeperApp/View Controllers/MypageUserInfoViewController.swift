//
//  MypageUserInfoViewController.swift
//  ikeeperApp
//
//  Created by 김혜진 on 2021/01/26.
//

import UIKit

class MypageUserInfoViewController: UIViewController {

    @IBOutlet weak var emailValue: UITextField!
    @IBOutlet weak var nameValue: UITextField!
    @IBOutlet weak var studentIDValue: UITextField!
    @IBOutlet weak var departmentValue: UITextField!
    @IBOutlet weak var gradeValue: UITextField!
    @IBOutlet weak var phoneNumberValue: UITextField!
    @IBOutlet weak var partControl: UISegmentedControl!
    @IBOutlet weak var statusControl: UISegmentedControl!
    @IBOutlet weak var editBarButton: UIBarButtonItem!
    @IBOutlet weak var completeButton: UIButton!
    let departmentPickerView: UIPickerView = UIPickerView()
    let gradePickerView: UIPickerView = UIPickerView()
    let departmentKinds = ["-- 선택 --", "컴퓨터소프트웨어학부", "컴퓨터공학전공", "스마트IoT전공", "사이버보안전공", "모바일소프트웨어전공"]
    let gradeKinds = ["-- 선택 --", "1", "2", "3", "4"]
    var selectedDepartment: String = ""
    var selectedGrade: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        completeButton.isHidden = true
        setDisabled()
        setValue()
        createPickerView()
        dismissPickerView()
    }

    func setEnabled() {
        //emailValue.isEnabled = false
        //nameValue.isEnabled = false
        //studentIDValue.isEnabled = false
        departmentValue.isEnabled = true
        gradeValue.isEnabled = true
        phoneNumberValue.isEnabled = true
        //partControl.isEnabled = false
        statusControl.isEnabled = true
    }
    
    func setDisabled() {
        emailValue.isEnabled = false
        nameValue.isEnabled = false
        studentIDValue.isEnabled = false
        departmentValue.isEnabled = false
        gradeValue.isEnabled = false
        phoneNumberValue.isEnabled = false
        partControl.isEnabled = false
        statusControl.isEnabled = false
    }
    
    func setValue() {
        
    }
    
    func createPickerView() {
        departmentPickerView.delegate = self
        departmentPickerView.dataSource = self
        gradePickerView.delegate = self
        gradePickerView.dataSource = self
        
        departmentValue.inputView = departmentPickerView
        gradeValue.inputView = gradePickerView
        
        departmentPickerView.tag = 1
        gradePickerView.tag = 2
    }
    
    func dismissPickerView() {
        let departmentPickerToolBar = UIToolbar()
        let gradePickerToolBar = UIToolbar()
        
        departmentPickerToolBar.sizeToFit()
        gradePickerToolBar.sizeToFit()
        
        departmentPickerToolBar.isTranslucent = true
        gradePickerToolBar.isTranslucent = true
        
        let departmentBtnDone = UIBarButtonItem(title: "확인", style: .done, target: self, action: #selector(departmentPickerDone))
        let gradeBtnDone = UIBarButtonItem(title: "확인", style: .done, target: self, action: #selector(gradePickerDone))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        
        departmentPickerToolBar.setItems([space, departmentBtnDone], animated: true)
        gradePickerToolBar.setItems([space, gradeBtnDone], animated: true)
        
        departmentPickerToolBar.isUserInteractionEnabled = true
        gradePickerToolBar.isUserInteractionEnabled = true
        
        departmentValue.inputAccessoryView = departmentPickerToolBar
        gradeValue.inputAccessoryView = gradePickerToolBar
    }
    
    @objc func departmentPickerDone() {
        departmentValue.text = selectedDepartment
        selectedDepartment = ""
        self.view.endEditing(true)
    }
    
    @objc func gradePickerDone() {
        gradeValue.text = selectedGrade
        selectedGrade = ""
        self.view.endEditing(true)
    }
    
    @IBAction func editBarButton(_ sender: UIBarButtonItem) {
        editBarButton.image = nil
        editBarButton.isEnabled = false
        completeButton.isHidden = false
        setEnabled()
    }
    
    @IBAction func completeButton(_ sender: UIButton) {
        editBarButton.image = UIImage(systemName: "pencil.slash")
        editBarButton.isEnabled = true
        completeButton.isHidden = true
        setDisabled()
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

extension MypageUserInfoViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case 1:
            return departmentKinds.count
        case 2:
            return gradeKinds.count
        default:
            return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
        case 1:
            return departmentKinds[row]
        case 2:
            return gradeKinds[row]
        default:
            return "Data not found"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 1 {
            if row != 0 {
                selectedDepartment = departmentKinds[row]
            } else {
                selectedDepartment = "" // "-- 선택 --" 선택하면
            }
        } else if pickerView.tag == 2 {
            if row != 0 {
                selectedGrade = gradeKinds[row]
            } else {
                selectedGrade = "" // "-- 선택 --" 선택하면
            }
        }
    }
}

