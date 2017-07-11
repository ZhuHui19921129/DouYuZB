//
//  PageTitleView.swift
//  DYZB
//
//  Created by zhimaguanjia on 17/6/28.
//  Copyright © 2017年 ZH. All rights reserved.
//

import UIKit

//定义协议
protocol PageTitleViewDelegate:class {
    func pageTitleView(_ titleView:PageTitleView,selectedIndex index:Int)
}

//定义常量
private let kNormalColor:(CGFloat,CGFloat,CGFloat) = (85,85,85)
private let kSelectColor:(CGFloat,CGFloat,CGFloat) = (255,128,0)

private var kScrollLineH:CGFloat = 2

class PageTitleView: UIView {

    //定义属性
    var currentIndex:Int = 0
    
    var titles:[String]
    
    weak var delegate:PageTitleViewDelegate?
    
    
    //懒加载属性
    lazy var titleLabels:[UILabel] = [UILabel]()
    
    lazy var scrollView : UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.scrollsToTop = false
        scrollView.bounces = false
        return scrollView
    }()
    
    lazy var scrollLine:UIView = {
       let scrollLine = UIView()
        scrollLine.backgroundColor = UIColor.orange
        return scrollLine
    }()
    
    //自定义构造函数
    init(frame:CGRect,titles:[String]){
        self.titles = titles;
        
        super.init(frame:frame)
        
        //设置UI界面
        setupUI()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}


extension PageTitleView{
    func setupUI() {
        //1.添加UIScrollView
        addSubview(scrollView)
        scrollView.frame = bounds
        
        //2.添加title对应的label
        setupTitleLabels()
        
        //3.设置底线和滚动滑块
        setupBottomLineAndScrollLine()
    }
    
    fileprivate func setupTitleLabels(){
        
        //0.确定一些frame的值
        let labelW:CGFloat = frame.width/CGFloat(titles.count)
        let labelH:CGFloat = frame.height-kScrollLineH
        let labelY:CGFloat = 0
        
        for (index,title) in titles.enumerated() {
            let label = UILabel()
            //设置属性
            label.text = title
            label.tag = index
            label.font = UIFont.systemFont(ofSize: 16.0)
            label.textColor = UIColor(r: kNormalColor.0, g: kNormalColor.1, b: kNormalColor.2)
            label.textAlignment = .center
            
            //frame
            let labelX:CGFloat = labelW*CGFloat(index)
            label.frame = CGRect(x: labelX, y: labelY, width: labelW, height: labelH)
            
            scrollView.addSubview(label)
            titleLabels.append(label)
            
            //给label添加手势
            label.isUserInteractionEnabled = true
            let tapGes = UITapGestureRecognizer(target: self, action: #selector(titleLabelClick(_:)))
            label.addGestureRecognizer(tapGes)
            
        }
    }
   
    
    fileprivate func setupBottomLineAndScrollLine(){
        //添加底线
        let bottomLine = UIView()
        bottomLine.backgroundColor = UIColor.lightGray
        let lineH:CGFloat = 0.5
        bottomLine.frame = CGRect(x: 0, y: frame.height-lineH, width: frame.width, height: lineH)
        addSubview(bottomLine)
        
        guard let firstLabel = titleLabels.first else{return}
        firstLabel.textColor = UIColor(r: kSelectColor.0, g: kSelectColor.1, b: kSelectColor.2)
        
        scrollView.addSubview(scrollLine)
        scrollLine.frame = CGRect(x: firstLabel.frame.origin.x, y: frame.height-kScrollLineH, width: firstLabel.frame.width, height: kScrollLineH)
        
        
        
    }
}


//监听label的点击
extension PageTitleView{
    @objc func titleLabelClick(_ tapGes:UITapGestureRecognizer){
        
        //0.获取当前的label
        guard let currentLabel = tapGes.view as?UILabel else{return}
        //1.如果重复点击直接返回
        if currentLabel.tag == currentIndex {
            return
        }
        //2.获取之前的label
        let oldLabel = titleLabels[currentIndex]
        //3.切换文字的颜色
        currentLabel.textColor = UIColor(r: kSelectColor.0, g: kSelectColor.1, b: kSelectColor.2)
        oldLabel.textColor = UIColor(r: kNormalColor.0, g: kNormalColor.1, b: kNormalColor.2)
        //4.保存最新label的下标值
        currentIndex = currentLabel.tag
        //5.滚动条位置发生改变
        let scrollLineX = CGFloat(currentLabel.tag)*scrollLine.frame.width
        UIView.animate(withDuration: 0.15, animations:{
            self.scrollLine.frame.origin.x = scrollLineX
           
        })
        //6.通知代理
        delegate?.pageTitleView(self, selectedIndex: currentIndex)
    }
}


extension PageTitleView{
    func setTitleWithData(_ progress: CGFloat, sourceIndex: Int, targetIndex: Int){
        let sourceLabel = titleLabels[sourceIndex]
        let targetLabel = titleLabels[targetIndex]
        
        //处理滑块的逻辑
        let moveTotalX = targetLabel.frame.origin.x-sourceLabel.frame.origin.x
        let moveX = moveTotalX * progress
        scrollLine.frame.origin.x = sourceLabel.frame.origin.x+moveX
        
        //颜色的渐变
        let colorDelta = (kSelectColor.0-kNormalColor.0,kSelectColor.1-kNormalColor.1,kSelectColor.2-kNormalColor.2)
        //变化sourceLabel
        sourceLabel.textColor = UIColor(r: kSelectColor.0-colorDelta.0*progress, g: kSelectColor.1-colorDelta.1*progress, b: kSelectColor.2-colorDelta.2*progress)
        //变化targetLabel
         targetLabel.textColor = UIColor(r: kNormalColor.0+colorDelta.0*progress, g: kNormalColor.1+colorDelta.1*progress, b: kNormalColor.2+colorDelta.2*progress)
        
        //记录最新的index
        currentIndex = targetIndex
    }
}
