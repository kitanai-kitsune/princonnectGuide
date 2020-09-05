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
    
    let alert = UIAlertController(title: "清除缓存", message: "确认清楚缓存", preferredStyle: .alert)

    @IBAction func clearCache(_ sender: Any) {
               
        present(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        alert.addAction(UIAlertAction(title: "确定", style: .default, handler: { (_) in
            ImageCache.default.clearCache()
            ImageCache.default.clearDiskCache()
        }))
        

        // Do any additional setup after loading the view.
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
