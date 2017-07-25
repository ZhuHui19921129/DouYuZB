//
//  BaseViewModel.swift
//  DYZB
//
//  Created by zhimaguanjia on 17/7/12.
//  Copyright © 2017年 ZH. All rights reserved.
//

import UIKit

class BaseViewModel{
    lazy var anchorGroups:[AnchorGroup] = [AnchorGroup]()
}

extension BaseViewModel{
    func loadAnchorData(isGroupData:Bool,URLString:String,parameters:[String:Any]? = nil,finishedCallback:@escaping ()->()){

        NetworkTools.requestData(.GET, URLString : URLString,parameters : parameters as! [String : NSString]?){(result) in
            
            guard let resultDict = result as? [String : NSObject] else {return}
            guard let dataArray = resultDict["data"] as? [[String : NSObject]] else {return}
            
            if isGroupData{
                for dict in dataArray{
                    self.anchorGroups.append(AnchorGroup(dict:dict))
                }
            }else{
                let group = AnchorGroup()
                for dict in dataArray{
                    group.anchors.append(AnchorModel(dict: dict))
                }
                self.anchorGroups.append(group)
            }
            
            
            finishedCallback()
        }

    }
}
