//
//  FriendListTableViewCell.swift
//  NoFace
//
//  Created by 阿部悠輝 on 2017/07/29.
//  Copyright © 2017年 yuki.abe. All rights reserved.
//

import UIKit

class FriendListTableViewCell: UITableViewCell {

    @IBOutlet weak var friendList: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
