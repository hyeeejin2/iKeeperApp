//
//  InfoCustomCell.swift
//  ikeeperApp
//
//  Created by 김혜진 on 2020/11/20.
//

import UIKit

class InfoCustomCell: UITableViewCell {
    @IBOutlet weak var numLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var viewsLable: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var writerLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
/*
    override func prepareForReuse() {
        super.prepareForReuse()
        self.numLabel.text = nil
        self.titleLabel.text = nil
        self.viewsLable.text = nil
        self.dateLabel.text = nil
        self.timeLabel.text = nil
        self.writerLabel.text = nil
    }
 */
}
