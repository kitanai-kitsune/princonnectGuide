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
        
        let storageRef = Storage.storage().reference()
        
        AF.request("https://raw.githubusercontent.com/kitanai-kitsune/PCRCharacterData/master/CharactorDatas.json").responseJSON { response in
            if let json = response.value{
                let data = JSON(json)//获取系统可读取可使用的JSON数据格式(等于是转码) JSON()
                
                for num in 0...data.count - 1{
                    
                    //下载六星大图
                    if data[num,"replace","havesixstar"].boolValue == true{
                        let sixStarPictureName = data[num,"name"].stringValue + "6dai"
                        let ref6dai = storageRef.child("pictures/\(sixStarPictureName).png")
                        if let documentDirectoryFileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last {
                            let sixStarPicturePath = documentDirectoryFileURL.appendingPathComponent("pictures/\(sixStarPictureName).png")
                            ref6dai.write(toFile: sixStarPicturePath)
                            
                            ref6dai.write(toFile: sixStarPicturePath).observe(.progress){ snapshot in

                                let percentComplete = 100.0 * Double(snapshot.progress!.completedUnitCount) / Double(snapshot.progress!.totalUnitCount)

                                print("六星大图下载进度:\(percentComplete)")

                            }
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
                    
                    
                    if let documentDirectoryFileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last {
                        
                        //分配下载路径
                        let iconFilePath = documentDirectoryFileURL.appendingPathComponent("icons/\(iconName).png")
                        let pictureFilePath = documentDirectoryFileURL.appendingPathComponent("pictures/\(bigPictureName).png")
                        
                        ref.write(toFile: iconFilePath)
                        ref3dai.write(toFile: pictureFilePath)
                        
                    }
                }
            }
        }
    }
}

