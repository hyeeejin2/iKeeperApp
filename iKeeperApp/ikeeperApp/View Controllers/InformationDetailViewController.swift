//
//  InformationDetailViewController.swift
//  ikeeperApp
//
//  Created by 김혜진 on 2020/12/20.
//

import UIKit
import Firebase
import YPImagePicker

class InformationDetailViewController: UIViewController {

    @IBOutlet weak var titleValue: UITextField!
    @IBOutlet weak var writerValue: UITextField!
    @IBOutlet weak var dateValue: UITextField!
    @IBOutlet weak var timeValue: UITextField!
    @IBOutlet weak var viewsValue: UITextField!
    @IBOutlet weak var contentValue: UITextView!
    @IBOutlet weak var rightBarButton: UIBarButtonItem!
    @IBOutlet weak var imageCollectionView: UICollectionView!
    @IBOutlet weak var completeButton: UIButton!
    let datePicker: UIDatePicker = UIDatePicker()
    let timePicker: UIDatePicker = UIDatePicker()
    let formatter = DateFormatter()
    var dataList = [String: Any]()
    var config = YPImagePickerConfiguration()
    var images = [UIImage]()
    var showMode: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
        completeButton.isHidden = true
        setDisabled()
        setValue()
        setTextview()
        setYPImagePicker()
        createDatePicker()
        dismissDatePicker()
        createTimePicker()
        dismissTimePicker()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setUser()
        getImages()
    }
    
    func setUser(){
        let user = Auth.auth().currentUser
        if user != nil {
            let uid: String = user!.uid
            let documentID: String = dataList["id"] as! String
            let db = Firestore.firestore()
            db.collection("infoList").whereField("id", isEqualTo: documentID).whereField("uid", isEqualTo: uid).getDocuments { (snapshot, error) in
                if error == nil && snapshot?.isEmpty == false {
                    print("회원 & 본인")
                } else if error == nil && snapshot?.isEmpty == true {
                    db.collection("users").whereField("uid", isEqualTo: uid).whereField("permission", isEqualTo: true).getDocuments { (snapshot, error) in
                        if error == nil && snapshot?.isEmpty == false {
                            print("관리자")
                        } else if error == nil && snapshot?.isEmpty == true {
                            self.setBarButtonDisabled()
                        }
                    }
                }
            }
        } else {
            setBarButtonDisabled()
        }
    }
    
    func setBarButtonDisabled() {
        rightBarButton.image = nil
        rightBarButton.isEnabled = false
    }
    
    func setEnabled() {
        titleValue.isEnabled = true
        dateValue.isEnabled = true
        timeValue.isEnabled = true
        contentValue.isEditable = true
    }
    
    func setDisabled() {
        titleValue.isEnabled = false
        writerValue.isEnabled = false
        dateValue.isEnabled = false
        timeValue.isEnabled = false
        viewsValue.isEnabled = false
        contentValue.isEditable = false
    }
    
    func setValue() {
        titleValue.text = dataList["title"] as? String
        writerValue.text = dataList["writer"] as? String
        dateValue.text = dataList["date"] as? String
        timeValue.text = dataList["time"] as? String
        viewsValue.text = String((dataList["views"] as? Int)!)
        contentValue.text = dataList["content"] as? String
    }
    
    func setTextview() {
        contentValue.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        contentValue.layer.borderWidth = 0.5
        contentValue.layer.cornerRadius = 5.0
    }
    
    func setYPImagePicker() {
        config.isScrollToChangeModesEnabled = true
        config.onlySquareImagesFromCamera = true
        config.usesFrontCamera = false
        config.showsPhotoFilters = false
        config.showsVideoTrimmer = false
        config.shouldSaveNewPicturesToAlbum = true
        config.albumName = "DefaultYPImagePickerAlbumName"
        config.startOnScreen = YPPickerScreen.photo
        config.screens = [.library]
        
        config.showsCrop = .none
        config.targetImageSize = YPImageSize.original
        config.overlayView = UIView()
        config.hidesStatusBar = true
        config.hidesBottomBar = false
        config.hidesCancelButton = false
        config.preferredStatusBarStyle = UIStatusBarStyle.default
        config.bottomMenuItemSelectedTextColour = UIColor(red: 38, green: 38, blue: 38, alpha: 0)
        config.bottomMenuItemUnSelectedTextColour = UIColor(red: 153, green: 153, blue: 153, alpha: 0)
        //config.filters = []
        config.maxCameraZoomFactor = 1.0
        
        config.library.preSelectItemOnMultipleSelection = true
        config.library.options = nil
        config.library.onlySquare = false
        config.library.isSquareByDefault = true
        config.library.minWidthForItem = nil
        config.library.mediaType = YPlibraryMediaType.photo
        config.library.defaultMultipleSelection = false
        config.library.maxNumberOfItems = 1
        config.library.minNumberOfItems = 1
        config.library.numberOfItemsInRow = 4
        config.library.spacingBetweenItems = 1.0
        config.library.skipSelectionsGallery = false
        config.library.preselectedItems = nil
        config.gallery.hidesRemoveButton = false
    }
    
    func getImages() {
        let id: String = dataList["id"] as! String
        let numberOfImage: Int = dataList["count"] as! Int
        
        for count in 0..<numberOfImage {
            let storage = Storage.storage().reference()
            storage.child("images/infoBoard/\(id)-\(count).png").downloadURL { (url, error) in
                if error != nil {
                    print("check for error :\(error!.localizedDescription)")
                } else {
                    guard let urlString = UserDefaults.standard.value(forKey: "\(id)-\(count)") as? String, let url = URL(string: urlString) else {
                        return
                    }
                    let task = URLSession.shared.dataTask(with: url, completionHandler: { data, _, error in
                        guard let data = data, error == nil else {
                            return
                        }
                        DispatchQueue.main.async {
                            let image = UIImage(data: data)
                            self.images.append(image!)
                            self.imageCollectionView.reloadData()
                        }
                    })
                    task.resume()
                }
            }
        }
    }
    
    // datePicker - date
    func createDatePicker() {
        if #available(iOS 13.4, *) {
                datePicker.preferredDatePickerStyle = .wheels
        }
        datePicker.datePickerMode = .date
        datePicker.locale = NSLocale(localeIdentifier: "ko_KO") as Locale // 한글로 변환
        dateValue.inputView = datePicker
    }
    
    func dismissDatePicker() {
        let dateToolBar = UIToolbar()
        dateToolBar.sizeToFit()
        dateToolBar.isTranslucent = true
        let btnDone = UIBarButtonItem(title: "확인", style: .done, target: self, action: #selector(dateDone))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        dateToolBar.setItems([space, btnDone], animated: true)
        dateToolBar.isUserInteractionEnabled = true
        dateValue.inputAccessoryView = dateToolBar
    }
    
    @objc func dateDone() {
        formatter.dateFormat = "YYYY-MM-dd"
        let dateString = formatter.string(from: datePicker.date)
        dateValue.text = "\(dateString)"
        self.view.endEditing(true)
    }
    
    // datePicker - time
    func createTimePicker() {
        if #available(iOS 13.4, *) {
            timePicker.preferredDatePickerStyle = .wheels
        }
        timePicker.datePickerMode = .time
        //startPicker.locale = NSLocale(localeIdentifier: "ko_KO") as Locale
        timeValue.inputView = timePicker
    }
    
    func dismissTimePicker() {
        let timeToolBar = UIToolbar()
        timeToolBar.sizeToFit()
        timeToolBar.isTranslucent = true
        let btnDone = UIBarButtonItem(title: "확인", style: .done, target: self, action: #selector(timeDone))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        timeToolBar.setItems([space, btnDone], animated: true)
        timeToolBar.isUserInteractionEnabled = true
        timeValue.inputAccessoryView = timeToolBar
    }
    
    @objc func timeDone() {
        formatter.dateFormat = "hh:mm a"
        let timeString = formatter.string(from: timePicker.date)
        timeValue.text = "\(timeString)"
        self.view.endEditing(true)
    }
    
    func showAlertForChoice() {
        let alert = UIAlertController(title: "기능 선택", message: nil, preferredStyle: .actionSheet)
        let modify = UIAlertAction(title: "수정", style: .default) { (action) in
            self.rightBarButton.image = UIImage(systemName: "photo")
            self.showMode = false
            self.completeButton.isHidden = false
            self.setEnabled()
            //self.imageCollectionView.reloadData()
        }
        let delete = UIAlertAction(title: "삭제", style: .default) { (action) in
            let id = self.dataList["id"] as! String
            self.showAlertForDelete(id: id)
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alert.addAction(modify)
        alert.addAction(delete)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    func imageChoice() {
        config.library.maxNumberOfItems = 3 - images.count
        let picker = YPImagePicker(configuration: config)
        picker.didFinishPicking { [unowned picker] items, cancelled in
            if cancelled {
                picker.dismiss(animated: true, completion: nil)
                return
            }

            for item in items {
                switch item {
                case .photo(let photo):
                    self.images.append(photo.image)
                default:
                    return
                }
            }
            picker.dismiss(animated: true) {
                self.imageCollectionView.reloadData()
            }
        }
        present(picker, animated: true, completion: nil)
    }
    
    @IBAction func rightBarButton(_ sender: UIBarButtonItem) {
        if showMode {
            showAlertForChoice()
        } else {
            if self.images.count < 3 {
                imageChoice()
            } else {
                showAlert(message: "사진을 3개 이상 첨부할 수 없습니다")
            }
        }
    }
    
    @IBAction func completeButton(_ sender: UIButton) {
        guard let title: String = titleValue.text, title.isEmpty == false else {
            showAlert(message: "빈칸을 채워주세요")
            return
        }
        guard let writer: String = writerValue.text, writer.isEmpty == false else {
            showAlert(message: "빈칸을 채워주세요")
            return
        }
        guard let date: String = dateValue.text, date.isEmpty == false else {
            showAlert(message: "빈칸을 채워주세요")
            return
        }
        guard let time: String = timeValue.text, time.isEmpty == false else {
            showAlert(message: "빈칸을 채워주세요")
            return
        }
        guard let views: String = viewsValue.text, views.isEmpty == false else {
            showAlert(message: "빈칸을 채워주세요")
            return
        }
        guard let content: String = contentValue.text, content.isEmpty == false else {
            showAlert(message: "빈칸을 채워주세요")
            return
        }
        
        let modifyData = ["title": title, "date": date, "time": time, "content": content, "count": self.images.count] as [String : Any]
        let id = dataList["id"] as! String
        print(modifyData, id)
        
        let db = Firestore.firestore()
        db.collection("infoList").document("\(id)").updateData(modifyData) { (error) in
            if error != nil {
                print("check for error : \(error!.localizedDescription)")
            } else {
                self.showAlertModifyOrDelete(title: "수정 완료", message: "게시글 수정이 완료되었습니다")
            }
        }
        rightBarButton.image = UIImage(systemName: "pencil.slash")
        showMode = true
        completeButton.isHidden = true
        setDisabled()
    }
    
    func showAlertForDelete(id: String) {
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
                    self.showAlertModifyOrDelete(title: "삭제 완료", message: "게시글 삭제가 완료되었습니다")
                }
            }
        }
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func showAlertModifyOrDelete(title: String, message: String) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default) { (action) in
            self.navigationController?.popViewController(animated: true)
        }
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "알림",
                                      message: message,
                                      preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
}

extension InformationDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //cell은 as 키워드로 앞서 만든 InfoDetailCollectionCustomCell 클래스화
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "InfoDetailCollectionCustomCell", for: indexPath) as! InfoDetailCollectionCustomCell
        
        // cell에 데이터 삽입
        let image: UIImage = images[indexPath.row]
        cell.image.image = image
        if showMode {
            cell.deleteButton.isHidden = true
            cell.deleteButton.isEnabled = false
        } else {
            cell.deleteButton.addTarget(self, action: #selector(self.deleteButton(_:)), for: .touchUpInside)
        }
        return cell
    }
    
    @objc func deleteButton(_ sender: UIButton) {
        let alert = UIAlertController(title: "이미지 삭제",
                                      message: "이미지를 삭제하시겠습니까?",
                                      preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: "확인", style: .default) { (action) in
            self.images.remove(at: sender.tag)
            self.imageCollectionView.reloadData()
        }
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }

//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        <#code#>
//    }
}

extension InformationDetailViewController: UICollectionViewDelegateFlowLayout {
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
