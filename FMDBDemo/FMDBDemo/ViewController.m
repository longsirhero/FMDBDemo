//
//  ViewController.m
//  FMDBDemo
//
//  Created by WingChing_Yip on 2018/8/2.
//  Copyright © 2018年 ywc. All rights reserved.
//

// https://blog.csdn.net/hepiju7427/article/details/79891812

#import "ViewController.h"

#import <FMDatabase.h>
#import <FMDatabaseQueue.h>

@interface ViewController ()



@end

@implementation ViewController

// MAKR: -更新数据
- (IBAction)update:(UIButton *)sender {
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    NSString *file = [doc stringByAppendingPathComponent:@"student.sqlite"];
    NSLog(@"%@",file);
    
    //2.获得数据库
    FMDatabase *db = [FMDatabase databaseWithPath:file];
    
    //3.使用如下语句，如果打开失败，可能是权限不足或者资源不足。通常打开完操作操作后，需要调用 close 方法来关闭数据库。在和数据库交互 之前，数据库必须是打开的。如果资源或权限不足无法打开或创建数据库，都会导致打开失败。
    if ([db open]){
        //4.创表
        BOOL result = [db executeUpdate:@"CREATE TABLE IF NOT EXISTS student (studentID integer PRIMARY KEY AUTOINCREMENT, name text NOT NULL, age integer NOT NULL);"];
        if (result){
            NSLog(@"创建表成功");
            // INSERT INTO student (name, age) VALUES (?, ?);
            // 1、executeUpdate
            NSString * sql = @"INSERT INTO student (name, age) VALUES(?, ?);";
            NSString * name = @"静静";
            BOOL res = [db executeUpdate:sql, name, @2];
            
            // 2、BOOL res = [db executeUpdateWithFormat:@"INSERT INTO student (name, age) VALUES (%@, %d);", name, 1];
            if (!res) {
                NSLog(@"插入失败");
                
            } else {
                NSLog(@"插入成功");
            }
            
            // 3、还可以使用- (BOOL)executeStatements:(NSString *)sql;或者 - (BOOL)executeStatements:(NSString *)sql withResultBlock:(__attribute__((noescape)) FMDBExecuteStatementsCallbackBlock _Nullable)block; 将多个SQL执行语句写在一个字符串中，并执行。
            /*
                 NSString *sql1 = @"CREATE TABLE IF NOT EXISTS school (schoolID text PRIMARY KEY, schoolName text NOT NULL, address text NOT NULL);"
                "insert into school (schoolID,schoolName,address) values ('1','第一中学','阿里部落');"
                ;
                BOOL res1 =  [db executeStatements:sql1];
             */
            
            //查看最后一条错误信息
            NSString *errorStr = [db lastErrorMessage];
            NSLog(@"%@",errorStr);
            
            //查看最后一条错误
            NSError *error = [db lastError];
            NSLog(@"%@",error);
            
            [db close];
        }else {
            NSLog(@"创建表失败");
        }
    }
}

// MARK: -查询数据
- (IBAction)query:(UIButton *)sender {
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *file = [doc stringByAppendingPathComponent:@"student.sqlite"];
    NSLog(@"%@", file);
    // 获得数据库
    FMDatabase *db = [FMDatabase databaseWithPath:file];
    if ([db open]) {
        FMResultSet *results = [db executeQuery:@"SELECT * FROM student"];
        // 遍历结果
        while ([results next]) {
            int ID = [results intForColumn:@"studentID"];
            NSString *name = [results stringForColumn:@"name"];
            int age = [results intForColumn:@"age"];
            NSLog(@"%d, %@, %d", ID, name, age);
        }
    }
}

// MARK: -删除数据
- (IBAction)delete:(UIButton *)sender {
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *file = [doc stringByAppendingPathComponent:@"student.sqlite"];
    FMDatabase *db = [FMDatabase databaseWithPath:file];
    if ([db open]) {
        BOOL res = [db executeUpdate:@"delete from student where studentID = ?;", @(1)];
        if (res) {
            NSLog(@"删除成功");
        } else {
            NSLog(@"删除失败");
        }
    }
}

// MARK: -多线程处理
// FMDatabase这个类是线程不安全的，如果在多个线程中同时使用一个
// FMDatabase实例，会造成数据混乱等问题。
// 为了保证线程安全，FMDB提供方便快捷的FMDatabaseQueue。
- (IBAction)queue:(UIButton *)sender {
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *file = [doc stringByAppendingPathComponent:@"student.sqlite"];
    
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:file];
    dispatch_queue_t q1 = dispatch_queue_create("queue1", NULL);
    dispatch_queue_t q2 = dispatch_queue_create("queue2", NULL);
    
    dispatch_async(q1, ^{
        for (int i = 0; i < 50; i++) {
            [queue inDatabase:^(FMDatabase * _Nonnull db) {
                if ([db open]) {
                    NSString *insertSql1 = [NSString stringWithFormat:@"INSERT INTO '%@' ('%@', %@) VALUES (?, ?)", @"student", @"name", @"age"];
                    NSString *name = [NSString stringWithFormat:@"深深 %d", i];
                    NSString *age = [NSString stringWithFormat:@"%d", 10+i];
                    
                    BOOL res = [db executeUpdate: insertSql1, name, age];
                    if (!res) {
                        NSLog(@"error to inster data: %@",name);
                    } else {
                        NSLog(@"succ to inster data: %@", name);
                    }
                }
            }];
        }
    });
    
    dispatch_async(q2, ^{
        for (int i = 0; i < 50; i++) {
            [queue inDatabase:^(FMDatabase * _Nonnull db) {
                if ([db open]) {
                    NSString *insertSql2= [NSString stringWithFormat:
                                           @"INSERT INTO '%@' ('%@', '%@') VALUES (?, ?)",
                                           @"student", @"name", @"age"];
                    
                    NSString * name = [NSString stringWithFormat:@"静静 %d", i];
                    NSString * age = [NSString stringWithFormat:@"%d", 10+i];
                    
                    BOOL res = [db executeUpdate:insertSql2, name, age];
                    if (!res) {
                        NSLog(@"error to inster data: %@", name);
                    } else {
                        NSLog(@"succ to inster data: %@", name);
                    }
                }
            }];
        }
    });
}


// MARK: -事务
/*
 
 说一下事务是什么，比如说我们有一个学生表和一个学生成绩表，而且一个学生对应一个学生成绩。比如小明的成绩是100分，那么我们要写两个sql语句对不同的表进行插入数据。但是如果在这个过程中，小明这个学生成功的插入到数据库，而成绩插入时失败了，怎么办？这时事务就突出了它的作用。用事务可以对两个表进行同时插入，一旦一个表插入失败，那么就会进行事务回滚，就是让另一个表也不进行插入数据了。
 简单的说也就是，事务可以让多个表的数据同时插入，一旦有一个表操作失败，那么其他表也都会失败。当然这种说法是为了理解，不是严谨的。
 那么对一个表大量插入数据时也可以用事务。比如sqlite3。
 数据库中insert into语句等操作是比较耗时的，假如我们一次性插入几百几千条数据就
 会造成主线程阻塞，以至于UI界面卡住。那么这时候我们就要开启一个事物来进行操作。
 原因就是它以文件的形式存在磁盘中，每次访问时都要打开一次文件，如果对数据库进行大量的操作，就很慢。可是如果我们用事务的形式提交，开始事务后，进行的大量操作语句都保存在内存中，当提交时才全部写入数据库，此时，数据库文件也只用打开一次。如果操作错误，还可以回滚事务。
 */

// MARK: -事务的基本使用
- (IBAction)basicInTransaction:(UIButton *)sender {
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *file = [doc stringByAppendingPathComponent:@"student.sqlite"];
    
    FMDatabase *db = [FMDatabase databaseWithPath:file];
    BOOL isSuccess = [db open];
    if (!isSuccess) {
        NSLog(@"打开数据库失败");
    }
    [db beginTransaction];
    BOOL isRollBack = NO;
    @try {
        for (int i = 0; i < 500; i++) {
            NSString *nId = [NSString stringWithFormat:@"%d",i];
            NSString *strName = [[NSString alloc] initWithFormat:@"student_%d",i];
            NSString *sql = @"INSERT INTO student (name, age) VALUES (?,?)";
            BOOL a = [db executeUpdate:sql, strName, nId];
            if (!a) {
                NSLog(@"插入失败！");
            }
        }
    } @catch (NSException *exception) {
        isRollBack = YES;
        [db rollback];
    } @finally {
        if (!isRollBack) {
            [db commit];
        }
    }
    [db close];
}

// MARK: -多线程使用事务
- (IBAction)queueInTransaction:(UIButton *)sender {
    NSDate *date1 = [NSDate date];
    
    // 创建表
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *dbPath = [docPath stringByAppendingPathComponent:@"student.sqlite"];
    
    // 多线程安全FMDatabaseQueue可以代替dataBase
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:dbPath];
    
    // 开启事务
    [queue inTransaction:^(FMDatabase * _Nonnull db, BOOL * _Nonnull rollback) {
        if (![db open]) {
            return NSLog(@"事务打开失败");
        }
        
        BOOL result = [db executeUpdate:@"CREATE TABLE IF NOT EXISTS student (studentID integer PRIMARY KEY AUTOINCREMENT, name text NOT NULL, age integer NOT NULL);"];
        
        if (!result) {
            NSLog(@"error when creating student table");
            
            [db close];
        }
        
        for (int i = 0; i<500; i++) {
            
            NSString *insertSql2= [NSString stringWithFormat:
                                   @"INSERT INTO '%@' ('%@', '%@') VALUES (?, ?)",
                                   @"student", @"name", @"age"];
            
            NSString * name = [NSString stringWithFormat:@"静静 %d", i];
            NSString * age = [NSString stringWithFormat:@"%d", 10+i];
            
            BOOL result = [db executeUpdate:insertSql2, name, age];;
            if ( !result ) {
                //当最后*rollback的值为YES的时候，事务回退，如果最后*rollback为NO，事务提交
                *rollback = YES;
                return;
            }
        }
        
        //        [db close];
        NSDate *date2 = [NSDate date];
        NSTimeInterval a = [date2 timeIntervalSince1970] - [date1 timeIntervalSince1970];
        NSLog(@"FMDatabaseQueue使用事务插入500条数据用时%.3f秒",a);
    }];
    
}





@end
