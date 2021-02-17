//
//  MypageWrittenCalendarViewController.swift
//  ikeeperApp
//
//  Created by 김혜진 on 2021/01/27.
//

import UIKit
import Firebase

class MypageWrittenCalendarViewController: UIViewController {

    @IBOutlet weak var editBarButton: UIBarButtonItem!
    @IBOutlet weak var calendarListTableView: UITableView!
    let statusLabel = UILabel(frame: CGRect(x: 0, y: 95, width: 414, height: 40))
    var dataList = [[String: Any]]()
    var numbering: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        calendarListTableView.delegate = self
        calendarListTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        dataList = [[String:Any]]()
        numbering = 1
        setUser()
    }
    
    func setUser() {
        let user = Auth.auth().currentUser
        if user != nil {
            getList()
        } else {
            editBarButton.image = nil
            editBarButton.isEnabled = false
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func getList() {
        statusLabel.removeFromSuperview()
        
        let user = Auth.auth().currentUser
        let uid: String = user!.uid
        let db = Firestore.firestore()
        db.collection("calendar").whereField("uid", isEqualTo: uid).order(by: "created", descending: true).getDocuments { (snapshot, error) in
            if error == nil && snapshot?.isEmpty == false {
                for document in snapshot!.documents {
                    let documentData = document.data()
                    self.dataList.append(documentData)
                }
                self.editBarButton.image = UIImage(systemName: "pencil.slash")
                self.editBarButton.isEnabled = true
            } else if error == nil && snapshot?.isEmpty == true {
                self.statusLabel.textAlignment = .center
                self.statusLabel.text = "아직 작성한 글이 없습니다."
                self.view.addSubview(self.statusLabel)
                self.editBarButton.image = nil
                self.editBarButton.isEnabled = false
            }
            self.calendarListTableView.reloadData()
        }
    }
    
    @IBAction func editBarButton(_ sender: UIBarButtonItem) {
        if calendarListTableView.isEditing {
            calendarListTableView.isEditing = false
            editBarButton.image = UIImage(systemName: "pencil.slash")
        } else {
            calendarListTableView.isEditing = true
            editBarButton.image = UIImage(systemName: "checkmark.circle")
        }
    }
}

extension MypageWrittenCalendarViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // cell은 as 키워드로 앞서 만든 MypageCalendarListCustomCell 클래스화
        let cell = tableView.dequeueReusableCell(withIdentifier: "MypageCalendarListCustomCell", for: indexPath) as! MypageCalendarListCustomCell

        // cell에 데이터 삽입
        let data = dataList[indexPath.row]
        cell.numLabel?.text = String(numbering)
        numbering += 1
        cell.categoryLabel?.text = data["category"] as? String
        cell.titleLabel?.text = data["title"] as? String
        cell.placeLabel?.text = data["place"] as? String
        cell.startLabel?.text = data["startTime"] as? String
        cell.endLabel?.text = data["endTime"] as? String
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let data = dataList[indexPath.row]
        let calendarDetailViewController = self.storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.calendarDetailViewController) as! CalendarDetailViewController
        calendarDetailViewController.dataList = data
        self.navigationController?.pushViewController(calendarDetailViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            let data = dataList[indexPath.row]
            let id = data["id"] as! String
            
            let db = Firestore.firestore()
            db.collection("calendar").document("\(id)").delete { (error) in
                if error != nil {
                    print("check for error : \(error!.localizedDescription)")
                } else {
                    self.numbering = 1
                    self.dataList.remove(at: indexPath.row)
                    self.calendarListTableView.deleteRows(at: [indexPath], with: .automatic)
                    if self.dataList.count == 0 {
                        self.statusLabel.textAlignment = .center
                        self.statusLabel.text = "아직 작성한 글이 없습니다."
                        self.view.addSubview(self.statusLabel)
                        self.calendarListTableView.isEditing = false
                        self.editBarButton.image = nil
                        self.editBarButton.isEnabled = false
                    }
                    self.calendarListTableView.reloadData()
                }
            }
        }
    }
}
