//
//  BaseViewController.swift
//  NoFace
//
//  Created by 阿部悠輝 on 2017/08/07.
//  Copyright © 2017年 yuki.abe. All rights reserved.
//

import UIKit
import PagingMenuController
import KeychainAccess

class BaseViewController: UIViewController {
    
    @IBOutlet weak var pagingMenuView: UIView!
    
    let keychain = Keychain(service: "com.NoFace")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //キーチェーンの有無の確認
        checkFlag()

        //PagingMenuのオプション設定
        let options = PostShowsPagingOptions()
        
        let pagingMenuController = PagingMenuController(options: options)
        addChildViewController(pagingMenuController)
        self.pagingMenuView.addSubview(pagingMenuController.view)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func checkFlag(){
        if self.keychain["id"] != nil && self.keychain["charmFlag"] != nil && self.keychain["interestFlag"] != nil {
            
        } else if self.keychain["id"] == nil {
            
            DispatchQueue.main.async {
                let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "Login")
                self.present(loginViewController!, animated: false, completion: nil)
            }
        } else if self.keychain["charmFlag"] == nil {
            
            //アラートを表示
            let alert = UIAlertController(title:"パーソナリティの設定", message: "魅力が登録されていません。設定画面に戻って登録を行ってください。", preferredStyle: UIAlertControllerStyle.alert)
            
            let charmSet = UIAlertAction(title: "設定する", style: UIAlertActionStyle.default, handler: {
                (action: UIAlertAction!) in
                
                DispatchQueue.main.async {
                    let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "SetNav")
                    self.present(loginViewController!, animated: false, completion: nil)
                }
            })
            
            alert.addAction(charmSet)
            DispatchQueue.main.async {
                self.present(alert, animated: true, completion: nil)
            }
            
        } else if self.keychain["interestFlag"] == nil{
            
            //アラートを表示
            let alert = UIAlertController(title:"パーソナリティの設定", message: "興味が登録されていません。設定画面に戻って登録を行ってください。", preferredStyle: UIAlertControllerStyle.alert)
            
            let charmSet = UIAlertAction(title: "設定する", style: UIAlertActionStyle.default, handler: {
                (action: UIAlertAction!) in
                
                DispatchQueue.main.async {
                    let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "SetNav")
                    self.present(loginViewController!, animated: false, completion: nil)
                }
            })
            
            alert.addAction(charmSet)
            DispatchQueue.main.async {
                self.present(alert, animated: true, completion: nil)
            }
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
