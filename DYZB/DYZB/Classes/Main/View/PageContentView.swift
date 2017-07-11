//
//  PageContentView.swift
//  DYZB
//
//  Created by zhimaguanjia on 17/6/28.
//  Copyright © 2017年 ZH. All rights reserved.
//

import UIKit

protocol PageContentViewDelegate:class {
    func pageContentView(_ contentView:PageContentView,progress:CGFloat,sourceIndex:Int,targetIndex:Int)
}

private let ContentCellID = "ContentCellID"

class PageContentView: UIView {
    
    var childVcs : [UIViewController]
    
    weak var parentVC : UIViewController?
    
    var startOffsetX:CGFloat = 0
    
    var isForbidScrollDelegate:Bool = false
    
    weak var delegate : PageContentViewDelegate?
    
    lazy var collectionView:UICollectionView = {[weak self] in
        //创建layout
       let layout = UICollectionViewFlowLayout()
        layout.itemSize = (self?.bounds.size)!
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        
        //创建UIcollectionView
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.bounces = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: ContentCellID)
        
        return collectionView
        
    }()

    init(frame: CGRect,childVcs:[UIViewController],parentVC:UIViewController?) {
        self.childVcs = childVcs
        self.parentVC = parentVC
        
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}


extension PageContentView{
    func setupUI() {
        //1.将所有的子控制器添加父控制器中
        for childVC in childVcs {
            parentVC?.addChildViewController(childVC)
        }
        //2.添加UIcollectionView，用于在cell中存放控制器的View
        addSubview(collectionView)
        collectionView.frame = bounds
    }
}


//遵守UIcollectionViewDatasource
extension PageContentView:UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return childVcs.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //创建cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContentCellID, for: indexPath)
        
        for view in cell.contentView.subviews {
            view.removeFromSuperview()
        }
        
        let childVC = childVcs[indexPath.item]
        childVC.view.frame = cell.contentView.bounds
        cell.contentView.addSubview(childVC.view)
        
        return cell
    }
}

//遵守UIcollectionViewDelegate
extension PageContentView:UICollectionViewDelegate{
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        isForbidScrollDelegate = false
        
        startOffsetX = scrollView.contentOffset.x
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        //是否是点击事件
        if isForbidScrollDelegate{return}
        
        //1.获取需要的数据
        var progress : CGFloat = 0
        var sourceIndex : Int = 0
        var targetIndex : Int = 0
        
        //2.判断左滑还是右滑
        let currentOffsetX = scrollView.contentOffset.x
        let scrollViewW = scrollView.bounds.width
        if currentOffsetX>startOffsetX {//左滑
            progress = currentOffsetX/scrollViewW-floor(currentOffsetX/scrollViewW)
            sourceIndex = Int(currentOffsetX/scrollViewW)
            targetIndex = sourceIndex+1
            if targetIndex>=childVcs.count {
                targetIndex = childVcs.count-1
            }
            if currentOffsetX-startOffsetX == scrollViewW {
                progress = 1
                targetIndex = sourceIndex
            }
        }else{
            progress = 1 - (currentOffsetX/scrollViewW-floor(currentOffsetX/scrollViewW))
            targetIndex = Int(currentOffsetX/scrollViewW)
            sourceIndex = targetIndex+1
            if sourceIndex>=childVcs.count{
                sourceIndex = childVcs.count-1
            }
        }
        //将这些数据传递给titleView
        print("progress:\(progress) sourceIndex:\(sourceIndex) targetIndex:\(targetIndex)")
        delegate?.pageContentView(self, progress: progress, sourceIndex: sourceIndex, targetIndex: targetIndex)
    }
}

//对外暴露的方法
extension PageContentView{
    func setCurrentIndex(_ currentIndex:Int){
        //记录需要进到执行代理方法
        isForbidScrollDelegate = true
        
        //滚动正确的位置
        let offsetX = CGFloat(currentIndex)*collectionView.frame.width
        collectionView.setContentOffset(CGPoint(x:offsetX,y:0), animated: false)
    }
}

