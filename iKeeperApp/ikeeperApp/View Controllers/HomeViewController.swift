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
    let statusLabel = UILabel(frame: CGRect(x: 0, y: 400, width: 414, height: 40))
    var dataList = [[String: Any]]()
    var sideMenu: SideMenuNavigationController?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        calendarTableView.delegate = self
        calendarTableView.dataSource = self
        
        setNavigation()
        setSideMenu()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("viewWillAppear")
        dataList = [[String:Any]]()
        showCalendar()
    }
    
    func setNavigation() {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationController?.setToolbarHidden(false, animated: false)
    }
    
    func setSideMenu(){
        sideMenu = SideMenuNavigationController(rootViewController: MenuListController())
        sideMenu?.leftSide = false
        
        SideMenuManager.default.rightMenuNavigationController = sideMenu // 메뉴는 오른쪽
        SideMenuManager.default.addPanGestureToPresent(toView: self.view) // 메뉴에 스와이핑 제스처 추가
    }
    
    func showCalendar() {
        statusLabel.removeFromSuperview()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd"
        formatter.locale = Locale(identifier: "ko")
        let todayDate: String = formatter.string(from: Date())
        
        let db = Firestore.firestore()
        db.collection("calendar").whereField("date", isEqualTo: todayDate).getDocuments { (snapshot, error) in
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
    
    @IBAction func greaterButton(_ sender: UIButton) {
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
    var lists = ["마이페이지", "정보 게시판", "일정", "공금 내역", "로그아웃", "관리자페이지"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
            let mypageViewcontroller = storyboard.instantiateViewController(withIdentifier: Constants.Storyboard.mypageViewController)
            self.navigationController?.pushViewController(mypageViewcontroller, animated: true)
            
        case 1:
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let informationViewController = storyboard.instantiateViewController(withIdentifier: Constants.Storyboard.informationViewController)
            self.navigationController?.pushViewController(informationViewController, animated: true)
            
        case 2:
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let calendarViewController = storyboard.instantiateViewController(withIdentifier: Constants.Storyboard.calenderViewController)
            self.navigationController?.pushViewController(calendarViewController, animated: true)
            
        case 3:
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let publicMoneyViewcontroller = storyboard.instantiateViewController(withIdentifier: Constants.Storyboard.publicMoneyViewController)
            self.navigationController?.pushViewController(publicMoneyViewcontroller, animated: true)
            
        case 4:
            let firebaseAuth = Auth.auth()
            do {
                try firebaseAuth.signOut()
                transitionView()
            } catch let signOutError as NSError {
                print ("Error signing out: %@", signOutError)
            }
            
        case 5:
            print("admin")
            
        default:
            return
        }
    }
    
    func transitionView() {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: Constants.Storyboard.viewController)
        let rootViewController = UINavigationController(rootViewController: viewController)
        
        view.window?.rootViewController = rootViewController
        view.window?.makeKeyAndVisible()
    }
}
