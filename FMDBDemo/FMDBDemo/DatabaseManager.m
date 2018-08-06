//
//  DatabaseManager.m
//  FMDBDemo
//
//  Created by WingChing_Yip on 2018/8/2.
//  Copyright © 2018年 ywc. All rights reserved.
//

#import "DatabaseManager.h"
#import "FMDatabase.h"
#import "Student.h"

@implementation DatabaseManager


/// 单例
+ (DatabaseManager *)share
{
    static DatabaseManager *instances = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instances = [[DatabaseManager alloc] init];
    });
    return instances;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
       
    }
    return self;
}

/// 返回数据库的存取路径
- (NSString *)dbPath
{
    return NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES)[0];
}



@end
