//
//  SettingController.swift
//  princonnectGuide
//
//  Created by 金超 on 2020/8/9.
//  Copyright © 2020 jinchao. All rights reserved.
//

import UIKit
import Kingfisher

class SettingController: UIViewController {
    
    let alert = UIAlertController(title: "清除缓存", message: "确认清除缓存", preferredStyle: .alert)
    
    @IBAction func clearCache(_ sender: Any) {
        
        present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func deleteFile(_ sender: Any) {
                
        if let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last{
        let iconFilePath = path.appendingPathComponent("/icons")
        let pictureFilePath = path.appendingPathComponent("/pictures")
            
            do{
                try FileManager.default.removeItem(at: iconFilePath)
                try FileManager.default.createDirectory(at: iconFilePath, withIntermediateDirectories: true, attributes: nil)
                try FileManager.default.removeItem(at: pictureFilePath)
                try FileManager.default.createDirectory(at: pictureFilePath, withIntermediateDirectories: true, attributes: nil)
            }catch{
                print(error)
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setCacheUsage()
        
        alert.addAction(UIAlertAction(title: "确定", style: .default, handler: { (_) in
            ImageCache.default.clearCache()
            ImageCache.default.clearDiskCache()
            self.calculateDisk()
            
        }))
        
        alert.addAction(UIAlertAction(title: "取消", style: .default, handler: { (_) in
            
        }))
        
    }
    
    @IBOutlet weak var hardDisk: UILabel!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        calculateDisk()
        
    }
    
    //MARK:- 计算磁盘占用
    func calculateDisk(){
        ImageCache.default.calculateDiskStorageSize { result in
            switch result {
            case .success(let size):
                let a = round(Double(size) / 1024 / 1024)
                self.hardDisk.text = "当前占用硬盘:\(a)MB"
                print("磁盘缓存大小: \(Double(size) / 1024 / 1024) MB")
            case .failure(let error):
                print(error)
            }
        }
    }
    
    //MARK:- 设置内存与磁盘占用
    func setCacheUsage(){
    //设置磁盘缓存大小
    ImageCache.default.diskStorage.config.sizeLimit = 100 * 1024 * 1024
    //设置内存缓存大小
    ImageCache.default.memoryStorage.config.totalCostLimit = 50 * 1024 * 1024
    }
    
}
