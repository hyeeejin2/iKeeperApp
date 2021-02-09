//
//  InformationWriteViewController.swift
//  ikeeperApp
//
//  Created by 김혜진 on 2020/12/20.
//

import UIKit
import Firebase
import YPImagePicker

class InformationWriteViewController: UIViewController {

    @IBOutlet weak var titleValue: UITextField!
    @IBOutlet weak var writerValue: UITextField!
    @IBOutlet weak var dateValue: UITextField!
    @IBOutlet weak var timeValue: UITextField!
    @IBOutlet weak var contentValue: UITextView!
    @IBOutlet var pickedImages: [UIImageView]!
    let datePicker: UIDatePicker = UIDatePicker()
    let timePicker: UIDatePicker = UIDatePicker()
    let formatter = DateFormatter()
    var config = YPImagePickerConfiguration()
    var images: [UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setTextview()
        createDatePicker()
        dismissDatePicker()
        createTimePicker()
        dismissTimePicker()
        setYPImagePicker()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setUser()
    }
    
    func setUser(){
        let user = Auth.auth().currentUser
        if user != nil {
            let uid: String = user!.uid
            let db = Firestore.firestore()
            db.collection("users").whereField("uid", isEqualTo: uid).getDocuments { (snapshot, error) in
                if error == nil && snapshot?.isEmpty == false {
                    for document in snapshot!.documents {
                        let documentData = document.data()
                        print(documentData)
                        self.writerValue.text = documentData["name"] as? String
                        self.writerValue.isEnabled = false
                    }
                }
            }
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func setTextview() {
        contentValue.delegate = self
        
        contentValue.text = "content"
        contentValue.textColor = .lightGray
        
        contentValue.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        contentValue.layer.borderWidth = 0.5
        contentValue.layer.cornerRadius = 5.0
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
    
    func setYPImagePicker() {
        config.isScrollToChangeModesEnabled = true
        config.onlySquareImagesFromCamera = true
        config.usesFrontCamera = false
        config.showsPhotoFilters = false
        config.showsVideoTrimmer = false
        config.shouldSaveNewPicturesToAlbum = true
        config.albumName = "DefaultYPImagePickerAlbumName"
        config.startOnScreen = YPPickerScreen.photo
        config.screens = [.library] // .photo .video
        
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
    @objc func timeDone() {
        formatter.dateFormat = "hh:mm a"
        let timeString = formatter.string(from: timePicker.date)
        timeValue.text = "\(timeString)"
        self.view.endEditing(true)
    }
    
    @IBAction func imageBarButton(_ sender: UIBarButtonItem) {
        print("image button click")
        
        config.library.maxNumberOfItems = 3
        let picker = YPImagePicker(configuration: config)
        picker.didFinishPicking { [unowned picker] items, cancelled in
            self.pickedImages = []
            self.images = []

            if cancelled {
                picker.dismiss(animated: true, completion: nil)
                return
            }

            for item in items {
                switch item {
                case .photo(let photo):
                    //let image = UIImageView(image: photo.image)
                    //self.pickedImages.append(image)
                    self.images.append(photo.image)
                default:
                    return
                }
            }
            
            for image in self.pickedImages {
                image.image = UIImage(systemName: "pencil")
            }
            picker.dismiss(animated: true, completion: nil)
        }
        present(picker, animated: true, completion: nil)
    }
    
    @IBAction func writeButton(_ sender: UIButton) {
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
        guard let content: String = contentValue.text, content.isEmpty == false else {
            showAlert(message: "빈칸을 채워주세요")
            return
        }
        
        let user = Auth.auth().currentUser
        let uid = user!.uid
        let timestamp = NSDate().timeIntervalSince1970
        let views: Int = 0
        let db = Firestore.firestore()
        let newDocument = db.collection("infoList").document()
        newDocument.setData(["id": newDocument.documentID, "uid": uid, "title": title, "writer": writer, "date": date, "time": time, "views": views, "content": content, "created": timestamp]) { (error) in
            if error != nil {
                print("check for error : \(error!.localizedDescription)")
                self.showAlert(message: "게시글 등록 실패")
            } else {
                self.showAlertForWrite()
            }
        }
    }

    func showAlertForWrite() {
        let alert = UIAlertController(title: "등록 완료",
                                      message: "게시글 등록이 완료되었습니다",
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

extension InformationWriteViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        print("start")
        if contentValue.text == "content" {
            textView.text = ""
            textView.textColor = .black
        } else if contentValue.text == "" {
            contentValue.text = "content"
            contentValue.textColor = .lightGray
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        print("end")
        if textView.text == "" {
            contentValue.text = "content"
            contentValue.textColor = .lightGray
        }
    }
}
