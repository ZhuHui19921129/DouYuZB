//
//  CollectionNormalCell.swift
//  DYZB
//
//  Created by zhimaguanjia on 17/6/30.
//  Copyright © 2017年 ZH. All rights reserved.
//

import UIKit

class CollectionNormalCell: CollectionBaseCell {
    
    
    @IBOutlet weak var roomNameLabel: UILabel!
    
    override var anchor : AnchorModel?{
        didSet{
            
            super.anchor = anchor
            
            roomNameLabel.text = anchor?.room_name
            
        }
    }
    

}
