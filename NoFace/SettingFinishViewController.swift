//
//  SettingFinishViewController.swift
//  NoFace
//
//  Created by 阿部悠輝 on 2017/08/06.
//  Copyright © 2017年 yuki.abe. All rights reserved.
//

import UIKit

class SettingFinishViewController: UIViewController {
    
    @IBOutlet weak var letsStartButton: UIButton!
    
    @IBAction func finishSettingButton(_ sender: UIButton) {

        var target = self.presentingViewController
        
        while target?.presentingViewController != nil {
            target = target?.presentingViewController
        }
        if target != nil {
            target?.dismiss(animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        letsStartButton.layer.cornerRadius = 13.0
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
