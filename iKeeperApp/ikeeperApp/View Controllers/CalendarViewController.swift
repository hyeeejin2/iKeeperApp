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
    @IBOutlet weak var calendarTableView: UITableView!
    var dataList = [[String: Any]]()
    var numbering = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        calendarTableView.delegate = self
        calendarTableView.dataSource = self
        calendar.dataSource = self
        calendar.delegate = self
        
        todayCalender()
        calendarSetting()
    }
    
    func todayCalender() {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd"
        formatter.locale = Locale(identifier: "ko")
        let currentDate = formatter.string(from: Date())

        let db = Firestore.firestore()
        db.collection("calendar").whereField("date", isEqualTo: currentDate).getDocuments { (snapshot, error) in
            if error == nil && snapshot != nil {
                for document in snapshot!.documents {
                    var documentData = document.data()
                    documentData["num"] = "\(self.numbering)"
                    //print("documentData", documentData)
                    self.dataList.append(documentData)
                    print("dataList", self.dataList)
                    self.numbering += 1
                }
                self.calendarTableView.reloadData() // 속도가 tableview setting > firebase로 데이터 읽기 이므로 데이터를 다시 reload
                self.numbering = 1 // 초기화
            }
        }
    }
    
    func calendarSetting() {
        calendar.allowsMultipleSelection = false // 날짜 여러 개 선택
        calendar.swipeToChooseGesture.isEnabled = false // 스와이프로 다중 선택
        calendar.scrollEnabled = true // 스와이프 스크롤 작동
        calendar.scrollDirection = .horizontal // 스와이프 스크롤 방향(가로)
        
        calendar.appearance.weekdayTextColor = UIColor.black
        calendar.appearance.titleWeekendColor = UIColor.gray
        calendar.appearance.selectionColor = UIColor.blue
        calendar.appearance.todayColor = UIColor.orange
        calendar.appearance.todaySelectionColor = UIColor.black
        
        calendar.appearance.headerTitleColor = UIColor.red
        calendar.appearance.eventDefaultColor = UIColor.green
        calendar.appearance.headerMinimumDissolvedAlpha = 0.0 // 이전, 다음달 표시
        calendar.appearance.headerDateFormat = "YYYY년 M월" // 헤더 데이터 형식
        calendar.locale = Locale(identifier: "ko_KR")
        
        //calendar.headerHeight = 50
        //calendar.appearance.headerTitleFont = UIFont.systemFont(ofSize: 24)
    }
}

extension CalendarViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("何が問題かな。。私は知らない")
        
        //cell은 as 키워드로 앞서 만든 CalendarCustomCell 클래스화
        let cell = tableView.dequeueReusableCell(withIdentifier: "CalendarCustomCell", for: indexPath) as! CalendarCustomCell
        
        // cell에 데이터 삽입
        let data = dataList[indexPath.row]
        cell.numLabel?.text = data["num"] as? String
        cell.titleLabel?.text = data["title"] as? String
        cell.writerLabel?.text = data["writer"] as? String
        cell.placeLabel?.text = data["place"] as? String
        cell.startLabel?.text = data["startTime"] as? String
        cell.endLabel?.text = data["endTime"] as? String
        cell.contentLabel?.text = data["content"] as? String
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print("select")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
