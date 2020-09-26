//
//  ProfileDatas.swift
//  princonnectGuide
//
//  Created by 金超 on 2020/9/21.
//  Copyright © 2020 jinchao. All rights reserved.
//

import Foundation
import RealmSwift

class RealmProfileData:Object{
    @objc dynamic var catchCopy:String = ""
    @objc dynamic var height:String = ""
    @objc dynamic var weight:String = ""
    @objc dynamic var birthday:String = ""
    @objc dynamic var bloodType:String = ""
}
