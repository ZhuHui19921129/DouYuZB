//
//  GameViewController.swift
//  DYZB
//
//  Created by zhimaguanjia on 17/7/11.
//  Copyright © 2017年 ZH. All rights reserved.
//

import UIKit

private let kEdgeMargin:CGFloat = 10
private let kGameItemW : CGFloat = (kScreenW-2*kEdgeMargin)/3
private let kGameItemH : CGFloat = kGameItemW*6/5
private let kGameCellID = "kGameCellID"
private let kHeaderViewID = "kHeaderViewID"

private let kHeaderViewH : CGFloat = 50
private let kGameViewH : CGFloat = 90
class GameViewController: BaseViewController {
    
    fileprivate lazy var gameVM:GameViewModel = GameViewModel()
    fileprivate lazy var collectionView:UICollectionView = {[unowned self] in
        //创建layout
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: kGameItemW, height: kGameItemH)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.headerReferenceSize = CGSize(width: kScreenW, height: kHeaderViewH)
        layout.sectionInset = UIEdgeInsets(top: 0, left: kEdgeMargin, bottom: 0, right: kEdgeMargin)
        
        //创建UIcollectionView
        let collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.white
        collectionView.autoresizingMask = [.flexibleHeight,.flexibleWidth]
        collectionView.dataSource = self
        //collectionView.delegate = self
        collectionView.register(UINib(nibName: "CollectionGameCell", bundle: nil), forCellWithReuseIdentifier: kGameCellID)
        collectionView.register(UINib(nibName: "CollectionHeaderView", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: kHeaderViewID)
        
        return collectionView
        
        }()

    fileprivate lazy var topHeaderView:CollectionHeaderView={
        let headerView = CollectionHeaderView.collectionHeaderView()
        headerView.frame = CGRect(x: 0, y: -(kHeaderViewH+kGameViewH), width: kScreenW, height: kHeaderViewH)
        headerView.titleLabel.text = "常见"
        headerView.iconImageView.image = UIImage(named: "Img_orange")
        headerView.moreBtn.isHidden = true
        return headerView
		
    }()
    
    fileprivate lazy var gameView:RecommendGameView={
        let gameView = RecommendGameView.recommendGameView()
        gameView.frame = CGRect(x: 0, y: -kGameViewH, width: kScreenW, height: kGameViewH)
        return gameView
        
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        loadData()
    }
}


extension GameViewController{
    override func setupUI(){
        contentView = collectionView
        view.addSubview(collectionView)
        
        collectionView.addSubview(topHeaderView)
        collectionView.addSubview(gameView)
        collectionView.contentInset = UIEdgeInsets(top: kHeaderViewH+kGameViewH, left: 0, bottom: 0, right: 0)
        super.setupUI()
        
    }
}


extension GameViewController{
    func loadData(){
        gameVM.loadAllGameData {
            self.collectionView.reloadData()
            
            self.gameView.groups = Array(self.gameVM.games[0..<10])
            
            self.loadDataFinished()
        }
    }
}

extension GameViewController:UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gameVM.games.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kGameCellID, for: indexPath) as! CollectionGameCell
        
        cell.baseGame = gameVM.games[indexPath.item]
        

        return cell
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: kHeaderViewID, for: indexPath) as! CollectionHeaderView
        headerView.titleLabel.text = "全部"
        headerView.iconImageView.image = UIImage(named: "Img_orange")
        headerView.moreBtn.isHidden = true
        
        return headerView

    }
}
