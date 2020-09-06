//
//  PrincessController.swift
//  princonnectGuide
//
//  Created by 金超 on 2020/8/8.
//  Copyright © 2020 jinchao. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import RealmSwift

class PrincessController: UITableViewController {
    
    //在Model的RealmPrincessData中定义了RealmPrincessData有哪些属性 创建了一个叫RealmPrincessDatas的空数组 类型为Results
    var RealmPrincessDatas: Results<RealmPrincessData>?
    let realm = try! Realm()
    
    //只运行一次
    override func viewDidLoad() {
        super.viewDidLoad()
        
        saveAsRealmData()
        RealmPrincessDatas = realm.objects(RealmPrincessData.self)
        
    }
    
    //下拉刷新
    @IBAction func refresh(_ sender: Any) {
        
        saveAsRealmData()
        RealmPrincessDatas = realm.objects(RealmPrincessData.self)
        
        DispatchQueue.main.async {
            self.tableView.refreshControl?.endRefreshing()
        }
    }
    
    
    //几段 默认1
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    //几行=几个cell
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return RealmPrincessDatas?.count ?? 1//提供多少数据就给多少行
    }
    
    //配置每行里面显示什么
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PCR", for: indexPath) as! PrincessCell//重用哪个单元格 "PCR"
        
        //cell.textLabel?.text = "コッコロ"//如果cell里面有一个textLabel的话 给他付值 因为有可能没有所以加?
        //indexPath.row 行数 第N行
        //indexPath.section 段数 第N段
        
        /*
         在这里判断角色初始星数 如果是1和2显示什么图片 3显示什么图片 6显示什么图片(初始星数不可能是6)
         (因为无论是1星还是2星图片名全为XXX1.png 所以写在一起了)(显示小图用)
         */
        if let RealmPrincessDatas = RealmPrincessDatas{
            switch RealmPrincessDatas[indexPath.row].characterStar{
            case 3:
                cell.characterIcon.image = UIImage.init(named: RealmPrincessDatas[indexPath.row].characterIcon + "3")
                cell.characterName.text = RealmPrincessDatas[indexPath.row].characterName
            case 6:
                cell.characterIcon.image = UIImage.init(named: RealmPrincessDatas[indexPath.row].characterIcon + "6")
                cell.characterName.text = RealmPrincessDatas[indexPath.row].characterName
            default:
                cell.characterIcon.image = UIImage.init(named: RealmPrincessDatas[indexPath.row].characterIcon + "1")
                cell.characterName.text = RealmPrincessDatas[indexPath.row].characterName
            }
        }
        
        return cell
    }
    
    //当用户选择了cell之后发生了什么 cell指行 一行就是一个cell
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //PrincessDatas[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)//取消选择之后的灰色底色
    }
    
    //按下按钮时,去到下一个页面前做的事(等于正向传值 给下一个界面) 走的是detailInfoButton这条路线 detailInfoButton的destination是DetailInformationController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailInfoButton"{//先确定走的路线是detailInfoButton
            let vc = segue.destination as! DetailInformationController//然后确定路线的目的地是DetailInfomationController 并把它付值给vc
            let cell = sender as! PrincessCell//因为要从用户点的cell确定indexPath 所以这里先定义cell是哪个cell-PrincessCell
            let row = tableView.indexPath(for: cell)!.row//通过cell找到indexPath的行数  固定用法tableview.indexPath(for: )
            
            vc.DaiPicName = RealmPrincessDatas![row].characterIcon + "3" + "dai"//把值(角色大图名)付给vc里面(DetailInformationController)的DaiPicName值
            vc.Star = RealmPrincessDatas![row].characterStar//把值(星数)付给vc里面(DetailInformationController)的Star值
            vc.TitleName = RealmPrincessDatas![row].characterName//把值(角色名)付给vc里面(DetailInformationController)的TitleName值
            
            /*如果有6星则
             把值(角色6星大图名)付给vc(DetailInformationController)里面的Dai6PicName值
             把值有六星的信息付给vc(DetailInformationController)里面的have6Star
             */
            if RealmPrincessDatas![row].haveSixStar == true{
                vc.have6Star = true
                vc.Dai6PicName = RealmPrincessDatas![row].characterIcon + "6" + "dai"
            }
        }
    }
    
}

extension PrincessController:UISearchBarDelegate{
    //把JSON数据转换成Realm数据库
    func saveAsRealmData(){
        
        AF.request("https://raw.githubusercontent.com/kitanai-kitsune/PCRCharacterData/master/CharactorDatas.json").responseJSON { response in//http请求的最基本用法
            if let json = response.value{//如果成功取到值则付给json
                let data = JSON(json)//获取系统可读取可使用的JSON数据格式(等于是转码) JSON()
                
                do{
                    try self.realm.write {
                        self.realm.deleteAll()
                    }
                }catch{
                    print(error)
                }
                
                for num in 0...data.count - 1{
                    
                    let a = data[num,"name"].stringValue
                    //print(a)//找图片用
                    
                    let b = data[num,"katakana"].stringValue
                    //print(b)//显示名字片假名用
                    
                    let c = data[num,"replace","defaultstar"].intValue
                    //print(c)//显示角色初始星数
                    
                    let d = data[num,"replace","havesixstar"].boolValue
                    //print(d)//显示是否有6星
                    
                    let e = data[num,"replace","kannjimei"].stringValue
                    //print(e)//显示真名
                    
                    let realmPrincessData = RealmPrincessData()
                    
                    realmPrincessData.characterIcon = a
                    realmPrincessData.characterName = b
                    realmPrincessData.characterStar = c
                    realmPrincessData.haveSixStar = d
                    realmPrincessData.realName = e
                    
                    do{
                        try self.realm.write{
                            self.realm.add(realmPrincessData)
                        }
                    }catch{
                        print(error)
                    }
                    
                    self.tableView.reloadData()//获得数据之后刷新一次页面
                    
                }
                
                print("网络上共有\(data.count)条数据")
                print("本地共有\(self.RealmPrincessDatas!.count)条数据")
                
            }
        }
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        RealmPrincessDatas = realm.objects(RealmPrincessData.self)
        
        RealmPrincessDatas = RealmPrincessDatas?.filter("characterName CONTAINS %@", searchBar.text!)
        
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text!.isEmpty{
            
            RealmPrincessDatas = realm.objects(RealmPrincessData.self)
            tableView.reloadData()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }else{
            RealmPrincessDatas = realm.objects(RealmPrincessData.self)
            
            RealmPrincessDatas = RealmPrincessDatas?.filter("characterName CONTAINS %@", searchBar.text!)
            
            tableView.reloadData()
        }
    }
    
}
