//
//  RecommendViewController.swift
//  DYZB
//
//  Created by zhimaguanjia on 17/6/30.
//  Copyright © 2017年 ZH. All rights reserved.
//

import UIKit

private let kCycleViewH = kScreenW*3/8
private let kGameViewH : CGFloat = 90

class RecommendViewController: BaseAnchorViewController {
    
    lazy var recommendVM:RecommendViewModel = RecommendViewModel()
    
    lazy var cycleView:RecommendCycleView = {
        let cycleView = RecommendCycleView.recommendCycleView()
        cycleView.frame = CGRect(x: 0, y: -(kCycleViewH + kGameViewH), width: kScreenW, height: kCycleViewH)
        return cycleView
    }()
    
    lazy var gameView : RecommendGameView = {
        let gameView = RecommendGameView.recommendGameView()
        gameView.frame = CGRect(x: 0, y: -kGameViewH, width: kScreenW, height: kGameViewH)
        return gameView
    }()

}

extension RecommendViewController{
    override func setupUI(){
        super.setupUI()
        
        collectionView.addSubview(cycleView)
        
        collectionView.addSubview(gameView)
        
        collectionView.contentInset = UIEdgeInsets(top: kCycleViewH+kGameViewH, left: 0, bottom: 0, right: 0)
    }
}


extension RecommendViewController{
    override func loadData(){
        
        baseVM = recommendVM
        
        //请求推荐数据
        recommendVM.requestData {
            self.collectionView.reloadData()
            
            //将数据传递给GameView
            var groups = self.recommendVM.anchorGroups
            groups.removeFirst()
            groups.removeFirst()
            
            let moreGroup = AnchorGroup()
            moreGroup.tag_name = "更多"
            groups.append(moreGroup)
            self.gameView.groups = groups
            
            self.loadDataFinished()
        }
        
        //请求banner数据
        recommendVM.requestCycleData {
            self.cycleView.cycleModels = self.recommendVM.cycleModels
        }
    }
}

extension RecommendViewController:UICollectionViewDelegateFlowLayout{
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 1 {
            let prettyCell = collectionView.dequeueReusableCell(withReuseIdentifier: kPrettyCellID, for: indexPath) as! CollectionPrettyCell
            prettyCell.anchor = recommendVM.anchorGroups[indexPath.section].anchors[indexPath.item]
            
            return prettyCell
        }else{
            return super.collectionView(collectionView, cellForItemAt: indexPath)
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 1 {
            return CGSize(width:kItemW, height: kPrettyItemH)
        }
        return CGSize(width:kItemW, height: kNormalItemH)
    }
}
