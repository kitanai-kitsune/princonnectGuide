//
//  RealmDataBase.swift
//  princonnectGuide
//
//  Created by 金超 on 2020/8/26.
//  Copyright © 2020 jinchao. All rights reserved.
//

import Foundation
import RealmSwift

class RealmPrincessData:Object{
    @objc dynamic var characterIcon:String = ""
    @objc dynamic var characterName:String = ""
    @objc dynamic var characterStar:Int = 1
    @objc dynamic var haveSixStar:Bool = false
    @objc dynamic var realName:String = ""
}
