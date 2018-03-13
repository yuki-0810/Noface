//
//  CommentViewController.swift
//  NoFace
//
//  Created by 阿部悠輝 on 2017/08/09.
//  Copyright © 2017年 yuki.abe. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class CommentViewController: UIViewController,UITableViewDelegate, UITableViewDataSource  {
    
    let fruits = ["リンゴ", "みかん", "ぶどう"]

    @IBOutlet weak var commentTableView: UITableView!
    @IBOutlet weak var commentTextField: UITextField!
    @IBAction func handlePostComment(_ sender: UIButton) {
        
        //Notification Center
        let dic: Dictionary = ["CommentText":commentTextField.text!]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "GETPOSTDATA"), object: nil, userInfo: dic )
        
        //BaseViewControllerに遷移
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let baseViewController = storyboard.instantiateViewController(withIdentifier: "Base") as? BaseViewController
        self.show(baseViewController!, sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        commentTableView.delegate = self
        commentTableView.dataSource = self
        
        // テーブルセルのタップを無効にする
        commentTableView.allowsSelection = false
        
        let nib = UINib(nibName: "CommentTableViewCell", bundle: nil)
        commentTableView.register(nib, forCellReuseIdentifier: "Cell")
        commentTableView.rowHeight = UITableViewAutomaticDimension
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        // セルを取得する
        let cell = commentTableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath as IndexPath) as! CommentTableViewCell
        cell.setCommentInfo()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        // Auto Layoutを使ってセルの高さを動的に変更する
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // セルをタップされたら何もせずに選択状態を解除する
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
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
