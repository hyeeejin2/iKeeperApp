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
    let tableViewList1 = ["회원정보 수정", "비밀번호 변경" ,"프로필 사진 설정"]
    let tableViewList2 = ["로그아웃", "회원탈퇴"]
    let space = [" ", " "]
    let picker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.functionCollectionView.delegate = self
        self.functionCollectionView.dataSource = self
        
        self.functionTableView.delegate = self
        self.functionTableView.dataSource = self
        
        self.picker.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("test")
        setUser()
    }
    
    func setUser() {
        let user = Auth.auth().currentUser
        if user != nil {
            // systemName : person.circle
            let user = Auth.auth().currentUser
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
        } else {
            print("no user")
//            let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC")
//            self.navigationController?.pushViewController(loginViewController!, animated: true)
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
        collectionView.deselectItem(at: indexPath, animated: true)
        
        if indexPath.row == 0 {
            let mypageWrittenInfoViewController = self.storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.mypageWrittenInfoViewController) as! MypageWrittenInfoViewController
            self.navigationController?.pushViewController(mypageWrittenInfoViewController, animated: true)
        } else if indexPath.row == 1 {
            let mypageWrittenCalendarViewController = self.storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.mypageWrittenCalendarViewController) as! MypageWrittenCalendarViewController
            self.navigationController?.pushViewController(mypageWrittenCalendarViewController, animated: true)
        } else {
            let mypageWarningListViewController = self.storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.mypageWarningListViewController) as! MypageWarningListViewController
            self.navigationController?.pushViewController(mypageWarningListViewController, animated: true)
        }
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
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let mypageUserInfoViewController = self.storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.mypageUserInfoViewController) as! MypageUserInfoViewController
                self.navigationController?.pushViewController(mypageUserInfoViewController, animated: true)
            } else if indexPath.row == 1{
                let mypageChangePasswordViewController = self.storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.mypageChangePasswordViewController) as! MypageChangePasswordViewController
                self.navigationController?.pushViewController(mypageChangePasswordViewController, animated: true)
            } else if indexPath.row == 2 {
                print("프로필 사진 설정")
//                let alert =  UIAlertController(title: "원하는 타이틀", message: "원하는 메세지", preferredStyle: .actionSheet)
//                let library =  UIAlertAction(title: "앨범에서 사진 선택", style: .default) { (action) in self.openLibrary() }
//                let delete =  UIAlertAction(title: "기본 이미지로 변경", style: .default) { (action) in self.deletePhoto() }
//                let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
//                alert.addAction(library)
//                alert.addAction(delete)
//                alert.addAction(cancel)
//                present(alert, animated: true, completion: nil)
            }
        } else if indexPath.section == 1{
            if indexPath.row == 0 {
                let firebaseAuth = Auth.auth()
                do {
                    try firebaseAuth.signOut()
                    self.nameLabel.text = "name"
                    self.departmentLabel.text = "department"
                    self.gradeLabel.text = "grade"
                    self.partLabel.text = "part"
                    self.statusLabel.text = "status"
                    self.tabBarController?.selectedIndex = 0
                } catch let signOutError as NSError {
                    print ("Error signing out: %@", signOutError)
                }
            } else if indexPath.row == 1{
                print("회원탈퇴")
            }
        }
    }
    
//    func openLibrary() {
//        picker.sourceType = .photoLibrary
//        present(picker, animated: false, completion: nil)
//    }
//
//    func deletePhoto() {
//        print("delete")
//    }
    
}

extension MypageViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
}
