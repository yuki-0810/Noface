//
//  EditingProfileViewController.swift
//  NoFace
//
//  Created by 阿部悠輝 on 2017/08/08.
//  Copyright © 2017年 yuki.abe. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import PagingMenuController


class EditingProfileViewController: UIViewController {
    
    @IBOutlet weak var editName: UILabel!
    @IBOutlet weak var editBackgroundImage: UIImageView!
    @IBOutlet weak var editProfileImage: UIImageView!
    
    var charm1PickerView: UIPickerView = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // ユーザーネーム取得・表示
        let userName = Auth.auth().currentUser
        if let userName = userName {
            editName.text = userName.displayName
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
