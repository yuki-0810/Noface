//
//  LoginViewController.swift
//  NoFace
//
//  Created by 阿部悠輝 on 2017/07/28.
//  Copyright © 2017年 yuki.abe. All rights reserved.
//

import UIKit
import VideoSplashKit

class LoginViewController:VideoSplashViewController {
    
    @IBOutlet weak var handleCreateButton: UIButton!
    @IBOutlet weak var handleLoginButton: UIButton!
    
    @IBAction func createAccountButton(_ sender: Any) {
    }
    @IBAction func logInButton(_ sender: Any) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupVideo()
        
        handleCreateButton.layer.cornerRadius = 13.0
        handleLoginButton.layer.cornerRadius = 13.0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setupVideo() {
        if let path = Bundle.main.path(forResource: "TopVideoForNoFace", ofType: "mp4") {
            let url = NSURL.fileURL(withPath: path)
            videoFrame = view.frame
            fillMode = .resizeAspectFill
            alwaysRepeat = true
            restartForeground = true
            sound = true
            startTime = 0.0
            duration = 0.0
            alpha = 0.7
            backgroundColor = UIColor.black
            contentURL = url
        }
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
