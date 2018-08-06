//
//  Student.h
//  FMDBDemo
//
//  Created by WingChing_Yip on 2018/8/2.
//  Copyright © 2018年 ywc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Student : NSObject

@property (nonatomic , copy , readwrite) NSString *name;

@property (nonatomic , copy , readwrite) NSString *sex;

@property (nonatomic , assign) int age;

@property (nonatomic , assign) int studentID;

@end
