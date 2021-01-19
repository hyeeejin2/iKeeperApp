//
//  PublicMoneyDetailViewController.swift
//  ikeeperApp
//
//  Created by 김혜진 on 2021/01/19.
//

import UIKit

class PublicMoneyDetailViewController: UIViewController {

    @IBOutlet weak var categoryControl: UISegmentedControl!
    @IBOutlet weak var amountValue: UITextField!
    @IBOutlet weak var sumValue: UITextField!
    @IBOutlet weak var historyDateValue: UITextField!
    @IBOutlet weak var createDateValue: UITextField!
    @IBOutlet weak var writerValue: UITextField!
    @IBOutlet weak var memoValue: UITextField!
    @IBOutlet weak var editBarButton: UIBarButtonItem!
    @IBOutlet weak var completeButton: UIButton!
    var dataList = [String: Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        completeButton.isHidden = true
        setDisabled()
        setValue()
    }
    
    func setEnabled() {
        categoryControl.isEnabled = true
        amountValue.isEnabled = true
        historyDateValue.isEnabled = true
        //createDateValue.isEnabled = true
        //writerValue.isEnabled = true
        memoValue.isEnabled = true
    }
    
    func setDisabled() {
        categoryControl.isEnabled = false
        amountValue.isEnabled = false
        historyDateValue.isEnabled = false
        createDateValue.isEnabled = false
        writerValue.isEnabled = false
        memoValue.isEnabled = false
    }
    
    func setValue() {
        let category = dataList["category"] as? String
        if category == "수입" {
            categoryControl.selectedSegmentIndex = 0
        } else {
            categoryControl.selectedSegmentIndex = 1
        }
        amountValue.text = dataList["amount"] as? String
        sumValue.text = dataList["sum"] as? String
        historyDateValue.text = dataList["history date"] as? String
        createDateValue.text = dataList["create date"] as? String
        writerValue.text = dataList["writer"] as? String
        memoValue.text = dataList["memo"] as? String
    }
    
    @IBAction func editButton(_ sender: UIBarButtonItem) {
        editBarButton.title = ""
        editBarButton.isEnabled = false
        completeButton.isHidden = false
        setEnabled()
    }
    
    @IBAction func completeButton(_ sender: UIButton) {
        editBarButton.title = "edit"
        editBarButton.isEnabled = true
        completeButton.isHidden = true
        setDisabled()
    }
}
