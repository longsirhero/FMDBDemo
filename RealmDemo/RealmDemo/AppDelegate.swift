//
//  AppDelegate.swift
//  RealmDemo
//
//  Created by WingChing_Yip on 2018/7/31.
//  Copyright © 2018年 ywc. All rights reserved.
//

import UIKit
import RealmSwift


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        
        AppDelegate.configRealm()
        return true
    }
    
    /// 配置数据库
    public class func configRealm() {
        /// 如果要存取的数据模型属性发生变化，需要配置当前版本号比之前的大
        let dbVersion: UInt64 = 2
        let docPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0] as String
        let dbPath = docPath.appending("/defaultDB.realm")
        print("数据库路径:\(dbPath)")
        let config = Realm.Configuration(fileURL: URL.init(string: dbPath), inMemoryIdentifier: nil, syncConfiguration: nil, encryptionKey: nil, readOnly: false, schemaVersion: dbVersion, migrationBlock: { (migration, oldSchemaVersion) in
            
        }, deleteRealmIfMigrationNeeded: false, shouldCompactOnLaunch: nil, objectTypes: nil)
        Realm.Configuration.defaultConfiguration = config
        Realm.asyncOpen { (realm, error) in
            if let _ = realm {
                print("Reaml 服务器配置成功！")
            } else if let error = error {
                print("Reaml 数据库配置失败: \(error.localizedDescription)")
            }
        }
    }
}

