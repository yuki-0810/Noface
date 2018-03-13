//
//  LogInAfterViewController.swift
//  NoFace
//
//  Created by 阿部悠輝 on 2017/07/28.
//  Copyright © 2017年 yuki.abe. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FacebookLogin
import KeychainAccess

class LogInAfterViewController: UIViewController {
    
    @IBOutlet weak var handleFacebookLoginButton: UIButton!
    @IBOutlet weak var handleLoginButton: UIButton!
    
    @IBOutlet weak var mailAddressTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    let keychain = Keychain(service: "com.NoFace")
    
    @IBAction func handleLoginButton(_ sender: Any) {
        if let address = mailAddressTextField.text, let password = passwordTextField.text {
            
            // アドレスとパスワード名のいずれかでも入力されていない時は何もしない
            if address.characters.isEmpty || password.characters.isEmpty {
                return
            }
            Auth.auth().signIn(withEmail: address, password: password) { user, error in
                if let error = error {
                    print("DEBUG_PRINT: " + error.localizedDescription)
                    return
                } else {
                    print("DEBUG_PRINT: ログインに成功しました。")
                    
                    try!self.keychain.set((Auth.auth().currentUser?.uid)!, key: "id")
                    DispatchQueue.main.async {
                        let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "Home")
                        self.present(loginViewController!, animated: true, completion: nil)
                    }
                }
            }
        }
            
    }
    

    @IBAction func logIn(_ sender: UIButton) {
        LoginManager().logIn([.email], viewController: self, completion: {
            result in
            switch result {
            case let .success( permission, declinePemisson, token):
                print("token:\(token),\(permission),\(declinePemisson)")
                let credential = FacebookAuthProvider.credential(withAccessToken: token.authenticationToken)
                Auth.auth().signIn(with: credential, completion: { (user, error) in
                    if user != nil {
                        print("Facebook ログインが成功しました。")
                        // Home画面へ遷移
                        self.presentingViewController?.dismiss(animated: true, completion: nil)
                        return
                    }
                    // Facebook のログインは成功しましたが、Firebase との連携に失敗しました。
                    print("DEBUG_PRINT: " + (error?.localizedDescription)!)
                })
                
            case let .failed(error):
                print("error:\(error)")
            case .cancelled:
                print("cancelled")
            }
            
        })

    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        handleFacebookLoginButton.layer.cornerRadius = 13.0
        handleLoginButton.layer.cornerRadius = 13.0

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
