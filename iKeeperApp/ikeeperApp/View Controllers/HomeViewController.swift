//
//  HomeViewController.swift
//  ikeeperApp
//
//  Created by 김혜진 on 2020/11/08.
//

import UIKit
import SideMenu
import Firebase
import FirebaseAuth

class HomeViewController: UIViewController {
    
    @IBOutlet weak var calendarTableView: UITableView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var menuBarButton: UIBarButtonItem!
    let statusLabel = UILabel(frame: CGRect(x: 0, y: 400, width: 414, height: 40))
    //let pink = UIColor(red: 243/255.0, green: 148/255.0, blue: 173/255.0, alpha: 1)
    var dataList = [[String: Any]]()
    var sideMenu: SideMenuNavigationController?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        calendarTableView.delegate = self
        calendarTableView.dataSource = self
        
        setSideMenu()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        dataList = [[String:Any]]()
        showCalendar()
        setUser()
    }
    
//    func setNavigation() {
//        self.navigationController?.setNavigationBarHidden(false, animated: false)
//        self.navigationController?.setToolbarHidden(false, animated: false)
//    }
    
    func setSideMenu(){
        sideMenu = SideMenuNavigationController(rootViewController: MenuListController())
        sideMenu?.leftSide = false
        //sideMenu?.navigationBar.barTintColor = pink
        //sideMenu?.setNavigationBarHidden(true, animated: false)
        
        SideMenuManager.default.rightMenuNavigationController = sideMenu // 메뉴는 오른쪽
        SideMenuManager.default.addPanGestureToPresent(toView: self.view) // 메뉴에 스와이핑 제스처 추가
        sideMenu?.statusBarEndAlpha = 0.0 // 상태바 보이게
        sideMenu?.presentationStyle = .menuSlideIn
        
    }
    
    func setUser() {
        let user = Auth.auth().currentUser
        if user != nil {
            menuBarButton.title = ""
            menuBarButton.image = nil
            menuBarButton.isEnabled = false
            
            let uid: String = user!.uid
            let db = Firestore.firestore()
            db.collection("users").whereField("uid", isEqualTo: uid).getDocuments { (snapshot, error) in
                if error == nil && snapshot?.isEmpty == false {
                    for document in snapshot!.documents {
                        let documentData = document.data()
                        print(documentData)
                        let userName = documentData["name"] as! String
                        self.sideMenu?.navigationBar.topItem?.title = "\(userName)님"
                    }
                }
            }
        } else {
            menuBarButton.title = "menu"
            menuBarButton.image = UIImage(systemName: "text.justify")
            menuBarButton.isEnabled = true
            sideMenu?.navigationBar.topItem?.title = "환영합니다."
        }
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
                var temp: Int = 1
                for document in snapshot!.documents {
                    var documentData = document.data()
                    documentData["num"] = "\(temp)"
                    self.dataList.append(documentData)
                    temp += 1
                }
            } else if error == nil && snapshot?.isEmpty == true {
                self.statusLabel.textAlignment = .center
                self.statusLabel.text = "오늘은 일정이 없습니다."
                self.view.addSubview(self.statusLabel)
            }
            self.calendarTableView.reloadData()
        }
    }
    
    @IBAction func menuButton(_ sender: UIButton) {
        present(sideMenu!, animated: true)
    }
    
    @IBAction func moreButton(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let calendarViewController = storyboard.instantiateViewController(withIdentifier: Constants.Storyboard.calenderViewController)
        self.navigationController?.pushViewController(calendarViewController, animated: true)
    } 
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //cell은 as 키워드로 앞서 만든 HomeCalendarCustomCell 클래스화
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCalendarCustomCell", for: indexPath) as! HomeCalendarCustomCell
        
        // cell에 데이터 삽입
        let data = dataList[indexPath.row]
        cell.numLabel?.text = data["num"] as? String
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
    //let pink = UIColor(red: 243/255.0, green: 148/255.0, blue: 173/255.0, alpha: 1)
    let lists = ["로그인", "회원가입"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //tableView.backgroundColor = pink
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lists.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = lists[indexPath.row]
        //cell.textLabel?.textColor = .black
        //cell.backgroundColor = pink
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
            let signupViewController = storyboard.instantiateViewController(withIdentifier: Constants.Storyboard.signUpViewController)
            self.navigationController?.pushViewController(signupViewController, animated: true)
        default:
            return
        }
    }
}


//tabBarController?.delegate = self
//extension ViewController: UITabBarControllerDelegate {
//// excute when the tab is selected
//func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
//    print("tab!!")
//}
//}
