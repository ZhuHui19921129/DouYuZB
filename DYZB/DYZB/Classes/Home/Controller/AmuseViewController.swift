//
//  AmuseViewController.swift
//  DYZB
//
//  Created by zhimaguanjia on 17/7/12.
//  Copyright © 2017年 ZH. All rights reserved.
//

import UIKit

private let kMenuViewH:CGFloat = 200

class AmuseViewController: BaseAnchorViewController {
    
    lazy var amuseVM:AmuseViewModel = AmuseViewModel()
    
    lazy var menuView : AmuseMenuView = {
       let menuView = AmuseMenuView.amuseMenuView()
        menuView.frame = CGRect(x: 0, y: -kMenuViewH, width: kScreenW, height: kMenuViewH)
        return menuView
    }()

}

extension AmuseViewController{
    override func setupUI() {
        super.setupUI()
        
        collectionView.addSubview(menuView)
        
        collectionView.contentInset = UIEdgeInsets(top: kMenuViewH, left: 0, bottom: 0, right: 0)
    }
}

extension AmuseViewController{
    override func loadData(){
        
        baseVM = amuseVM
        
        amuseVM.loadAmuseData {
            self.collectionView.reloadData()
            
            var tempGroups = self.amuseVM.anchorGroups
            tempGroups.removeFirst()
            self.menuView.groups = tempGroups
            
            self.loadDataFinished()
        }
    }
}




