//
//  SignUpViewController.swift
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

class SignUpViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var handleFacebookSignUp: UIButton!
    @IBOutlet weak var handleCreateAccountButton: UIButton!
    
    @IBOutlet weak var mailAddressTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var displayNameTextField: UITextField!
    @IBOutlet weak var genderTextField: UITextField!
    
    var genderPickerView: UIPickerView = UIPickerView()
    let genderList = ["","Male","Female"]
    
    let keychain = Keychain(service: "com.NoFace")
    
    @IBAction func handleCreateAccountButton(_ sender: Any) {
        if let address = mailAddressTextField.text, let password = passwordTextField.text, let displayName = displayNameTextField.text, let genderName = genderTextField.text {
            
            // アドレスとパスワードと表示名のいずれかでも入力されていない時は何もしない
            if address.characters.isEmpty || password.characters.isEmpty || displayName.characters.isEmpty || genderName.isEmpty {
                print("DEBUG_PRINT: 何かが入力されていません。")
                return
            }
            Analytics.setUserProperty(genderName, forName: "gender")
            
            Auth.auth().createUser(withEmail: address, password: password) { user, error in
                if let error = error {
                    // エラーがあったら原因をprintして、returnすることで以降の処理を実行せずに処理を終了する
                    print("DEBUG_PRINT: " + error.localizedDescription)
                    return
                }
                print("DEBUG_PRINT: ユーザー作成に成功しました。")
                
                // 表示名を設定する
                let user = Auth.auth().currentUser
                if let user = user {
                    let changeRequest = user.createProfileChangeRequest()
                    changeRequest.displayName = displayName
                    changeRequest.commitChanges { error in
                        if let error = error {
                            print("DEBUG_PRINT: " + error.localizedDescription)
                        }
                        print("DEBUG_PRINT: [displayName = \(user.displayName!)]の設定に成功しました。")
                        
                        let idsRef = Database.database().reference().child(Const.GenderPath)
                        let user = Auth.auth().currentUser
                        idsRef.child((user?.uid)!).setValue(genderName)
                        
                        let imageData = UIImageJPEGRepresentation(UIImage(named:"profile-picture")!, 0.5)
                        let imageString = imageData!.base64EncodedString(options: .lineLength64Characters)
                        let imgIdsRef = Database.database().reference().child(Const.ProfileImagePath)
                        imgIdsRef.child((user?.uid)!).setValue(imageString)
                        
                        try!self.keychain.set((Auth.auth().currentUser?.uid)!, key: "id")
                        self.performSegue(withIdentifier: "nextNaviController", sender: nil)

                    }
                } else {
                    print("DEBUG_PRINT: displayNameの設定に失敗しました。")
                }
            }
        }
        
    }
    
    

    @IBAction func signUp(_ sender: Any) {
        LoginManager().logIn([.email], viewController: self, completion: {
            result in
            switch result {
            case let .success( permission, declinePemisson, token):
                print("token:\(token),\(permission),\(declinePemisson)")
                let credential = FacebookAuthProvider.credential(withAccessToken: token.authenticationToken)
                Auth.auth().signIn(with: credential, completion: { (user, error) in
                    if user != nil {
                        print("Facebook ログインが成功しました。")
                        // 魅力登録画面へ遷移
                        DispatchQueue.main.async {
                            let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "CharmSetting")
                            self.present(loginViewController!, animated: true, completion: nil)
                        }
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
        
        //ボタンの角を丸くする
        handleFacebookSignUp.layer.cornerRadius = 13.0
        handleCreateAccountButton.layer.cornerRadius = 13.0
        
        //genderPickerのデリゲート設定
        genderPickerView.delegate = self
        genderPickerView.dataSource = self
        genderPickerView.showsSelectionIndicator = true
        
        let toolbar = UIToolbar(frame: CGRectMake(0, 0, 0, 35))
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(SignUpViewController.done))
        toolbar.setItems([doneItem], animated: true)
        
        self.genderTextField.inputView = genderPickerView
        self.genderTextField.inputAccessoryView = toolbar
        
    }
    
    //genderPickerのファンクション設定
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return genderList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return genderList[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.genderTextField.text = genderList[row]
    }
    
    func done() {
        self.genderTextField.endEditing(true)
    }
    
    func CGRectMake(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) -> CGRect {
        return CGRect(x: x, y: y, width: width, height: height)
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
