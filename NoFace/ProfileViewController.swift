//
//  ProfileViewController.swift
//  NoFace
//
//  Created by 阿部悠輝 on 2017/07/29.
//  Copyright © 2017年 yuki.abe. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import PagingMenuController
import KeychainAccess

class ProfileViewController: UIViewController {

    @IBOutlet weak var pagingSubMenuView: UIView!
    @IBOutlet weak var displayName: UILabel!
    @IBOutlet weak var profileBackImage: UIImageView!
    @IBOutlet weak var charmLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    
    var charmString = "@"
    let keychain = Keychain(service: "com.NoFace")
    
    @IBAction func handleLogOutButton(_ sender: UIButton) {
        // ログアウトする
        try! Auth.auth().signOut()
        try!self.keychain.remove("id")
        try!self.keychain.remove("charmFlag")
        try!self.keychain.remove("interestFlag")
        
        // ログイン画面を表示する
        let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "Login")
        self.present(loginViewController!, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // ユーザーネーム取得・表示
        let userName = Auth.auth().currentUser
        if let userName = userName {
            displayName.text = userName.displayName
        }
        
        // PagingMenuViewの設定
        let options = PostShowsPagingOptions()
        
        let pagingMenuController = PagingMenuController(options: options)
        addChildViewController(pagingMenuController)
        self.pagingSubMenuView.addSubview(pagingMenuController.view)
        
        //プロフィール画像表示
        profileImage.clipsToBounds = true
        profileImage.layer.cornerRadius = 20.0
        
        //Charm取得・表示
        let idsRef = Database.database().reference().child(Const.IdPath)
        let user = Auth.auth().currentUser
        
        idsRef.child((user?.uid)!).observe(.value, with: { snapshot in
            // Get user value
            let charms = snapshot.value as! [String]
            print(charms)
            for charm in charms {
                self.charmString += "\(charm),"
            }
            let _charm:NSMutableString = NSMutableString(string: self.charmString)
            _charm.deleteCharacters(in: NSRange(location: _charm.length - 1, length: 1))
            
            self.charmString = (_charm as String)
            self.charmLabel.text = self.charmString
        })
        

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
