//
//  CollectionPrettyCell.swift
//  DYZB
//
//  Created by zhimaguanjia on 17/7/3.
//  Copyright © 2017年 ZH. All rights reserved.
//

import UIKit
import Kingfisher

class CollectionPrettyCell: CollectionBaseCell {

   
    @IBOutlet weak var cityBtn: UIButton!
    
    override var anchor : AnchorModel?{
        didSet{
            
            super.anchor = anchor

            cityBtn.setTitle(anchor?.anchor_city, for: .normal)
            
            
        }
    }
    
    
}
