//
//  HomeViewController.swift
//  ikeeperApp
//
//  Created by 김혜진 on 2020/11/08.
//

import UIKit
import SideMenu

class HomeViewController: UIViewController {
    
    var sideMenu: SideMenuNavigationController?

    override func viewDidLoad() {
        super.viewDidLoad()

        sideMenu = SideMenuNavigationController(rootViewController: MenuListController())
        sideMenu?.leftSide = false
        
        SideMenuManager.default.rightMenuNavigationController = sideMenu // 메뉴는 오른쪽
        SideMenuManager.default.addPanGestureToPresent(toView: self.view) // 메뉴에 스와이핑 제스처 추가
        // Do any additional setup after loading the view.
    }
    
    @IBAction func menuButton(_ sender: UIButton) {
        present(sideMenu!, animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

class MenuListController: UITableViewController {
    var lists = ["마이페이지", "정보", "일정", "공금내역", "로그아웃", "관리자페이지"]
    
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
}
