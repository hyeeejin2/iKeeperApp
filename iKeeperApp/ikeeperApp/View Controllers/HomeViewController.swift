//
//  HomeViewController.swift
//  ikeeperApp
//
//  Created by 김혜진 on 2020/11/08.
//

import UIKit
import SideMenu
import Firebase

class HomeViewController: UIViewController {
    
    @IBOutlet weak var calendarTableView: UITableView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var adminBarButton: UIBarButtonItem!
    @IBOutlet weak var menuBarButton: UIBarButtonItem!
    let statusLabel = UILabel(frame: CGRect(x: 0, y: 410, width: 414, height: 40))
    var dataList = [[String: Any]]()
    var sideMenu: SideMenuNavigationController?
    var numbering: Int = 1

    override func viewDidLoad() {
        super.viewDidLoad()
        
        calendarTableView.delegate = self
        calendarTableView.dataSource = self
        
        setSideMenu()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        dataList = [[String:Any]]()
        numbering = 1
        setBarButton()
        showCalendar()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        calendarTableView.layoutIfNeeded()
    }
    
    func setBarButton() {
        let user = Auth.auth().currentUser
        if user != nil {
            let uid: String = user!.uid
            let db = Firestore.firestore()
            db.collection("users").whereField("uid", isEqualTo: uid).getDocuments { (snapshot, error) in
                if error == nil && snapshot?.isEmpty == false {
                    for document in snapshot!.documents {
                        let documentData = document.data()
                        let permission = documentData["permission"] as! Bool
                        if permission {
                            self.adminBarButton.image = UIImage(systemName: "gearshape.fill")
                            self.adminBarButton.isEnabled = true
                            self.menuBarButton.image = nil
                            self.menuBarButton.isEnabled = false
                        } else {
                            self.adminBarButton.image = nil
                            self.adminBarButton.isEnabled = false
                            self.menuBarButton.image = nil
                            self.menuBarButton.isEnabled = false
                        }
                    }
                }
            }
        } else {
            adminBarButton.image = nil
            adminBarButton.isEnabled = false
            menuBarButton.image = UIImage(systemName: "text.justify")
            menuBarButton.isEnabled = true
            sideMenu?.navigationBar.topItem?.title = "환영합니다."
        }
    }
    
    func setSideMenu(){
        sideMenu = SideMenuNavigationController(rootViewController: MenuListController())
        sideMenu?.leftSide = false
        sideMenu?.navigationBar.barTintColor = .white
        
        SideMenuManager.default.rightMenuNavigationController = sideMenu // 메뉴는 오른쪽
        SideMenuManager.default.addPanGestureToPresent(toView: self.view) // 메뉴에 스와이핑 제스처 추가
        sideMenu?.statusBarEndAlpha = 0.0 // 상태바 보이게
        sideMenu?.presentationStyle = .menuSlideIn
        
    }
    
    func showCalendar() {
        statusLabel.removeFromSuperview()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd"
        formatter.locale = Locale(identifier: "ko")
        let todayDate: String = formatter.string(from: Date())
        
        dateLabel.text = "\(todayDate) 일정"
        dateLabel.textAlignment = .center
        
        let db = Firestore.firestore()
        db.collection("calendar").whereField("date", isEqualTo: todayDate).order(by: "created", descending: true).getDocuments { (snapshot, error) in
            if error == nil && snapshot?.isEmpty == false {
                for document in snapshot!.documents {
                    let documentData = document.data()
                    self.dataList.append(documentData)
                }
            } else if error == nil && snapshot?.isEmpty == true {
                self.statusLabel.textAlignment = .center
                self.statusLabel.text = "오늘은 일정이 없습니다."
                self.view.addSubview(self.statusLabel)
            }
            self.calendarTableView.reloadData()
        }
    }
    
    @IBAction func adminBarButton(_ sender: UIBarButtonItem) {
        let adminViewController = self.storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.adminViewController) as! AdminViewController
        self.navigationController?.pushViewController(adminViewController, animated: true)
    }
    
    @IBAction func menuBarButton(_ sender: UIBarButtonItem) {
        present(sideMenu!, animated: true)
    }
    
    @IBAction func moreButton(_ sender: UIButton) {
        self.tabBarController?.selectedIndex = 2
    } 
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 43
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //cell은 as 키워드로 앞서 만든 HomeCalendarCustomCell 클래스화
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCalendarCustomCell", for: indexPath) as! HomeCalendarCustomCell
        
        // cell에 데이터 삽입
        let data = dataList[indexPath.row]
        cell.numLabel?.text = String(numbering)
        numbering += 1
        cell.titleLabel?.text = data["title"] as? String
        cell.categoryLabel?.text = data["category"] as? String
        cell.writerLabel?.text = data["writer"] as? String
        return cell
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
}

class MenuListController: UITableViewController {
    let lists = ["로그인", "회원가입"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = .white
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lists.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = lists[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        switch indexPath.row {
        case 0:
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let loginViewcontroller = storyboard.instantiateViewController(withIdentifier: Constants.Storyboard.loginViewController)
            self.navigationController?.pushViewController(loginViewcontroller, animated: true)
            
        case 1:
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let signupViewController = storyboard.instantiateViewController(withIdentifier:Constants.Storyboard.signUpViewController)
            self.navigationController?.pushViewController(signupViewController, animated: true)
        default:
            return
        }
    }
}
