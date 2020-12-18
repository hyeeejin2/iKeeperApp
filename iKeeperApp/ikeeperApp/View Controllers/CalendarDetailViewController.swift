//
//  CalendarDetailViewController.swift
//  ikeeperApp
//
//  Created by 김혜진 on 2020/12/17.
//

import UIKit

class CalendarDetailViewController: UIViewController {

    @IBOutlet weak var titleValue: UITextField!
    @IBOutlet weak var writerValue: UITextField!
    @IBOutlet weak var categoryValue: UITextField!
    @IBOutlet weak var dateValue: UITextField!
    @IBOutlet weak var startValue: UITextField!
    @IBOutlet weak var endValue: UITextField!
    @IBOutlet weak var placeValue: UITextField!
    @IBOutlet weak var contentValue: UITextField!
    var data = [String: Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setDisabled()
        setValue()
    }
    
    func setDisabled() {
        titleValue.isEnabled = false
        writerValue.isEnabled = false
        categoryValue.isEnabled = false
        dateValue.isEnabled = false
        startValue.isEnabled = false
        endValue.isEnabled = false
        placeValue.isEnabled = false
        contentValue.isEnabled = false
    }
    
    func setValue() {
        titleValue.text = data["title"] as? String
        writerValue.text = data["writer"] as? String
        categoryValue.text = data["category"] as? String
        dateValue.text = data["date"] as? String
        startValue.text = data["startTime"] as? String
        endValue.text = data["endTime"] as? String
        placeValue.text = data["place"] as? String
        contentValue.text = data["content"] as? String
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
