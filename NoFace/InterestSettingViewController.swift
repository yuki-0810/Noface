//
//  InterestSettingViewController.swift
//  NoFace
//
//  Created by 阿部悠輝 on 2017/07/30.
//  Copyright © 2017年 yuki.abe. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import KeychainAccess

class InterestSettingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    let keychain = Keychain(service: "com.NoFace")
    
    var onlyCheck:[String] = []
    var countTrue:[Bool] = []
    var selectedCount = 0
    
    @IBOutlet weak var BodyCell: UITableView!
    @IBOutlet weak var SportsCell: UITableView!
    @IBOutlet weak var TechCell: UITableView!
    

    /// セルのリスト配列
    let cellList: [DictionaryLiteral<String, String>] = [
        [
            "手":"hand",
            "腕":"arm",
            "胸":"chest",
            "髪":"hair",
            "肩":"shoulder",
            "首":"neck",
            "お腹":"stomach",
            "脚":"leg",
            "足":"foot"
        ],
        [
            "バスケットボール":"basketball",
            "テニス": "tennis",
            "サッカー": "soccer",
            "陸上":"land",
            "野球": "baseball",
            "ダーツ": "darts",
            "水泳":"swimming",
            "ビリヤード":"billiards",
            "バレーボール":"volleyball",
            "釣り":"Fishing",
            "格闘技":"combats",
            "バドミントン":"badminton"
        ],
        [
            "プログラミング": "progamming",
            "料理": "cook",
            "写真": "picture",
            "絵": "art",
            "漫画": "manga"
        ]]
    
    /// チェック配列
    var checkList: [[String: Bool]] = [[:]]
    
    
    /// セルの個数を指定するデリゲートメソッド（必須）
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellList[tableView.tag].count
    }
    
    /// セルに値を設定するデータソースメソッド（必須）
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        
        if tableView.tag == 0 {
            let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "BodyCell", for: indexPath)
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            cell.textLabel!.text = cellList[tableView.tag][indexPath.row].key
            
            if checkList[tableView.tag + 1][cellList[tableView.tag][indexPath.row].key] == true{
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
            print(checkList[tableView.tag + 1])
            
            return cell
        } else if tableView.tag == 1 {
            let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "SportsCell", for: indexPath)
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            cell.textLabel!.text = cellList[tableView.tag][indexPath.row].key
            
            if checkList[tableView.tag + 1][cellList[tableView.tag][indexPath.row].key] == true{
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
            return cell
        } else if tableView.tag == 2 {
            let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "TechCell", for: indexPath)
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            cell.textLabel!.text = cellList[tableView.tag][indexPath.row].key
            
            if checkList[tableView.tag + 1][cellList[tableView.tag][indexPath.row].key] == true{
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
            return cell
        }
        
        return cell
    }
    
    /// セルが選択された時に呼ばれるデリゲートメソッド
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print(selectedCount)
        
        
        if selectedCount < 3 && checkList[tableView.tag + 1][cellList[tableView.tag][indexPath.row].key]! == false{
            selectedCount += 1
            selectedCell(count: selectedCount)
        }
        print(selectedCount)
        print(checkList[tableView.tag + 1][cellList[tableView.tag][indexPath.row].key]!)
        
        // ３個以上選択されていない場合、かつ、まだ選択されていないものを選択した場合
        if selectedCount != 4 && checkList[tableView.tag + 1][cellList[tableView.tag][indexPath.row].key]! == false{
            
            // チェックリスト更新処理
            checkList[tableView.tag + 1][cellList[tableView.tag][indexPath.row].key] = true
            
            //チェックマークを付与
            let cell = tableView.cellForRow(at:indexPath)
            cell?.accessoryType = .checkmark
            
            if selectedCount == 3 {
                selectedCount += 1
                selectedCell(count: selectedCount)
            }
        }
        
        print(checkList[tableView.tag + 1][cellList[tableView.tag][indexPath.row].key]!)
        
    }
    
    //選択済みのセルをカウントするファンクション
    func selectedCell (count:Int){
        if count > 3{
            selectedCount = 4
        }
        if count <= 0{
            selectedCount = 0
        }
    }
    
    // セルの選択が外れた時に呼び出される
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        print(selectedCount)
        
        if checkList[tableView.tag + 1][cellList[tableView.tag][indexPath.row].key]! == true && selectedCount <= 4{
            selectedCount -= 1
            selectedCell(count: selectedCount)
        }
        
        print(selectedCount)
        print(checkList[tableView.tag + 1][cellList[tableView.tag][indexPath.row].key]!)
        
        if selectedCount <= 3 && checkList[tableView.tag + 1][cellList[tableView.tag][indexPath.row].key]! == true{
            
            // チェックリスト更新処理
            checkList[tableView.tag + 1][cellList[tableView.tag][indexPath.row].key] = false
            // チェックマークを外す
            let cell = tableView.cellForRow(at:indexPath)
            cell?.accessoryType = .none
            
            if selectedCount == 3 {
                selectedCount -= 1
                selectedCell(count: selectedCount)
            }
        }
        print(checkList[tableView.tag + 1][cellList[tableView.tag][indexPath.row].key]!)
        
    }
    
    
    @IBAction func nextHomeButton(_ sender: UIBarButtonItem) {
        
        let idsRef = Database.database().reference().child(Const.InterestPath)
        let user = Auth.auth().currentUser
        
        for i in 0..<checkList.count {
            for (key, value) in checkList[i] {
                if value == true {
                    onlyCheck.append(key)
                    print(onlyCheck)
                    
                }
            }
        }
        idsRef.child((user?.uid)!).setValue(onlyCheck)
        
        if self.keychain["id"] != nil && self.keychain["charmFlag"] != nil {
            try!self.keychain.set((Auth.auth().currentUser?.uid)!, key: "interestFlag")
        }
        
        self.performSegue(withIdentifier: "nextFinishView", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        // チェック配列の初期化
        cellList.forEach {
            // 初期化チェック配列
            var result: [String: Bool] = [:]
            $0.forEach {
                // 要素文繰り返してfalseで初期化
                result[$0.key] = false
            }
            // 格納append
            checkList.append(result)
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
