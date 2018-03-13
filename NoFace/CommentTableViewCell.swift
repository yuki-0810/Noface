//
//  CommentTableViewCell.swift
//  NoFace
//
//  Created by 阿部悠輝 on 2017/08/13.
//  Copyright © 2017年 yuki.abe. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class CommentTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userComment: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCommentInfo(){
        //ユーザー名取得
        
        //ユーザー画像の取得
        let commentsRef = Database.database().reference().child(Const.PostPath).child("comments")
        let user = Auth.auth().currentUser
        var userImgString = ""
        
        commentsRef.child((user?.uid)!).observe(.value, with: { snapshot in
            print(snapshot.value)
            
            
        })
    }
    
}
