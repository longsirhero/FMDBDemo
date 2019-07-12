//
//  ViewController.swift
//  RealmDemo
//
//  Created by WingChing_Yip on 2018/7/31.
//  Copyright © 2018年 ywc. All rights reserved.
//

import UIKit
import RealmSwift


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        testInsertStudent()
//        testInsertStudentWithPhotoBook()
//        testInsertManyStudent()
//        getStudents()
//        testSearchStudentByID()
//        testSearchTermStudent()
//        testSorted()
//        testUpdateStudents()
//        testUpdateStudentsAge()
//        testDeleteOneStudent()
//        testDeleteAllStudent()
    }
}

extension ViewController {
    /// 1、需求: 插入 1 名学生信息到本地数据库
    private func testInsertStudent() {
        let stu = Student()
        stu.name = "极客学院"
        stu.age = 26
        stu.id = 3
        
        let birthdayStr = "1992-05-01"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        stu.birthday = dateFormatter.date(from: birthdayStr)! as NSDate
        
        stu.weight = 120
        stu.address = "莲塘"
        XWStudentRealmTool.insertStudent(by: stu)
    }
    
    /// 2、需求: 测试在数据库中插入一个拥有多本书的学生对象
    private func testInsertStudentWithPhotoBook() {
        let stu = Student()
        stu.name = "极客学院_有头像_有书"
        stu.weight = 120
        stu.age = 20
        stu.id = 5
        
        let bookFubaba = Book.init(value: ["富爸爸穷爸爸", "[美]罗伯特.T.清崎"])
        let bookShenMingbuxi = Book.init(value: ["生命不息, 折腾不止", "罗永浩"])
        let bookDianfuzhe = Book(value: ["颠覆者：周鸿伟自传", "周鸿伟"])
        stu.books.append(bookFubaba)
        stu.books.append(bookShenMingbuxi)
        stu.books.append(bookDianfuzhe)
        
        XWStudentRealmTool.insertStudent(by: stu)
    }
    
    /// 3、需求: 测试在数据库中插入44个的学生对象
    private func testInsertManyStudent() {
        var stus = [Student]()
        
        for i in 100...144 {
            let stu = Student()
            stu.name = "极客学院_\(i)"
            stu.weight = 120
            stu.age = 18
            stu.id = i
            
            let birthdayStr = "1993-06-10"
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "YYYY-MM-dd"
            stu.birthday = dateFormatter.date(from: birthdayStr)! as NSDate
            stus.append(stu)
        }
        
        XWStudentRealmTool.insertStudents(by: stus)
    }
    
    /// 4、普通查询: 查询数据库中所有学生模型并输出姓名，图片，所拥有的书信息
    private func getStudents() {
        let stus = XWStudentRealmTool.getStudents()
        for stu in stus {
            print(stu.name)
            if stu.photo != nil {
                print(stu.photo ?? NSData.init())
            }
            if stu.books.count > 0 {
                for book in stu.books {
                    print(book.name + "+" + book.author)
                }
            }
        }
    }
    
    /// 5、主键查询： 查询数据库中id为110的学生模型并输出姓名
    private func testSearchStudentByID() {
        let student = XWStudentRealmTool.getStudent(from: 110)
        if let student = student {
            print(student.name)
        }
    }
    
    /// 6、条件查询
    func testSearchTermStudent() {
        let students = XWStudentRealmTool.getStudentByTerm("name = '极客学院_110'")
        if students.count == 0 {
            print("未查询到任何数据")
            return
        }
        
        for student in students {
            print(student.name, student.weight)
        }
    }
    
    /// 7、升序/降序 查询
    private func testSorted() {
        // 升序查询
        let realm = try! Realm()
        let stus = realm.objects(Student.self).sorted(byKeyPath: "id")
        print("升序结果：\(stus)")
        // 降序查询
        let stuss = realm.objects(Student.self).sorted(byKeyPath: "id", ascending: false)
        print("降序结果: \(stuss)")
    }
    
    /// 8、批量更改
    private func testUpdateStudents() {
        var stus = [Student]()
        for i in 100...144 {
            let stu = Student()
            stu.name = "极客学院改名_\(i)"
            stu.weight = 148
            stu.age = 27
            stu.id = i
            stus.append(stu)
        }
        XWStudentRealmTool.updateStudents(students: stus)
    }
    
    /// 9、 键值更新 - 所有学生 年龄 改为 18
    private func testUpdateStudentsAge() {
        XWStudentRealmTool.updateStudentAge(age: 18)
    }
    
    /// 10、删除id为3的学生
    private func testDeleteOneStudent() {
        let stu = XWStudentRealmTool.getStudent(from: 3)
        if stu != nil {
            XWStudentRealmTool.deleteStudent(student: stu!)
        }
    }
    
    /// 11、删除所有的学生
    private func testDeleteAllStudent() {
        let stus = XWStudentRealmTool.getStudents()
        XWStudentRealmTool.deleteStudents(students: stus)
    }
}
