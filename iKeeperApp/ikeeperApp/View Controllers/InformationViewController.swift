//
//  InformationViewController.swift
//  ikeeperApp
//
//  Created by 김혜진 on 2020/11/20.
//

import UIKit
import Firebase

class InformationViewController: UIViewController {

    @IBOutlet weak var infoTableView: UITableView!
    let statusLabel = UILabel(frame: CGRect(x: 0, y: 100, width: 414, height: 40))
    var dataList = [[String: Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        infoTableView.delegate = self
        infoTableView.dataSource = self
        //infoTableView.estimatedRowHeight = 80.0 // 임의 설정이지만 계산해서 80
        //infoTableView.rowHeight = UITableView.automaticDimension // autolayout 설정에 맞게 자동으로 table cell height 조절
    }
    
    override func viewWillAppear(_ animated: Bool) {
        dataList = [[String:Any]]()
        showInfo()
    }
    
    func showInfo() {
        statusLabel.removeFromSuperview()
        
        let db = Firestore.firestore()
        db.collection("infoList").order(by: "created", descending: true).getDocuments { (snapshot, error) in
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
                self.statusLabel.text = "아직 게시글이 없습니다."
                self.view.addSubview(self.statusLabel)
            }
            self.infoTableView.reloadData()
        }
    }

}

extension InformationViewController: UITableViewDelegate, UITableViewDataSource {
    
    // tableView setting - row
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    
    // tableView setting - cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // cell은 as 키워드로 앞서 만든 InfoCustomCell 클래스화
        let cell = tableView.dequeueReusableCell(withIdentifier: "InfoCustomCell", for: indexPath) as! InfoCustomCell

        // cell에 데이터 삽입
        let data = dataList[indexPath.row]
        cell.numLabel?.text = data["num"] as? String
        cell.titleLabel?.text = data["title"] as? String
        cell.viewsLable?.text = String((data["views"] as? Int)!)
        cell.dateLabel?.text = data["date"] as? String
        cell.timeLabel?.text = data["time"] as? String
        cell.writerLabel?.text = data["writer"] as? String
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let data = dataList[indexPath.row]
        let id = data["id"] as! String
        let views = data["views"] as! Int
        
        let informationDetailViewController = self.storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.informationDetailViewController) as! InformationDetailViewController
        informationDetailViewController.dataList = data
        self.navigationController?.pushViewController(informationDetailViewController, animated: true)
        
        let db = Firestore.firestore()
        db.collection("infoList").document("\(id)").updateData(["views" : views+1]) { (error) in
            if error != nil {
                print("check for error : \(error!.localizedDescription)")
            } else {
                print("success")
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
