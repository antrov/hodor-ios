//
//  UserCell.swift
//  Hodor
//
//  Created by Antrov on 22.09.2017.
//  Copyright © 2017 Antrov. All rights reserved.
//

import UIKit

class UserCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var avatarImgView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        avatarImgView.layer.masksToBounds = true
        avatarImgView.layer.cornerRadius = 24
    }
}
