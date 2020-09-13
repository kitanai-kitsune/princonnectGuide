//
//  SettingTableController.swift
//  princonnectGuide
//
//  Created by 金超 on 2020/9/13.
//  Copyright © 2020 jinchao. All rights reserved.
//

import UIKit
import Kingfisher

class SettingTableController: UITableViewController {
    
    @IBOutlet weak var cacheUsage: UILabel!
    @IBOutlet weak var fileStorage: UILabel!
    @IBOutlet weak var versionLabel: UILabel!
    
    let claerCacheAlert = UIAlertController(title: "清除缓存", message: "确认清除缓存", preferredStyle: .alert)
    let deleteFileAlert = UIAlertController(title: "清除数据", message: "确认清除数据", preferredStyle: .alert)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let version: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String {
          versionLabel.text = version
        }
        
        fileStorage.text = "开发中"
        
        setCacheUsage()
        
        claerCacheAlert.addAction(UIAlertAction(title: "确定", style: .default, handler: { (_) in
            ImageCache.default.clearCache()
            ImageCache.default.clearDiskCache()
            self.calculateDisk()
        }))
        
        claerCacheAlert.addAction(UIAlertAction(title: "取消", style: .default, handler: { (_) in
            
        }))
        
        deleteFileAlert.addAction(UIAlertAction(title: "确定", style: .default, handler: { (_) in
            if let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last{
            let iconFilePath = path.appendingPathComponent("/icons")
            let pictureFilePath = path.appendingPathComponent("/pictures")
                
                do{
                    try FileManager.default.removeItem(at: iconFilePath)
                    try FileManager.default.createDirectory(at: iconFilePath, withIntermediateDirectories: true, attributes: nil)
                    try FileManager.default.removeItem(at: pictureFilePath)
                    try FileManager.default.createDirectory(at: pictureFilePath, withIntermediateDirectories: true, attributes: nil)
                    print("succeed")
                }catch{
                    print(error)
                }
            }
        }))
        
        deleteFileAlert.addAction(UIAlertAction(title: "取消", style: .default, handler: { (_) in
            
        }))

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        calculateDisk()
        
    }
    
    @IBAction func clearCache(_ sender: Any) {
        present(claerCacheAlert, animated: true, completion: nil)
    }
    
    @IBAction func deleteFile(_ sender: Any) {
        present(deleteFileAlert, animated: true, completion: nil)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section{
        case 0:
            return 4
        case 1:
            return 1
        default:
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK:- 设置内存与磁盘占用
    func setCacheUsage(){
    //设置磁盘缓存大小
    ImageCache.default.diskStorage.config.sizeLimit = 100 * 1024 * 1024
    //设置内存缓存大小
    ImageCache.default.memoryStorage.config.totalCostLimit = 50 * 1024 * 1024
    }
    
    //MARK:- 计算磁盘缓存占用
    func calculateDisk(){
        ImageCache.default.calculateDiskStorageSize { result in
            switch result {
            case .success(let size):
                let a = round(Double(size) / 1024 / 1024)
                self.cacheUsage.text = "\(a)MB"
                print("磁盘缓存大小: \(Double(size) / 1024 / 1024) MB")
            case .failure(let error):
                print(error)
            }
        }
    }
    
    //MARK:- 计算单个文件大小
    func calculateFileStorage(filePath: String) -> Float{
        
        let manager = FileManager.default
        var fileSize:Float = 0.0
        if manager.fileExists(atPath: filePath) {
          do {
             let attributes = try manager.attributesOfItem(atPath: filePath)
              if attributes.count != 0 {
                 fileSize = attributes[FileAttributeKey.size]! as! Float / 1000000
               }
            print("\(fileSize)MB")
            }catch{
            }
        }
         return fileSize
    }
    
    //MARK:- 计算文件大小
    
    
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
