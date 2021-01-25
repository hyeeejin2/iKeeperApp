//
//  MypageViewController.swift
//  ikeeperApp
//
//  Created by 김혜진 on 2021/01/17.
//

import UIKit
import Firebase

class MypageViewController: UIViewController {

    @IBOutlet weak var profileImage: UIImage!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var departmentLabel: UILabel!
    @IBOutlet weak var gradeLabel: UILabel!
    @IBOutlet weak var partLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var functionCollectionView: UICollectionView!
    @IBOutlet weak var functionTableView: UITableView!
    let collectionList = ["작성한 글 확인", "작성한 일정 확인", "경고 내역 확인"]
    let collectionImage = ["list.dash", "calendar", "bell"]
    let tableViewTitle = ["계정", "기타"]
    let tableViewList1 = ["회원정보 수정", "프로필 사진 설정"]
    let tableViewList2 = ["로그아웃", "회원탈퇴"]
    let space = [" ", " "]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.functionCollectionView.delegate = self
        self.functionCollectionView.dataSource = self
        
        self.functionTableView.delegate = self
        self.functionTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setProfile()
    }
    
    func setProfile() {
        // systemName : person.circle
        let user = Auth.auth().currentUser
        if user != nil {
            let uid: String = user!.uid
            let db = Firestore.firestore()
            db.collection("users").whereField("uid", isEqualTo: uid).getDocuments { (snapshot, error) in
                if error == nil && snapshot?.isEmpty == false {
                    for document in snapshot!.documents {
                        let documentData = document.data()
                        print(documentData)
                        self.nameLabel.text = documentData["name"] as? String
                        self.departmentLabel.text = documentData["department"] as? String
                        self.gradeLabel.text = documentData["grade"] as? String
                        self.partLabel.text = documentData["part"] as? String
                        self.statusLabel.text = documentData["status"] as? String
                    }
                }
            }
        }
    }
}

extension MypageViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //cell은 as 키워드로 앞서 만든 MypageCollectionCustomCell 클래스화
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MypageCollectionCustomCell", for: indexPath) as! MypageCollectionCustomCell
        
        // cell에 데이터 삽입
        let imageString: String = collectionImage[indexPath.row]
        cell.backgroundColor = .systemGray6
        cell.functionImage.image = UIImage(systemName: "\(imageString)")
        cell.functionLabel.text? = collectionList[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("test")
    }
    
}

extension MypageViewController: UICollectionViewDelegateFlowLayout {
    // 옆 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }

    // cell 사이즈
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let width = collectionView.frame.width / 3-2
        let size = CGSize(width: width, height: width)
        return size
        
//        print("collectionView width=\(collectionView.frame.width)")
//        print("cell하나당 width=\(width)")
//        print("root view width = \(self.view.frame.width)")
    }
}

extension MypageViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableViewTitle.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return tableViewList1.count
        } else {
            return tableViewList2.count
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return tableViewTitle[section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // cell은 as 키워드로 앞서 만든 MypageTableCustomCell 클래스화
        let cell = tableView.dequeueReusableCell(withIdentifier: "MypageTableCustomCell", for: indexPath) as! MypageTableCustomCell

        // cell에 데이터 삽입
        if indexPath.section == 0 {
            cell.functionLabel?.text = tableViewList1[indexPath.row]
        } else {
            cell.functionLabel?.text = tableViewList2[indexPath.row]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return space[section]
    }
    
    func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        view.tintColor = .clear
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                print("회원정보 수정")
            } else if indexPath.row == 1{
                print("프로필 사진 설정")
            }
        } else if indexPath.section == 1{
            if indexPath.row == 0 {
                print("로그아웃")
                let firebaseAuth = Auth.auth()
                do {
                    try firebaseAuth.signOut()
                    // 초기화면으로 전환
                } catch let signOutError as NSError {
                    print ("Error signing out: %@", signOutError)
                }
            } else if indexPath.row == 1{
                print("회원탈퇴")
            }
        }
    }
}
