//
//  PerfectMain.swift
//  PerfectDemo
//
//  Created by wangxiaobo on 16/8/13.
//  Copyright © 2016年 com.lovewith.lovewith. All rights reserved.
//

import Foundation
import PerfectLib
import MySQL

// This is the function which all Perfect Server modules must expose.
// The system will load the module and call this function.
// In here, register any handlers or perform any one-time tasks.

let mySql     = MySQL()
let mySqlStmt = MySQLStmt(mySql)
let mySqlHost = "192.168.1.124"
let mySqlUser = "wxb"
let mySqlPsw  = "123456"
let mySqlDB   = "xiaobo"
let mySqlPort: UInt32 = 3306

public func PerfectServerModuleInit() {
    // Install the built-in routing handler.
    // Using this system is optional and you could install your own system if desired.
    Routing.Handler.registerGlobally()

    Routing.Routes["GET", "/" ] = { (_:WebResponse) in return IndexHandler() }
    Routing.Routes["GET", "/index.html" ] = { (_:WebResponse) in return IndexHandler() }
    Routing.Routes["GET", "/shop" ] = { (_:WebResponse) in return IndexHandler() }

    // Check the console to see the logical structure of what was installed.
    print("\(Routing.Routes.description)")
}

class IndexHandler: RequestHandler {

    func handleRequest(request: WebRequest, response: WebResponse) {
        self.userMySql(request, response: response)
        response.requestCompletedCallback()
    }

    func userMySql(request: WebRequest, response: WebResponse){
        guard mySql.connect(mySqlHost, user: mySqlUser, password: mySqlPsw, db: mySqlDB, port: mySqlPort, socket: "", flag: 0) else {
            print("[\(#line)]: Failure connecting to data server \(mySqlHost)")
            return
        }

        guard mySql.query("CREATE TABLE IF NOT EXISTS user (id INTEGER PRIMARY KEY," +
            "user_id varchar(20) NOT NULL UNIQUE, name varchar(20),avatar TEXT,psw TEXT) ")else{
                print("[\(#line)]: Failure: \(mySql.errorCode()) \(mySql.errorMessage())")
                return
        }

        let userID = "111"
        let name = "🐻"
        let avatar = "熊"
        let psw = "666666"

        guard mySql.query("REPLACE INTO user (user_id, name, avatar, psw) values (\(userID),\(name),\(avatar),\(psw))") else{
                print("[\(#line)]: Failure: \(mySql.errorCode()) \(mySql.errorMessage())")
                return
        }

        guard mySql.selectDatabase(mySqlDB) && mySql.query("select * from user") else{
            print("[\(#line)]: Failure: \(mySql.errorCode()) \(mySql.errorMessage())")
            return
        }

        let result = mySql.storeResults()
        var dataArray = [String]()
        for rs in (result?.next())!{
            dataArray.append(rs)
        }

        response.appendBodyString("database:\(mySql.listDatabases()),tables,\(mySql.listTables()).\(dataArray.debugDescription)")
        
        defer{
            mySql.close()
        }
    }
}







