//
//  HistoryCell.swift
//  Hodor
//
//  Created by Antrov on 20.09.2017.
//  Copyright © 2017 Antrov. All rights reserved.
//

import UIKit

class HistoryCell: UITableViewCell {
    @IBOutlet weak var avatarImgView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        avatarImgView.layer.masksToBounds = true
        avatarImgView.layer.cornerRadius = 12
    }
}
