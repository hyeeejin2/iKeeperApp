//
//  MypageViewController.swift
//  ikeeperApp
//
//  Created by 김혜진 on 2021/01/17.
//

import UIKit
import Firebase

class MypageViewController: UIViewController {

    @IBOutlet weak var profileImage: UIImageView!
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
    var documentID: String = ""
    var currentPW: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.functionCollectionView.delegate = self
        self.functionCollectionView.dataSource = self
        
        self.functionTableView.delegate = self
        self.functionTableView.dataSource = self
        
        self.picker.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setUser()
    }
    
    func setUser() {
        let user = Auth.auth().currentUser
        if user != nil {
            DispatchQueue.main.async {
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
                            self.documentID = documentData["id"] as! String
                            self.currentPW = documentData["password"] as! String
                        }
                    }
                }
                let storage = Storage.storage().reference()
                storage.child("images/profile/\(uid).png").downloadURL { (url, error) in
                    if error != nil {
                        print("check for error : \(error!.localizedDescription)")
                        let defaultImage = UIImage(systemName: "person.circle")
                        self.profileImage.image = defaultImage
                        
                    } else {
                        guard let urlString = UserDefaults.standard.value(forKey: "\(uid)") as? String, let url = URL(string: urlString) else {
                            return
                        }
                        let task = URLSession.shared.dataTask(with: url, completionHandler: { data, _, error in
                            guard let data = data, error == nil else {
                                return
                            }
                            DispatchQueue.main.async {
                                let image = UIImage(data: data)
                                self.profileImage.image = image
                            }
                        })
                        task.resume()
                    }
                }
            }
        } else {
            permissionDenied()
        }
    }
    
    func permissionDenied() {
        let alert = UIAlertController(title: "알림",
                                      message: "로그인 해주세요",
                                      preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default) { (action) in
            self.tabBarController?.selectedIndex = 0
        }
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    // 프로필 사진 설정
    func profilePhoto() {
        let user = Auth.auth().currentUser
        if user != nil {
            let alert =  UIAlertController(title: "프로필 사진 설정", message: "아래 두 가지 중 선택하세요", preferredStyle: .actionSheet)
            let library =  UIAlertAction(title: "앨범에서 사진 선택", style: .default) { (action) in self.openLibrary() }
            let delete =  UIAlertAction(title: "기본 이미지로 변경", style: .default) { (action) in self.deletePhoto() }
            let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
            alert.addAction(library)
            alert.addAction(delete)
            alert.addAction(cancel)
            present(alert, animated: true, completion: nil)
        } else {
            showAlert(message: "권한이 없습니다")
        }
    }
    
    func openLibrary() {
        picker.sourceType = .photoLibrary
        present(picker, animated: false, completion: nil) // library present
    }

    func deletePhoto() {
        let user = Auth.auth().currentUser
        let uid: String = user!.uid
        let storage = Storage.storage().reference()
        storage.child("images/profile/\(uid).png").delete { (error) in
            if error != nil {
                print("check for error : \(error!.localizedDescription)")
            } else {
                let defaultImage = UIImage(systemName: "person.circle")
                self.profileImage.image = defaultImage
            }
        }
    }
    
    // 로그아웃
    func logout() {
        let user = Auth.auth().currentUser
        if user != nil {
            showAlertForlogout()
        } else {
            showAlert(message: "권한이 없습니다")
        }
    }
    
    func showAlertForlogout() {
        let alert = UIAlertController(title: "로그아웃",
                                      message: "로그아웃 하시겠습니까?",
                                      preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: "확인", style: .default) { (action) in
            let firebaseAuth = Auth.auth()
            do {
                try firebaseAuth.signOut()
                self.initForLogout()
            } catch let signOutError as NSError {
                print ("Error signing out: %@", signOutError)
            }
        }
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func initForLogout() {
        profileImage.image = UIImage(systemName: "person.circle")
        nameLabel.text = "name"
        departmentLabel.text = "department"
        gradeLabel.text = "grade"
        partLabel.text = "part"
        statusLabel.text = "status"
        self.tabBarController?.selectedIndex = 0
    }
    
    // 회원탈퇴
    func showAlertForPasswordCheck() {
        let user = Auth.auth().currentUser
        if user != nil {
            let alert = UIAlertController(title: "비밀번호 확인",
                                          message: "비밀번호를 입력하세요",
                                          preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
            let okAction = UIAlertAction(title: "확인", style: .default) { (action) in
                if let alertPW: String = alert.textFields?[0].text {
                    if alertPW == self.currentPW {
                        self.deleteUser()
                    } else {
                        self.showAlert(message: "비밀번호를 확인하세요")
                    }
                }
            }
            alert.addAction(cancelAction)
            alert.addAction(okAction)
            alert.addTextField { (pwValue) in
                pwValue.placeholder = "password"
                pwValue.isSecureTextEntry = true
            }
            self.present(alert, animated: true, completion: nil)
        } else {
            showAlert(message: "권한이 없습니다")
        }
    }
    
    func deleteUser() {
        Auth.auth().currentUser?.delete(completion: { (err) in
            if err != nil {
                print("check for error : \(err!.localizedDescription)")
            } else {
                let db = Firestore.firestore()
                db.collection("users").document("\(self.documentID)").delete { (error) in
                    if error != nil {
                        print("check for error : \(error!.localizedDescription)")
                    } else {
                        self.showAlertDeleteUser()
                    }
                }
            }
        })
    }
    
    func showAlertDeleteUser() {
        let alert = UIAlertController(title: "회원탈퇴 완료",
                                      message: "회원탈퇴가 완료되었습니다",
                                      preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default) { (action) in
            self.initForLogout()
        }
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    // 알림창
    func showAlert(message: String) {
        let alert = UIAlertController(title: "알림",
                                      message: message,
                                      preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
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
        cell.backgroundColor = UIColor(displayP3Red: 229/255, green: 229/255, blue: 229/255, alpha: 0.5)
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
                profilePhoto()
            }
        } else if indexPath.section == 1{
            if indexPath.row == 0 {
                logout()
            } else if indexPath.row == 1{
                showAlertForPasswordCheck()
            }
        }
    }
}

extension MypageViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // 사진 선택이 끝나면
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return
        }
        
        profileImage.image = image
        print(info)
        dismiss(animated: true, completion: nil)

        guard let imageData = image.pngData() else {
            return
        }
        
        let user = Auth.auth().currentUser
        let uid: String = user!.uid
        let storage = Storage.storage().reference()
        storage.child("images/profile/\(uid).png").putData(imageData, metadata: nil, completion: { _, error in
            guard error == nil else {
                print("Failed to upload")
                return
            }
            storage.child("images/profile/\(uid).png").downloadURL { (url, error) in
                guard let url = url, error == nil else {
                    return
                }
                
                let urlString = url.absoluteString
                print("Download URL : \(urlString)")
                UserDefaults.standard.setValue(urlString, forKey: "\(uid)")
            }
        })
    }
    // 사진 선택을 취소하면
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
