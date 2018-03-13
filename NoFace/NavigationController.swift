//
//  NavigationController.swift
//  NoFace
//
//  Created by 阿部悠輝 on 2017/08/05.
//  Copyright © 2017年 yuki.abe. All rights reserved.
//

import UIKit
import KeychainAccess

class NavigationController: UINavigationController {

    let keychain = Keychain(service: "com.NoFace")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if self.keychain["charmFlag"] == nil {
            self.performSegue(withIdentifier: "nextCharm", sender: nil)
        } else if self.keychain["interestFlag"] == nil{
            self.performSegue(withIdentifier: "nextInterest", sender: nil)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        
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
