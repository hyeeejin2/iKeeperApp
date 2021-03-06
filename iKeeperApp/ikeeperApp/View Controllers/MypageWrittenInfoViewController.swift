//
//  MypageWrittenInfoViewController.swift
//  ikeeperApp
//
//  Created by 김혜진 on 2021/01/27.
//

import UIKit
import Firebase

class MypageWrittenInfoViewController: UIViewController {

    @IBOutlet weak var editBarButton: UIBarButtonItem!
    @IBOutlet weak var infoListTableView: UITableView!
    let statusLabel = UILabel(frame: CGRect(x: 0, y: 95, width: 414, height: 40))
    var dataList = [[String: Any]]()
    var numbering: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        infoListTableView.delegate = self
        infoListTableView.dataSource = self
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
        db.collection("infoList").whereField("uid", isEqualTo: uid).order(by: "created", descending: true).getDocuments { (snapshot, error) in
            if error != nil {
                print("check for error : \(error!.localizedDescription)")
            } else {
                if snapshot?.isEmpty == false {
                    for document in snapshot!.documents {
                        let documentData = document.data()
                        self.dataList.append(documentData)
                    }
                    self.editBarButton.image = UIImage(systemName: "pencil.slash")
                    self.editBarButton.isEnabled = true
                } else {
                    self.statusLabel.textAlignment = .center
                    self.statusLabel.text = "아직 작성한 글이 없습니다."
                    self.view.addSubview(self.statusLabel)
                    self.editBarButton.image = nil
                    self.editBarButton.isEnabled = false
                }
                self.infoListTableView.reloadData()
            }
        }
    }
    
    @IBAction func editBarButton(_ sender: UIBarButtonItem) {
        if infoListTableView.isEditing {
            infoListTableView.isEditing = false
            editBarButton.image = UIImage(systemName: "pencil.slash")
        } else {
            infoListTableView.isEditing = true
            editBarButton.image = UIImage(systemName: "checkmark.circle")
        }
    }
}

extension MypageWrittenInfoViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // cell은 as 키워드로 앞서 만든 MypageInfoListCustomCell 클래스화
        let cell = tableView.dequeueReusableCell(withIdentifier: "MypageInfoListCustomCell", for: indexPath) as! MypageInfoListCustomCell

        // cell에 데이터 삽입
        let data = dataList[indexPath.row]
        cell.numLabel?.text = String(numbering)
        numbering += 1
        cell.titleLabel?.text = data["title"] as? String
        cell.viewsLabel?.text = String((data["views"] as? Int)!)
        cell.dateLabel?.text = data["date"] as? String
        cell.timeLabel?.text = data["time"] as? String
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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            let data = dataList[indexPath.row]
            let id = data["id"] as! String
            
            let alert = UIAlertController(title: "게시글 삭제",
                                          message: "게시글을 삭제하시겠습니까?",
                                          preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
            let okAction = UIAlertAction(title: "확인", style: .default) { (action) in
                let db = Firestore.firestore()
                db.collection("infoList").document("\(id)").delete { (error) in
                    if error != nil {
                        print("check for error : \(error!.localizedDescription)")
                    } else {
                        let alert = UIAlertController(title: "삭제 완료",
                                                      message: "게시글 삭제가 완료되었습니다",
                                                      preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "확인", style: .default) { (action) in
                            self.numbering = 1
                            self.dataList.remove(at: indexPath.row)
                            self.infoListTableView.deleteRows(at: [indexPath], with: .automatic)
                            if self.dataList.count == 0 {
                                self.statusLabel.textAlignment = .center
                                self.statusLabel.text = "아직 작성한 글이 없습니다."
                                self.view.addSubview(self.statusLabel)
                                self.infoListTableView.isEditing = false
                                self.editBarButton.image = nil
                                self.editBarButton.isEnabled = false
                            }
                            self.infoListTableView.reloadData()
                        }
                        alert.addAction(okAction)
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }
            alert.addAction(cancelAction)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
}
