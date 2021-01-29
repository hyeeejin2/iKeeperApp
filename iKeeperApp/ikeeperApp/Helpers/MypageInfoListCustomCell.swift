//
//  MypageInfoListCustomCell.swift
//  ikeeperApp
//
//  Created by 김혜진 on 2021/01/29.
//

import UIKit

class MypageInfoListCustomCell: UITableViewCell {
    
    @IBOutlet weak var numLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var viewsLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
