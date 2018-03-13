//
//  PostViewController.swift
//  NoFace
//
//  Created by 阿部悠輝 on 2017/08/01.
//  Copyright © 2017年 yuki.abe. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class PostViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    var image: UIImage!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textField: UITextView!
    @IBOutlet weak var charmPickUpField: UITextField!
    
    var charmPickerView: UIPickerView = UIPickerView()
    var charmList = [""]
    var charmString = "@"
    
    func getCharms(){
        let idsRef = Database.database().reference().child(Const.IdPath)
        let user = Auth.auth().currentUser
        
        idsRef.child((user?.uid)!).observe(.value, with: { snapshot in
            // チャームを取得
            let charms = snapshot.value as! [String]
            print(charms)
            for charm in charms {
                //ピッカービュー用のチャーム配列
                self.charmList.append(charm)
                //投稿セル用のチャーム配列
                self.charmString += "\(charm),"
            }

            let _charm:NSMutableString = NSMutableString(string: self.charmString)
            _charm.deleteCharacters(in: NSRange(location: _charm.length - 1, length: 1))
            self.charmString = (_charm as String)

        })
    }
    
    @IBAction func handleLibraryButton(_ sender: Any) {
        // ライブラリ（カメラロール）を指定してピッカーを開く
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            let pickerController = UIImagePickerController()
            pickerController.delegate = self
            pickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
            self.present(pickerController, animated: true, completion: nil)
        }
    }
    
    // 写真を撮影/選択したときに呼ばれるメソッド
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if info[UIImagePickerControllerOriginalImage] != nil {
            // 撮影/選択された画像を取得する
            let image = info[UIImagePickerControllerOriginalImage] as! UIImage
            imageView.image = image
        }
        
        // 閉じる
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // 閉じる
        picker.dismiss(animated: true, completion: nil)
    }

    @IBAction func handlePostButton(_ sender: UIButton) {
       //ImageViewから画像を取得する
        let imageData = UIImageJPEGRepresentation(imageView.image!, 0.5)
        let imageString = imageData!.base64EncodedString(options: .lineLength64Characters)
        
        // postDataに必要な情報を取得しておく
        let time = NSDate.timeIntervalSinceReferenceDate
        let name = Auth.auth().currentUser?.displayName
        
        // 辞書を作成してFirebaseに保存する
        let postRef = Database.database().reference().child(Const.PostPath)
        let postData = ["caption": textField.text!,"image": imageString, "time": String(time), "name": name!, "charm": charmPickUpField.text!, "selfcharm": charmString ]
        postRef.childByAutoId().setValue(postData)
        
        UIApplication.shared.keyWindow?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        imageView.image = image
        
        //ユーザーの魅力を格納
        getCharms()
        
        //genderPickerのデリゲート設定
        charmPickerView.delegate = self
        charmPickerView.dataSource = self
        charmPickerView.showsSelectionIndicator = true
        
        let toolbar = UIToolbar(frame: CGRectMake(0, 0, 0, 35))
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(SignUpViewController.done))
        toolbar.setItems([doneItem], animated: true)
        
        self.charmPickUpField.inputView = charmPickerView
        self.charmPickUpField.inputAccessoryView = toolbar
        
        
    }

    //genderPickerのファンクション設定
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return charmList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return charmList[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.charmPickUpField.text = charmList[row]
    }
    
    func done() {
        self.charmPickUpField.endEditing(true)
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
