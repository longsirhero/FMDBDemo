//
//  Book.swift
//  RealmDemo
//
//  Created by WingChing_Yip on 2018/7/31.
//  Copyright © 2018年 ywc. All rights reserved.
//

import UIKit

import RealmSwift

class Book: Object {
    
    @objc dynamic var name = ""
    @objc dynamic var author = ""
    
    /// LikingObjects 反向表示该对象的拥有者(反向关系)
    let owners = LinkingObjects(fromType: Student.self, property: "books")
}
