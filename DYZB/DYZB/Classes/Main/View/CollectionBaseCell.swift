//
//  CollectionBaseCell.swift
//  DYZB
//
//  Created by zhimaguanjia on 17/7/6.
//  Copyright © 2017年 ZH. All rights reserved.
//

import UIKit

class CollectionBaseCell: UICollectionViewCell {
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var onlineBtn: UIButton!
    @IBOutlet weak var nicknameLabel: UILabel!
    
    var anchor : AnchorModel?{
        didSet{
            //校验模型是否有值
            guard let anchor = anchor else{return}
            
            var onlineStr :String = ""
            if anchor.online >= 10000 {
                onlineStr = "\(Int(anchor.online/10000))万在线"
            }else{
                onlineStr = "\(anchor.online)在线"
            }
            
            onlineBtn.setTitle(onlineStr, for: .normal)
            
            nicknameLabel.text = anchor.nickname
                        
            let url = URL(string: anchor.vertical_src)
            iconImageView.kf.setImage(with: url)
            
            
        }
    }
    
}
