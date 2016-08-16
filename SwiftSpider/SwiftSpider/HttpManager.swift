//
//  HttpManager.swift
//  SwiftSpider
//
//  Created by wangxiaobo on 16/8/16.
//  Copyright © 2016年 com.lovewith.lovewith. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

public let DISCOVER_URL: String = "http://www.lovewith.me/app/v030/discover/"

public class HttpManager: NSObject{
    public class func shareInstance() -> HttpManager{
        return HttpManager()
    }

    public class func getDiscoverList(page:UInt, complection: (Array<Discover>, String) -> Void){
        
        Alamofire.request(.GET, DISCOVER_URL, parameters: ["page":page]).responseData { response in
            
            let json = JSON(data: response.data!)
            var dataArray: Array<Discover> = []
            for aJson in json["data"]["discover"].arrayValue {
                let discover = Discover.modeWithJSON(aJson)
                dataArray.append(discover)
            }
            complection(dataArray, response.result.isFailure ? response.response.debugDescription : "" )
        }
    }

    public class func getInspireList(complection: (Array<NSObject>?, String?) -> Void){
        Alamofire.request(.GET, "", parameters: nil).response { (request, response, data, error) in
            complection(nil,error!.localizedDescription)
        }
    }

}