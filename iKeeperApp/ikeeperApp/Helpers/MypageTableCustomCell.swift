//
//  MypageTableCustomCell.swift
//  ikeeperApp
//
//  Created by 김혜진 on 2021/01/25.
//

import UIKit

class MypageTableCustomCell: UITableViewCell {
    
    @IBOutlet weak var functionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
