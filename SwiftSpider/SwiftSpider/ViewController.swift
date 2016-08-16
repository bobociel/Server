//
//  ViewController.swift
//  SwiftSpider
//
//  Created by wangxiaobo on 16/8/16.
//  Copyright © 2016年 com.lovewith.lovewith. All rights reserved.
//

import Cocoa
import SwiftyJSON
import Alamofire

class ViewController : NSViewController{
    @IBOutlet weak var emptyLabel: NSTextField!

    override func viewDidLoad() {
        HttpManager.getDiscoverList(0) { dataArray, errMsg in
            print(dataArray)
        }

        
    }

    func testJSON(){
        let jsonData = NSData(contentsOfFile: NSBundle.mainBundle().pathForResource("JSONDATA", ofType: "json")!)
        let result = JSON(data: jsonData!)

        let model = InfoModel()
        model.name = result["name"].stringValue
        model.url = result["url"].stringValue
        model.page = result["page"].intValue
        model.isNonProfit = result["isNonProfit"].boolValue
        model.empty = result["empty"].stringValue
        model.emptyCharater = result["emptyCharater"].stringValue
        print(model)
    }
}

/* JSON TEST Model */
class Address{
    var country: String = ""
    var city: String = ""
    var street: String = ""
}

class Link{
    var name: String = ""
    var url: String = ""
}

class InfoModel{
    var name: String = ""
    var url: String = ""
    var page: Int = 0
    var isNonProfit: Bool = false
    var address: Address?
    var link: [Link] = []
    var empty: String?
    var emptyCharater: String?
    var emptyArray: [AnyObject]?
    var emptyDictionary: [String: AnyObject]?
}



