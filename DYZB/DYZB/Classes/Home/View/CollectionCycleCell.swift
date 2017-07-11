//
//  CollectionCycleCell.swift
//  DYZB
//
//  Created by zhimaguanjia on 17/7/7.
//  Copyright © 2017年 ZH. All rights reserved.
//

import UIKit
import Kingfisher

class CollectionCycleCell: UICollectionViewCell {
    
    
    @IBOutlet weak var iconImageView: UIImageView!

    @IBOutlet weak var titleLabel: UILabel!
    
    
    var cycleModel : CycleModel?{
        didSet{
            titleLabel.text = cycleModel?.title
            
            let url = URL(string: cycleModel?.pic_url ?? "")!
            iconImageView.kf.setImage(with: url)
            
        }
    }
    

}
