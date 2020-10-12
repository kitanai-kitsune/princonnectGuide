//
//  DetailInformationExtension.swift
//  princonnectGuide
//
//  Created by 金超 on 2020/9/12.
//  Copyright © 2020 jinchao. All rights reserved.
//

import Foundation
import Firebase
import SwiftyJSON
import Alamofire

extension PrincessController {
        
    func downloadToLocal(){
        var sixStarPictureNumbers = 0
        var threeStarPictureNumbers = 0
        var iconNumbers = 0
        
        let storageRef = Storage.storage().reference()
        
        AF.request("https://raw.githubusercontent.com/kitanai-kitsune/PCRCharacterData/master/CharactorDatas.json").responseJSON { response in
            if let json = response.value{
                let data = JSON(json)//获取系统可读取可使用的JSON数据格式 JSON()
                let documentDirectory = "file://" + NSHomeDirectory() + "/Documents"
                
                for num in 0...data.count - 1{
                                        
                    //下载六星大图
                    if data[num,"replace","havesixstar"].boolValue == true{
                        let sixStarPictureName = data[num,"name"].stringValue + "6dai"
                        let ref6dai = storageRef.child("pictures/\(sixStarPictureName).png")
                        let sixStarPicturePath = documentDirectory + "/pictures/\(sixStarPictureName).png"
                        
                        let downloadSixStarTask = ref6dai.write(toFile: URL(string: sixStarPicturePath)!)
                                                
                        downloadSixStarTask.observe(.success) { snapshot in
                            sixStarPictureNumbers += 1
                            //print("sixStarPictureNumbers:\(sixStarPictureNumbers)")
                        }
                    }
                    
                    //下载三星大图
                    let bigPictureName = data[num,"name"].stringValue + "3dai"
                    let ref3dai = storageRef.child("pictures/\(bigPictureName).png")
                    
                    //下载小图标
                    var iconName = data[num,"name"].stringValue
                    if data[num,"replace","defaultstar"].intValue == 3{
                        iconName = iconName + "3"
                    }else{
                        iconName = iconName + "1"
                    }
                    
                    let ref = storageRef.child("icons/\(iconName).png")
                                        
                    //分配下载路径
                    let iconFilePath = documentDirectory + "/icons/\(iconName).png"
                    let pictureFilePath = documentDirectory + "/pictures/\(bigPictureName).png"
                        
                    let downloadIconTask = ref.write(toFile: URL(string: iconFilePath)!)
                    let downloadThreeStarTask = ref3dai.write(toFile: URL(string: pictureFilePath)!)
                    
                    downloadIconTask.observe(.success) { snapshot in
                        iconNumbers += 1
                        //print("iconNumbers:\(iconNumbers)")
                    }
                    downloadThreeStarTask.observe(.success) { snapshot in
                        threeStarPictureNumbers += 1
                        print("threeStarPictureNumbers:\(threeStarPictureNumbers)")
                        let progress = Float(String(format: "%.2f", CGFloat(threeStarPictureNumbers) / CGFloat(data.count)))!
                        print(progress)
                        
                        if progress == 1.0{
                            print("下载完成")
                        }
                    }
                }
                                
            }
        }
    }
    
    func versionCheck() -> (result: Bool,remoteVersion: Int) {
        
        var currentVersion: Int
        var remoteVersion: Int = 0
        var result: Bool = false
        
        //UserDefaults.standard.set(20200920, forKey: "currentVersion")
        currentVersion = UserDefaults.standard.integer(forKey: "currentVersion")
        
        print("当前版本:\(currentVersion)")
        
        let semaphore = DispatchSemaphore(value: 0)
        let queue = DispatchQueue.global(qos: .utility)
                
        AF.request("https://raw.githubusercontent.com/kitanai-kitsune/PCRCharacterData/master/RemoteVersion.json").responseJSON(queue: queue) { responds in
            if let json = responds.value{
                let data = JSON(json)
                
                remoteVersion = data[0,"version"].intValue
                print("远程版本:\(remoteVersion)")
                UserDefaults.standard.set(remoteVersion, forKey: "remoteVersion")
                semaphore.signal()
            }
        }
        
        semaphore.wait()
        if currentVersion < remoteVersion {
            result = true
        }else{
            result = false
        }
        print("需要更新:\(result)")
        return (result, remoteVersion)
    }
    
}

