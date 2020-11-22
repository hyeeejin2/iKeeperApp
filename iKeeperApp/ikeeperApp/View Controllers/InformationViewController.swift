//
//  InformationViewController.swift
//  ikeeperApp
//
//  Created by 김혜진 on 2020/11/20.
//

import UIKit

class InformationViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var dataList = [[String: String]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 80.0 // 임의 설정이지만 계산해서 80
        tableView.rowHeight = UITableView.automaticDimension // autolayout 설정에 맞게 자동으로 table cell height 조절
        
        dataAdd()
    }
    
    func dataAdd() {
        let data1: [String: String] = ["num": "1", "title": "sw개발보안경진대회", "views": "11",
                                       "date": "2020-11-20", "time": "14:00", "writer": "김혜진"]
        dataList.append(data1)
        let data2: [String: String] = ["num": "2", "title": "kucis 영남권 세미나", "views": "30",
                                       "date": "2020-12-12", "time": "13:00", "writer": "김혜진"]
        dataList.append(data2)
    }

}

extension InformationViewController: UITableViewDelegate, UITableViewDataSource {
    
    // tableView setting - height of row
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    // tableView setting - row
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //print(dataList)
        return dataList.count
    }
    
    // tableView setting - cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //cell은 as 키워드로 앞서 만든 InfoCustomCell 클래스화
        let cell = tableView.dequeueReusableCell(withIdentifier: "InfoCustomCell", for: indexPath) as! InfoCustomCell

        // cell에 데이터 삽입
        let data = dataList[indexPath.row]
        cell.numLabel?.text = data["num"]
        cell.titleLabel?.text = data["title"]
        cell.viewsLable?.text = data["views"]
        cell.dateLabel?.text = data["date"]
        cell.timeLabel?.text = data["time"]
        cell.writerLabel?.text = data["writer"]
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
