//
//  RecommendCycleView.swift
//  DYZB
//
//  Created by zhimaguanjia on 17/7/6.
//  Copyright © 2017年 ZH. All rights reserved.
//

import UIKit

private let kCycleCellID = "kCycleCellID"

class RecommendCycleView: UIView {
    
    //定义属性
    var cycleTimer : Timer?
    var cycleModels : [CycleModel]?{
        didSet{
            //刷新
            collectionView.reloadData()
            
            //设置page的个数
            pageControl.numberOfPages = cycleModels?.count ?? 0
            
            // 3.默认滚动到中间某一个位置
            let indexPath = IndexPath(item: (cycleModels?.count ?? 0) * 10, section: 0)
            collectionView.scrollToItem(at: indexPath, at: .left, animated: false)
            
            // 4.添加定时器
            removeCycleTimer()
            addCycleTimer()
        }
    }
    

    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //设置该控件不随着父控件的拉伸而拉伸
        autoresizingMask = UIViewAutoresizing(rawValue: 0)
        
        collectionView.register(UINib(nibName: "CollectionCycleCell", bundle: nil), forCellWithReuseIdentifier: kCycleCellID)
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = collectionView.bounds.size
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        collectionView.isPagingEnabled = true
        
    }

}


extension RecommendCycleView{
    class func recommendCycleView()->RecommendCycleView{
        return Bundle.main.loadNibNamed("RecommendCycleView", owner: nil, options: nil)!.first as! RecommendCycleView
    }
}


extension RecommendCycleView:UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (cycleModels?.count ?? 0) * 10000
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kCycleCellID, for: indexPath) as! CollectionCycleCell
        
        cell.cycleModel = cycleModels![(indexPath as NSIndexPath).item % cycleModels!.count]
                
        return cell
    }
}

extension RecommendCycleView:UICollectionViewDelegate{
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // 1.获取滚动的偏移量
        let offsetX = scrollView.contentOffset.x + scrollView.bounds.width * 0.5
        
        // 2.计算pageControl的currentIndex
        pageControl.currentPage = Int(offsetX / scrollView.bounds.width) % (cycleModels?.count ?? 1)

        
        
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        removeCycleTimer()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        addCycleTimer()
    }


}


// MARK:- 对定时器的操作方法
extension RecommendCycleView {
    fileprivate func addCycleTimer() {
        cycleTimer = Timer(timeInterval: 3.0, target: self, selector: #selector(self.scrollToNext), userInfo: nil, repeats: true)
        RunLoop.main.add(cycleTimer!, forMode: RunLoopMode.commonModes)
    }
    
    fileprivate func removeCycleTimer() {
        cycleTimer?.invalidate() // 从运行循环中移除
        cycleTimer = nil
    }
    
    @objc fileprivate func scrollToNext() {
        // 1.获取滚动的偏移量
        let currentOffsetX = collectionView.contentOffset.x
        let offsetX = currentOffsetX + collectionView.bounds.width
        
        // 2.滚动该位置
        collectionView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
    }
}