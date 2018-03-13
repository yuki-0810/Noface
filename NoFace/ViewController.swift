//
//  ViewController.swift
//  NoFace
//
//  Created by 阿部悠輝 on 2017/07/28.
//  Copyright © 2017年 yuki.abe. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FacebookLogin

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // currentUserがnilならログインしていない
        if Auth.auth().currentUser == nil {
            // ログインしていないときの処理
            DispatchQueue.main.async {
                let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "Login")
                self.present(loginViewController!, animated: true, completion: nil)
            }
        }else{
            //Logged in ホーム画面を表示
            DispatchQueue.main.async {
                let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "Home")
                self.present(loginViewController!, animated: true, completion: nil)
            }
        }
        

    }

}

