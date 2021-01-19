//
//  CalendarViewController.swift
//  ikeeperApp
//
//  Created by 김혜진 on 2020/11/08.
//

import UIKit
import FSCalendar
import Firebase

class CalendarViewController: UIViewController, FSCalendarDataSource, FSCalendarDelegate {
    
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var calendarTableView: UITableView!
    let formatter = DateFormatter()
    var dataList = [[String: Any]]()
    var scheduleDate: Set<String> = []
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        calendarTableView.delegate = self
        calendarTableView.dataSource = self
        calendar.dataSource = self
        calendar.delegate = self
        
        calendarTableView.isHidden = true
        statusLabel.text = ""
        
        setCalendar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("viewWillAppear")
        dataList = [[String:Any]]()
        scheduleDate = []
        eventDate()
        todayCalender()
        deselectDate()
    }
    
    func setCalendar() {
        calendar.allowsMultipleSelection = false // 날짜 여러 개 선택
        calendar.swipeToChooseGesture.isEnabled = false // 스와이프로 다중 선택
        calendar.scrollEnabled = true // 스와이프 스크롤 작동
        calendar.scrollDirection = .horizontal // 스와이프 스크롤 방향(가로)
        
        calendar.appearance.headerTitleColor = UIColor.black
        calendar.appearance.weekdayTextColor = UIColor.systemPink
        calendar.appearance.titleWeekendColor = UIColor.gray
        calendar.appearance.selectionColor = UIColor.black
        calendar.appearance.todayColor = UIColor.systemPink
        calendar.appearance.todaySelectionColor = UIColor.gray
        
        calendar.appearance.eventDefaultColor = UIColor.systemTeal
        calendar.appearance.headerMinimumDissolvedAlpha = 0.0 // 이전, 다음달 표시
        calendar.appearance.headerDateFormat = "YYYY년 M월" // 헤더 데이터 형식
        calendar.locale = Locale(identifier: "ko_KR")
        
        //calendar.headerHeight = 50
        //calendar.appearance.headerTitleFont = UIFont.systemFont(ofSize: 24)
    }
    
    func eventDate() {
        let db = Firestore.firestore()
        db.collection("calendar").getDocuments { (snapshot, error) in
            if error == nil && snapshot?.isEmpty == false {
                for document in snapshot!.documents {
                    let documentData = document.data()
                    self.scheduleDate.insert(documentData["date"] as! String)
                }
                self.calendar.reloadData()
            }
        }
    }
    
    func todayCalender() {
        formatter.dateFormat = "YYYY-MM-dd"
        formatter.locale = Locale(identifier: "ko")
        let currentDate: String = formatter.string(from: Date())
        showCalendar(date: currentDate)
    }
    
    func showCalendar(date: String) {
        let db = Firestore.firestore()
        db.collection("calendar").whereField("date", isEqualTo: date).order(by: "created", descending: true).getDocuments { (snapshot, error) in
            if error == nil && snapshot?.isEmpty == false {
                self.calendarTableView.isHidden = false
                var temp: Int = 1
                for document in snapshot!.documents {
                    var documentData = document.data()
                    documentData["num"] = "\(temp)"
                    self.dataList.append(documentData)
                    temp += 1
                }
                self.statusLabel.text = "✓ \(self.dataList.count)개의 일정이 있습니다."
                self.calendarTableView.reloadData() // 속도가 tableview setting > firebase로 데이터 읽기 이므로 데이터를 다시 reload
            } else if error == nil && snapshot?.isEmpty == true {
                self.statusLabel.isHidden = false
                self.calendarTableView.isHidden = true
                self.statusLabel.text = "X 오늘 일정은 없습니다."
            }
        }
    }
    
    func numbering() {
        var temp: Int = 1
        for i in 0..<dataList.count {
            dataList[i]["num"] = "\(temp)"
            temp += 1
        }
    }
    
    func deselectDate() {
        guard calendar.selectedDate == nil else {
            calendar.deselect(calendar.selectedDate!)
            return
        }
    }
    
//    func showAlert(message: String) {
//        let alert = UIAlertController(title: "알림",
//                                      message: message,
//                                      preferredStyle: .alert)
//        let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
//        let cancelAction = UIAlertAction(title: "취소", style: .destructive, handler: nil)
//        alert.addAction(cancelAction)
//        alert.addAction(okAction)
//        self.present(alert, animated: true, completion: nil)
//    }
}
    
extension CalendarViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //cell은 as 키워드로 앞서 만든 CalendarCustomCell 클래스화
        let cell = tableView.dequeueReusableCell(withIdentifier: "CalendarCustomCell", for: indexPath) as! CalendarCustomCell
        
        // cell에 데이터 삽입
        let data = dataList[indexPath.row]
        cell.categoryLabel?.text = data["category"] as? String
        cell.numLabel?.text = data["num"] as? String
        cell.titleLabel?.text = data["title"] as? String
        cell.writerLabel?.text = data["writer"] as? String
        cell.placeLabel?.text = data["place"] as? String
        cell.startLabel?.text = data["startTime"] as? String
        cell.endLabel?.text = data["endTime"] as? String
        cell.contentLabel?.text = data["content"] as? String
        
        cell.deleteButton.tag = indexPath.row
        cell.deleteButton.addTarget(self, action: #selector(deleteCalendar(_:)), for: .touchUpInside)
        print(cell.deleteButton.tag)
        return cell
    }
    
    @objc func deleteCalendar(_ sender: UIButton) {
        let date = dataList[sender.tag]["date"] as! String
        let id = dataList[sender.tag]["id"] as! String
        
        let db = Firestore.firestore()
        db.collection("calendar").document("\(id)").delete { (error) in
            if error != nil {
                print("check for error : \(error!.localizedDescription)")
            } else {
                self.dataList.remove(at: sender.tag)
                if self.dataList.count > 0 {
                    self.numbering()
                    self.statusLabel.text = "✓ \(self.dataList.count)개의 일정이 있습니다."
                    self.calendarTableView.reloadData()
                } else {
                    self.statusLabel.isHidden = false
                    self.calendarTableView.isHidden = true
                    self.statusLabel.text = "X 오늘 일정은 없습니다."
                    self.scheduleDate.remove(date)
                    self.calendar.reloadData()
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let data = dataList[indexPath.row]
        let calendarDetailViewController = self.storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.calendarDetailViewController) as! CalendarDetailViewController
        calendarDetailViewController.dataList = data
        self.navigationController?.pushViewController(calendarDetailViewController, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        dataList = [[String: Any]]()
        formatter.dateFormat = "YYYY-MM-dd"
        let selectedDate: String = formatter.string(from: date)
        print(selectedDate)
        showCalendar(date: selectedDate)
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        let dateToString: String = formatter.string(from: date)
        
        if scheduleDate.contains(dateToString){
            return 1
        }
        return 0
    }
    
}
