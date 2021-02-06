//
//  AdminWarningListCustomCell.swift
//  ikeeperApp
//
//  Created by 김혜진 on 2021/02/05.
//

import UIKit

class AdminWarningListCustomCell: UITableViewCell {
    
    @IBOutlet weak var numLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var departmentLabel: UILabel!
    @IBOutlet weak var gradeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
