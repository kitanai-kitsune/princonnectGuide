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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
