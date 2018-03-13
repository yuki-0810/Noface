//
//  HomeViewController.swift
//  NoFace
//
//  Created by 阿部悠輝 on 2017/07/29.
//  Copyright © 2017年 yuki.abe. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import KeychainAccess

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    private var postTableView: UITableView!
    let keychain = Keychain(service: "com.NoFace")
    
    @IBOutlet weak var naviBarHome: UINavigationBar!
    
    var postArray: [PostData] = []
    var observing = false
    var observePostData: PostData?
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // セルを取得してデータを設定する
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath as IndexPath) as! PostTableViewCell
        cell.setPostData(postData: postArray[indexPath.row])
        
        // セル内のボタンのアクションをソースコードで設定する
        // いいねボタン
        cell.likeButton.addTarget(self, action:#selector(handleButton(sender:event:)), for:  UIControlEvents.touchUpInside)
        
        //コメントボタン
        cell.commentButton.addTarget(self, action:#selector(handleCommentButton(sender:event:)), for:  UIControlEvents.touchUpInside)
        
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
    
    // セル内のボタンがタップされた時に呼ばれるメソッド(いいねボタン)
    func handleButton(sender: UIButton, event:UIEvent) {
        print("DEBUG_PRINT: likeボタンがタップされました。")
        
        // タップされたセルのインデックスを求める
        let touch = event.allTouches?.first
        let point = touch!.location(in: self.postTableView)
        let indexPath = postTableView.indexPathForRow(at: point)
        
        // 配列からタップされたインデックスのデータを取り出す
        let postData = postArray[indexPath!.row]
        
        // Firebaseに保存するデータの準備
        if let uid = Auth.auth().currentUser?.uid {
            if postData.isLiked {
                // すでにいいねをしていた場合はいいねを解除するためIDを取り除く
                var index = -1
                for likeId in postData.likes {
                    if likeId == uid {
                        // 削除するためにインデックスを保持しておく
                        index = postData.likes.index(of: likeId)!
                        break
                    }
                }
                postData.likes.remove(at: index)
            } else {
                postData.likes.append(uid)
            }
            
            // 増えたlikesをFirebaseに保存する
            let postRef = Database.database().reference().child(Const.PostPath).child(postData.id!)
            let likes = ["likes": postData.likes]
            postRef.updateChildValues(likes)
            
        }
    }
    
    // セル内のボタンがタップされた時に呼ばれるメソッド(コメントボタン)
    func handleCommentButton(sender: UIButton, event:UIEvent) {
        print("DEBUG_PRINT: Commentボタンがタップされました。")
        
        //タップされたセルのインデックス
        let touch = event.allTouches?.first
        let point = touch!.location(in: self.postTableView)
        let indexPath = postTableView.indexPathForRow(at: point)
        
        // 配列からタップされたインデックスのデータを取り出す
        observePostData = postArray[indexPath!.row]
        
        //NotificationCenterでpostDataの値を渡す
        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.setCommentPost(_:)), name: NSNotification.Name(rawValue: "GETPOSTDATA"), object: nil)
        
        //CommentViewControllerに遷移
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let commentViewController = storyboard.instantiateViewController(withIdentifier: "CommentView") as? CommentViewController
        self.show(commentViewController!, sender: nil)
        
    }
    
    //NotificationCenter：CommentViewController内の投稿ボタンを押すと発火
    func setCommentPost(_ center:Notification?){
        print("pass")
        if let dic: [AnyHashable: Any] = (center as NSNotification?)?.userInfo {
            
            //NotificationCenterから投稿されたCommentを取得
            let comment = dic["CommentText"]! as! String
            print(comment)
            print(observePostData!)
            
            //ユーザー名取得
            let userName = Auth.auth().currentUser?.displayName
            
            //ユーザー画像の取得
            let userImgRef = Database.database().reference().child(Const.ProfileImagePath)
            let user = Auth.auth().currentUser
            var userImgString = ""
            
            userImgRef.child((user?.uid)!).observe(.value, with: { snapshot in
                
                // Get user value
                userImgString = snapshot.value as! String
                print(userImgString)
            
            // 辞書を作成してFirebaseに保存する
            let postRef = Database.database().reference().child(Const.PostPath).child((self.observePostData?.id!)!)
            let comments = ["name":userName, "userimage": userImgString, "comment":comment]
            postRef.child("comments").childByAutoId().setValue( comments )
                
            })
            UIApplication.shared.keyWindow?.rootViewController?.dismiss(animated: true, completion: nil)
        }
        
        NotificationCenter.default.removeObserver(self,name: NSNotification.Name(rawValue: "GETPOSTDATA"), object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Status Barの高さを取得する.
        let barHeight: CGFloat = 0
        
        // Viewの高さと幅を取得する.
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height
        
        // TableViewの生成(Status barの高さをずらして表示).
        postTableView = UITableView(frame: CGRect(x: 0, y: barHeight, width: displayWidth, height: displayHeight))
        
        // Cell名の登録をおこなう.
        let nib = UINib(nibName: "PostTableViewCell", bundle: nil)
        postTableView.register(nib, forCellReuseIdentifier: "Cell")
        postTableView.rowHeight = UITableViewAutomaticDimension
        
        
        // DataSourceを自身に設定する.
        postTableView.dataSource = self
        
        // Delegateを自身に設定する.
        postTableView.delegate = self
        
        // Viewに追加する.
        self.view.addSubview(postTableView)
        
        // テーブルセルのタップを無効にする
        postTableView.allowsSelection = false
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("DEBUG_PRINT: viewWillAppear")
        
        if Auth.auth().currentUser != nil {
            if self.observing == false {
                // 要素が追加されたらpostArrayに追加してTableViewを再表示する
                let postsRef = Database.database().reference().child(Const.PostPath)
                postsRef.observe(.childAdded, with: { snapshot in
                    print("DEBUG_PRINT: .childAddedイベントが発生しました。")
                    
                    // PostDataクラスを生成して受け取ったデータを設定する
                    if let uid = Auth.auth().currentUser?.uid {
                        let postData = PostData(snapshot: snapshot, myId: uid)
                        self.postArray.insert(postData, at: 0)
                        
                        // TableViewを再表示する
                        self.postTableView.reloadData()
                    }
                })
                // 要素が変更されたら該当のデータをpostArrayから一度削除した後に新しいデータを追加してTableViewを再表示する
                postsRef.observe(.childChanged, with: { snapshot in
                    print("DEBUG_PRINT: .childChangedイベントが発生しました。")
                    
                    if let uid = Auth.auth().currentUser?.uid {
                        // PostDataクラスを生成して受け取ったデータを設定する
                        let postData = PostData(snapshot: snapshot, myId: uid)
                        
                        // 保持している配列からidが同じものを探す
                        var index: Int = 0
                        for post in self.postArray {
                            if post.id == postData.id {
                                index = self.postArray.index(of: post)!
                                break
                            }
                        }
                        
                        // 差し替えるため一度削除する
                        self.postArray.remove(at: index)
                        
                        // 削除したところに更新済みのでデータを追加する
                        self.postArray.insert(postData, at: index)
                        
                        // TableViewの現在表示されているセルを更新する
                        self.postTableView.reloadData()
                    }
                })
                
                // FIRDatabaseのobserveEventが上記コードにより登録されたため
                // trueとする
                observing = true
            }
        } else {
            if observing == true {
                // ログアウトを検出したら、一旦テーブルをクリアしてオブザーバーを削除する。
                // テーブルをクリアする
                postArray = []
                postTableView.reloadData()
                // オブザーバーを削除する
                Database.database().reference().removeAllObservers()
                
                // FIRDatabaseのobserveEventが上記コードにより解除されたため
                // falseとする
                observing = false
            }
        }
        
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
