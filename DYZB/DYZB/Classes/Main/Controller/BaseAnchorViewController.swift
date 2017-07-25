//
//  BaseAnchorViewController.swift
//  DYZB
//
//  Created by zhimaguanjia on 17/7/12.
//  Copyright © 2017年 ZH. All rights reserved.
//

import UIKit

private let kItemMargin:CGFloat = 10
private let kNormalCellID = "kNormalCellID"
private let kHeaderViewID = "kHeaderViewID"
private let kHeaderH : CGFloat = 50

let kItemW = (kScreenW-3*kItemMargin)/2
let kNormalItemH = kItemW*3/4
let kPrettyItemH = kItemW*4/3
let kPrettyCellID = "kPrettyCellID"

class BaseAnchorViewController: BaseViewController {
    
    var baseVM:BaseViewModel!
    
    lazy var collectionView:UICollectionView = {[unowned self] in
        //创建layout
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: kItemW, height: kNormalItemH)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = kItemMargin
        layout.headerReferenceSize = CGSize(width: kScreenW, height: kHeaderH)
        layout.sectionInset = UIEdgeInsets(top: 0, left: kItemMargin, bottom: 0, right: kItemMargin)
        
        //创建UIcollectionView
        let collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.white
        collectionView.autoresizingMask = [.flexibleHeight,.flexibleWidth]
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "CollectionNormalCell", bundle: nil), forCellWithReuseIdentifier: kNormalCellID)
        collectionView.register(UINib(nibName: "CollectionPrettyCell", bundle: nil), forCellWithReuseIdentifier: kPrettyCellID)
        collectionView.register(UINib(nibName: "CollectionHeaderView", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: kHeaderViewID)
        
        
        return collectionView
        
        }()


    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadData()
    }


}


extension BaseAnchorViewController{
    override func setupUI(){

        contentView = collectionView
        
        view.addSubview(collectionView)

        super.setupUI()
    }
}

extension BaseAnchorViewController{
     func loadData(){
    }
}

extension BaseAnchorViewController:UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return baseVM.anchorGroups.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return baseVM.anchorGroups[section].anchors.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kNormalCellID, for: indexPath) as! CollectionNormalCell
        
        cell.anchor = baseVM.anchorGroups[indexPath.section].anchors[indexPath.item]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: kHeaderViewID, for: indexPath) as! CollectionHeaderView
        
        headerView.group = baseVM.anchorGroups[indexPath.section]
        
        return headerView
        
    }
    
}


extension BaseAnchorViewController:UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //取出对应的主播信息
        let anchor = baseVM.anchorGroups[indexPath.section].anchors[indexPath.item]
        //判断是秀场还是普通直播
        print(anchor.isVertical)
        if anchor.isVertical==0{
            pushNormalRoomVC()
        }else{
            presentShowRoomVC()
        }
    }
    func presentShowRoomVC(){
        let showRoomVC = RoomShowViewController()
        present(showRoomVC, animated: true, completion: nil)
        
    }
    func pushNormalRoomVC(){
        let normalRoomVC = RoomNormalViewController()
        navigationController?.pushViewController(normalRoomVC, animated: true)
        
    }
}

