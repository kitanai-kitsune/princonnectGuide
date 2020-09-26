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
    @IBOutlet weak var currentVersion: UILabel!
    @IBOutlet weak var remoteVersion: UILabel!
    
    let claerCacheAlert = UIAlertController(title: "清除缓存", message: "确认清除缓存", preferredStyle: .alert)
    let deleteFileAlert = UIAlertController(title: "清除数据", message: "确认清除数据", preferredStyle: .alert)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 44
        
        if let version: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String {
          versionLabel.text = version
        }
                
        setCacheUsage()
        
        claerCacheAlert.addAction(UIAlertAction(title: "确定", style: .default, handler: { (_) in
            ImageCache.default.clearCache()
            ImageCache.default.clearDiskCache()
            self.calculateDisk()
        }))
        
        claerCacheAlert.addAction(UIAlertAction(title: "取消", style: .default, handler: { (_) in
            
        }))
        
        deleteFileAlert.addAction(UIAlertAction(title: "确定", style: .default, handler: { (_) in
            
            let documentsPath = NSHomeDirectory() + "/Documents"
            let iconFilePath = documentsPath + "/icons"
            let pictureFilePath = documentsPath + "/pictures"
            
            if FileManager.default.fileExists(atPath: iconFilePath){
                do{
                    try FileManager.default.removeItem(atPath: iconFilePath)
                }catch{
                    print(error)
                }
            }else{
                do{
                    try FileManager.default.createDirectory(atPath: iconFilePath, withIntermediateDirectories: true, attributes: nil)
                }catch{
                    print(error)
                }
            }
            
            if FileManager.default.fileExists(atPath: pictureFilePath){
                do{
                    try FileManager.default.removeItem(atPath: pictureFilePath)
                }catch{
                    print(error)
                }
            }else{
                do{
                    try FileManager.default.createDirectory(atPath: pictureFilePath, withIntermediateDirectories: true, attributes: nil)
                }catch{
                    print(error)
                }
            }
            
            self.tableView.reloadData()
            
        }))
        
        deleteFileAlert.addAction(UIAlertAction(title: "取消", style: .default, handler: { (_) in
            
        }))

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        calculateDisk()
        
        if FileManager.default.fileExists(atPath: NSHomeDirectory() + "/Documents/icons") && FileManager.default.fileExists(atPath: NSHomeDirectory() + "/Documents/pictures"){
            fileStorage.text = String(calculateFileUsage(filePath: "pictures") + calculateFileUsage(filePath: "icons")) + "MB"
        }
        currentVersion.text = String(UserDefaults.standard.integer(forKey: "currentVersion"))
        remoteVersion.text = String(UserDefaults.standard.integer(forKey: "remoteVersion"))
        
        tableView.reloadData()
        
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
            return 3
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
                print(error)
            }
        }
         return fileSize
    }
    
    //MARK:- 计算文件夹大小
    func calculateFileUsage(filePath: String) -> Float{
        var size: Float = 0.0
        do{
            let contents = try FileManager.default.contentsOfDirectory(atPath: NSHomeDirectory() + "/Documents/" + filePath)
            for content in contents {
                let pathForEachFile = NSHomeDirectory() + "/Documents/" + filePath + "/\(content)"
                let attributes = try FileManager.default.attributesOfItem(atPath: pathForEachFile)
                size += attributes[FileAttributeKey.size]! as! Float / 1000000
            }
        }catch{
            print(error)
        }
        return round(size)
    }
    
}
