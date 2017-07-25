//
//  AnchorModel.swift
//  DYZB
//
//  Created by zhimaguanjia on 17/7/5.
//  Copyright © 2017年 ZH. All rights reserved.
//

import UIKit

class AnchorModel: NSObject {

    //房间号
    var room_id : Int = 0
    //房间图片对应的URL
    var vertical_src : String = ""
    //判断是手机直播还是电脑直播 0电脑  1手机
    var isVertical : Int = 0
    //房间名称
    var room_name : String = ""
    //主播名
    var nickname : String = ""
    //在线人数
    var online : Int = 0
    //所在城市
    var anchor_city : String = ""
    
    
    init(dict:[String:Any]) {
        super.init()
        
        setValuesForKeys(dict)
        
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
    }
    
}
