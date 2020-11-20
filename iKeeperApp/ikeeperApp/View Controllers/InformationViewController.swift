//
//  InformationViewController.swift
//  ikeeperApp
//
//  Created by 김혜진 on 2020/11/20.
//

import UIKit

class InformationViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    let contents:[String] = ["1", "sw개발보안", "11", "2020-11-20", "14:00", "김혜진",
                             "2", "kucis 영남권 세미나", "30", "2020-12-12", "13:00", "김혜진"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        tableView.dataSource = self
        //self.tableView.estimatedRowHeight = 80
        //self.tableView.rowHeight = UITableView.automaticDimension
    }

}

extension InformationViewController: UITableViewDelegate, UITableViewDataSource {
    
    // tableView setting - row
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    // tableView setting - cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        /*guard let cell = tableView.dequeueReusableCell(withIdentifier: "InfoCustomCell") else {
            fatalError("error")
        }*/
        
        //cell은 as 키워드로 앞서 만든 InfoCustomCell 클래스화
        let cell = tableView.dequeueReusableCell(withIdentifier: "InfoCustomCell", for: indexPath) as! InfoCustomCell
        cell.numLabel?.text = contents[indexPath.row]
        cell.titleLabel?.text = contents[indexPath.row]
        cell.viewsLable?.text = contents[indexPath.row]
        cell.dateLabel?.text = contents[indexPath.row]
        cell.timeLabel?.text = contents[indexPath.row]
        cell.writerLabel?.text = contents[indexPath.row]
        return cell
    }
}
