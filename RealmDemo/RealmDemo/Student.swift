//
//  Student.swift
//  RealmDemo
//
//  Created by WingChing_Yip on 2018/7/31.
//  Copyright © 2018年 ywc. All rights reserved.
//

import UIKit
import RealmSwift

class Student: Object {
    @objc dynamic var name = ""
    @objc dynamic var age = 18
    @objc dynamic var weight = 156
    @objc dynamic var id = 0
    @objc dynamic var address = ""
    @objc dynamic var birthday: NSDate? = nil
    @objc dynamic var photo: NSData? = nil
    
    // 重写Object.primaryKey() 可以设置模型的主键
    // 声明主键之后，对象将被允许查询，更新速度更加高效，并且要求每个对象保持唯一性
    // 一旦带有主键的对象被添加到realm之后，该对象的主键将不可修改
    override static func primaryKey() -> String? {
        return "id"
    }
    
    // 重写 Object.ignoredProperties() 可以防止 Realm 存取数据模型的某个属性
    override static func ignoredProperties() -> [String] {
        return ["tempID"]
    }
    
    // 重写 Object.indexedProperties() 方法可以为数据模型中需要添加索引的属性建立索引，Realm 支持为字符串、整型、布尔值以及 Date 属性建立索引。
    override static func indexedProperties() -> [String] {
        return ["name"]
    }
    
    // List 用来表示一对多的关系： 一个 Student 中有拥有多个 book
    let books = List<Book>()
    
    // MARK: -注意的是在使用reaml中存取的数据模型都要是 Object类的子类
}
