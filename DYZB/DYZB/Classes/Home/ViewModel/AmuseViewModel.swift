//
//  AmuseViewModel.swift
//  DYZB
//
//  Created by zhimaguanjia on 17/7/12.
//  Copyright © 2017年 ZH. All rights reserved.
//

import UIKit

class AmuseViewModel:BaseViewModel{

}

extension AmuseViewModel{
    func loadAmuseData(finishedCallback:@escaping ()->()){
        loadAnchorData(isGroupData:true,URLString: "http://capi.douyucdn.cn/api/v1/getHotRoom/2", finishedCallback: finishedCallback)
    }
}
