//
//  RecommendViewModel.swift
//  DYZB
//
//  Created by zhimaguanjia on 17/7/5.
//  Copyright © 2017年 ZH. All rights reserved.
//

import UIKit

class RecommendViewModel :BaseViewModel {

    lazy var cycleModels : [CycleModel] = [CycleModel]()
    lazy var bigDataGroup : AnchorGroup = AnchorGroup()
    lazy var prettyGroup : AnchorGroup = AnchorGroup()
}

extension RecommendViewModel{
    func requestData(finishedCallback:@escaping ()->()){
        let parameters = ["limit":"4","offset":"0","time":NSDate.getCurrentTime() as NSString]
        
        let dGroup = DispatchGroup()
        
        //推荐数据
        dGroup.enter()
        NetworkTools.requestData(.GET, URLString: "http://capi.douyucdn.cn/api/v1/getbigDataRoom", parameters: ["time":NSDate.getCurrentTime() as NSString]) { (result) in
            
            guard let resultDict = result as? [String : NSObject] else {return}
            guard let dataArray = resultDict["data"] as? [[String : NSObject]] else {return}
            //遍历字典  转成模型
            self.bigDataGroup.tag_name = "热门"
            self.bigDataGroup.icon_name = "home_header_hot"
            
            for dict in dataArray{
                let anchor = AnchorModel(dict: dict)
                self.bigDataGroup.anchors.append(anchor)
            }
            dGroup.leave()
        }

        
        //颜值数据
        dGroup.enter()
        NetworkTools.requestData(.GET, URLString: "http://capi.douyucdn.cn/api/v1/getVerticalRoom", parameters: parameters) { (result) in
            
            guard let resultDict = result as? [String : NSObject] else {return}
            guard let dataArray = resultDict["data"] as? [[String : NSObject]] else {return}
            //遍历字典  转成模型
            self.prettyGroup.tag_name = "颜值"
            self.prettyGroup.icon_name = "home_header_phone"
            
            for dict in dataArray{
                let anchor = AnchorModel(dict: dict)
                self.prettyGroup.anchors.append(anchor)
            }
            dGroup.leave()
        }
        
        //请求2-12部分游戏数据
        dGroup.enter()
        loadAnchorData(isGroupData:true,URLString: "http://capi.douyucdn.cn/api/v1/getHotCate", parameters: parameters){
            
            dGroup.leave()
        }
        //所有数据请求以后
        dGroup.notify(queue: DispatchQueue.main){
            self.anchorGroups.insert(self.prettyGroup, at: 0)
            self.anchorGroups.insert(self.bigDataGroup, at: 0)
            
            finishedCallback()
        }

    }
    
    //请求无限轮播的数据
    func requestCycleData(finishCallback:@escaping ()-> ()) {
        NetworkTools.requestData(.GET, URLString: "http://www.douyutv.com/api/v1/slide/6", parameters: ["version":"2.300"]){ (result) in
        
            guard let resultDict = result as? [String : NSObject] else {return}
            guard let dataArray = resultDict["data"] as? [[String : NSObject]] else {return}
            
            for dict in dataArray{
                self.cycleModels.append(CycleModel(dict: dict))
            }
            
            
            finishCallback()
        }
    }
    
    
}
