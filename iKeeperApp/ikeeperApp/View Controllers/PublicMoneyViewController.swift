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
    @IBOutlet weak var publicMoneyTableView: UITableView!
    let yearPickerView: UIPickerView = UIPickerView()
    let monthPickerView: UIPickerView = UIPickerView()
    let years = ["-- year --", "2018년", "2019년", "2020년", "2021년", "2022년"]
    let months = ["-- month --", "전체", "1월", "2월", "3월", "4월", "5월", "6월", "7월", "8월", "9월", "10월", "11월", "12월"]
    var dataList = [[String: Any]]()
    var selectedYear = ""
    var selectedMonth = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        publicMoneyTableView.delegate = self
        publicMoneyTableView.dataSource = self
        
        createPickerView()
        dismissPickerView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("viewWillAppear")
        dataList = [[String:Any]]()
        showPublicMoney()
    }
        
    func showPublicMoney() {
        let calendar = Calendar.current
        let year = calendar.component(.year, from: Date())
        let month = calendar.component(.month, from: Date())
        yearValue.text = "\(year)년"
        monthValue.text = "\(month)월"
        
        let db = Firestore.firestore()
        db.collection("publicMoney").whereField("year", isEqualTo: year).whereField("month", isEqualTo: month).getDocuments { (snapshot, error) in
            if error == nil && snapshot?.isEmpty == false {
                var temp: Int = 1
                for document in snapshot!.documents {
                    var documentData = document.data()
                    documentData["num"] = "\(temp)"
                    self.dataList.append(documentData)
                    temp += 1
                }
                print(self.dataList)
            } else {
                print("x")
            }
            self.publicMoneyTableView.reloadData()
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

extension PublicMoneyViewController: UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDelegate, UITableViewDataSource {

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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //cell은 as 키워드로 앞서 만든 CalendarCustomCell 클래스화
        let cell = tableView.dequeueReusableCell(withIdentifier: "PublicMoneyCustomCell", for: indexPath) as! PublicMoneyCustomCell
        
        // cell에 데이터 삽입
        let data = dataList[indexPath.row]
        cell.numLabel?.text = data["num"] as? String
        cell.categoryLabel?.text = data["category"] as? String
        cell.dateLabel?.text = data["date"] as? String
        cell.sumLabel?.text = data["sum"] as? String
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
//        let data = dataList[indexPath.row]
//        let calendarDetailViewController = self.storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.calendarDetailViewController) as! CalendarDetailViewController
//        calendarDetailViewController.dataList = data
//        self.navigationController?.pushViewController(calendarDetailViewController, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
