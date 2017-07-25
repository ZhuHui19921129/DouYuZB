//
//  GameViewModel.swift
//  DYZB
//
//  Created by zhimaguanjia on 17/7/11.
//  Copyright © 2017年 ZH. All rights reserved.
//

import UIKit

class GameViewModel: NSObject {
    lazy var games : [GameModel] = [GameModel]()
}

extension GameViewModel{
    func loadAllGameData(finishedCallback:@escaping ()->()){
        NetworkTools.requestData(.GET, URLString: "http://capi.douyucdn.cn/api/v1/getColumnDetail", parameters: ["shortName":"game"]){(result) in
            
            guard let resultDict = result as? [String : NSObject] else {return}
            guard let dataArray = resultDict["data"] as? [[String : NSObject]] else {return}
            //遍历字典  转成模型
//            self.bigDataGroup.tag_name = "热门"
//            self.bigDataGroup.icon_name = "home_header_hot"
            
            for dict in dataArray{
//                let anchor = AnchorModel(dict: dict)
                self.games.append(GameModel(dict:dict))
            }

            finishedCallback()
        }
    }
}
