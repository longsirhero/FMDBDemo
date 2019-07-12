//
//  XWStudentRealmTool.swift
//  RealmDemo
//
//  Created by WingChing_Yip on 2018/8/1.
//  Copyright © 2018年 ywc. All rights reserved.
//

import UIKit

import RealmSwift


/// 需求： 插入1名学生信息到本地数据库
class XWStudentRealmTool: Object {
    private class func getDB() -> Realm {
        let docPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0] as String
        let dbPath = docPath.appending("/defaultDB.realm")
        /// 传入路径会自动创建数据库
        let defaultRealm = try! Realm(fileURL: URL.init(string: dbPath)!)
        return defaultRealm
    }
}

extension XWStudentRealmTool {
    // MARK: - 增
    /// 保存学生数据
    ///
    /// - Parameter student: 保存一个学生数据
    public class func insertStudent(by student: Student) -> Void {
        let defaultRealm = self.getDB()
        try! defaultRealm.write {
            defaultRealm.add(student)
        }
    }
    
    /// 保存学生数据
    ///
    /// - Parameter students: 保存多个学生数据
    public class func insertStudents(by students: [Student]) -> Void {
        let defalutReaml = self.getDB()
        try! defalutReaml.write {
            defalutReaml.add(students)
        }
    }
    
    // MARK: - 查
    
    /// 普通查询
    ///
    /// - Returns: 查询结果集
    public class func getStudents() -> Results<Student> {
        let defaultReaml = self.getDB()
        return defaultReaml.objects(Student.self)
    }
    
    
    /// 获取指定id（主键）的student
    ///
    /// - Parameter id: 主键
    /// - Returns: student
    public class func getStudent(from id: Int) -> Student? {
        let defaultRealm = self.getDB()
        return defaultRealm.object(ofType: Student.self, forPrimaryKey: id)
    }
    
    
    /// 获取 指定条件 的Student (断言查询)
    ///
    /// - Parameter term: 查询条件
    /// - Returns: 结果集
    public class func getStudentByTerm(_ term: String) -> Results<Student> {
        let defaultRealm = self.getDB()
        let predicate = NSPredicate(format: term)
        let results = defaultRealm.objects(Student.self)
        return results.filter(predicate)
    }
    
    // mark: - 改(更新)
    
    /// 更新单个学生
    ///
    /// - Parameter student: 需要更新的学生
    public class func updateStudent(student: Student) {
        let defaultRealm = self.getDB()
        try! defaultRealm.write {
            defaultRealm.add(student, update: true)
        }
    }
    
    /// 更新多个学生
    ///
    /// - Parameter students: 需要更新的学生们
    public class func updateStudents(students: [Student]) {
        let defaultReaml = self.getDB()
        try! defaultReaml.write {
            defaultReaml.add(students, update: true)
        }
    }
    
    /// 键值更新
    ///
    /// - Parameter age: 更新年龄
    public class func updateStudentAge(age: Int) {
        let defaultReaml = self.getDB()
        try! defaultReaml.write {
            let students = defaultReaml.objects(Student.self)
            students.setValue(age, forKey: "age")
        }
    }
    
    // MARK: - 删除
    
    /// 删除单个学生
    ///
    /// - Parameter student: 某学生
    public class func deleteStudent(student: Student) {
        let defaultRealm = self.getDB()
        try! defaultRealm.write {
            defaultRealm.delete(student)
        }
    }
    
    
    /// 删除多个学生
    ///
    /// - Parameter students: 多个学生对象
    public class func deleteStudents(students: Results<Student>) {
        let defaultRealm = self.getDB()
        try! defaultRealm.write {
            defaultRealm.delete(students)
        }
    }
}
