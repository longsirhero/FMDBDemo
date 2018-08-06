//
//  DatabaseManager.h
//  FMDBDemo
//
//  Created by WingChing_Yip on 2018/8/2.
//  Copyright © 2018年 ywc. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Student;

@interface DatabaseManager : NSObject


/// 单例
+ (DatabaseManager *)share;

///// 插入数据
//- (BOOL)insertStudent:(Student *)student;
//
///// 查询数据
//- (NSArray *)getAllDatas;
//
///// 删除数据
//- (BOOL)deleteStudent:(Student *)student;
//
///// 更新数据
//- (BOOL)updateStudent:(Student *)student;


@end
