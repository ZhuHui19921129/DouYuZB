//
//  NSDate-Extension.swift
//  DYZB
//
//  Created by zhimaguanjia on 17/7/5.
//  Copyright © 2017年 ZH. All rights reserved.
//

import UIKit

extension NSDate{
    class func getCurrentTime()->String{
        let nowDate = NSDate()
        let interval = Int(nowDate.timeIntervalSince1970)
        return "\(interval)"
    }
}
