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
    let statusLabel = UILabel(frame: CGRect(x: 0, y: 160, width: 414, height: 40))
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
        statusLabel.removeFromSuperview()
        
        let calendar = Calendar.current
        let year = calendar.component(.year, from: Date())
        let month = calendar.component(.month, from: Date())
        selectedYear = "\(year)년"
        selectedMonth = "\(month)월"
        yearValue.text = "\(year)년"
        monthValue.text = "\(month)월"
        
        let db = Firestore.firestore()
        db.collection("publicMoney").whereField("year", isEqualTo: year).whereField("month", isEqualTo: month).order(by: "day", descending: false).order(by: "created", descending: false).getDocuments { (snapshot, error) in
            if error == nil && snapshot?.isEmpty == false {
                var temp: Int = 1
                for document in snapshot!.documents {
                    var documentData = document.data()
                    documentData["num"] = "\(temp)"
                    self.dataList.append(documentData)
                    temp += 1
                }
            } else {
                self.statusLabel.textAlignment = .center
                self.statusLabel.text = "공금내역이 없습니다."
                self.view.addSubview(self.statusLabel)
            }
            self.publicMoneyTableView.reloadData()
        }
    }
    
    func selectPublicMoney() {
        dataList = [[String:Any]]()
        statusLabel.removeFromSuperview()
        
        let db = Firestore.firestore()
        let year:Int = Int(selectedYear.trimmingCharacters(in: ["년"]))!
        
        if selectedMonth == "전체" {
            db.collection("publicMoney").whereField("year", isEqualTo: year).order(by: "month", descending: false).order(by: "day", descending: false).order(by: "created", descending: false).getDocuments { (snapshot, error) in
                if error == nil && snapshot?.isEmpty == false {
                    var temp: Int = 1
                    for document in snapshot!.documents {
                        var documentData = document.data()
                        documentData["num"] = "\(temp)"
                        self.dataList.append(documentData)
                        temp += 1
                    }
                } else if error == nil && snapshot?.isEmpty == true {
                    self.statusLabel.textAlignment = .center
                    self.statusLabel.text = "공금내역이 없습니다."
                    self.view.addSubview(self.statusLabel)
                }
                self.publicMoneyTableView.reloadData()
            }
        } else {
            let month:Int = Int(selectedMonth.trimmingCharacters(in: ["월"]))!
            db.collection("publicMoney").whereField("year", isEqualTo: year).whereField("month", isEqualTo: month).order(by: "day", descending: false).order(by: "created", descending: false).getDocuments { (snapshot, error) in
                if error == nil && snapshot?.isEmpty == false {
                    var temp: Int = 1
                    for document in snapshot!.documents {
                        var documentData = document.data()
                        documentData["num"] = "\(temp)"
                        self.dataList.append(documentData)
                        temp += 1
                    }
                } else {
                    self.statusLabel.textAlignment = .center
                    self.statusLabel.text = "공금내역이 없습니다."
                    self.view.addSubview(self.statusLabel)
                }
                self.publicMoneyTableView.reloadData()
                
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
        if selectedYear != "" && selectedMonth != "" {
            print("not empty")
            selectPublicMoney()
        } else if selectedYear == "" {
            showAlert(message: "연도를 선택하세요")
            dataList = [[String:Any]]()
            statusLabel.removeFromSuperview()
            self.publicMoneyTableView.reloadData()
        }
        self.view.endEditing(true)
    }
    
    @objc func monthPickerDone() {
        monthValue.text = selectedMonth
        if selectedYear != "" && selectedMonth != "" {
            print("not empty")
            selectPublicMoney()
        } else if selectedMonth == "" {
            showAlert(message: "월을 선택하세요")
            dataList = [[String:Any]]()
            statusLabel.removeFromSuperview()
            self.publicMoneyTableView.reloadData()
        }
        self.view.endEditing(true)
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
        //cell은 as 키워드로 앞서 만든 PublicMoneyCustomCell 클래스화
        let cell = tableView.dequeueReusableCell(withIdentifier: "PublicMoneyCustomCell", for: indexPath) as! PublicMoneyCustomCell
        
        // cell에 데이터 삽입
        let data = dataList[indexPath.row]
        cell.numLabel?.text = data["num"] as? String
        cell.categoryLabel?.text = data["category"] as? String
        cell.dateLabel?.text = data["history date"] as? String
        cell.amountLabel?.text = data["amount"] as? String
        cell.sumLabel?.text = data["sum"] as? String
        cell.memoLabel?.text = data["memo"] as? String
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let data = dataList[indexPath.row]
        let publicMoneyDetailViewController = self.storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.publicMoneyDetailViewController) as! PublicMoneyDetailViewController
        publicMoneyDetailViewController.dataList = data
        self.navigationController?.pushViewController(publicMoneyDetailViewController, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
