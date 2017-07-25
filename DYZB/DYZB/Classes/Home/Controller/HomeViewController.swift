//
//  HomeViewController.swift
//  DYZB
//
//  Created by zhimaguanjia on 17/6/27.
//  Copyright © 2017年 ZH. All rights reserved.
//

import UIKit

private let kTitleViewH : CGFloat = 40

class HomeViewController: UIViewController {

    //懒加载属性
    lazy var pageTitleView:PageTitleView={[weak self] in
        let titleFrame = CGRect(x:0,y:kStatusBarH+kNavigationBarH,width:kScreenW,height:kTitleViewH)
        let titles = ["推荐","游戏","娱乐","趣玩"]
        let titleView = PageTitleView(frame:titleFrame,titles:titles)
        titleView.delegate = self as PageTitleViewDelegate?
        return titleView
    }()
    
    lazy var pageContentView:PageContentView={[weak self] in
        let contentH = kScreenH-kStatusBarH-kNavigationBarH-kTitleViewH-kTabBarH
        let contentFrame = CGRect(x:0,y:kStatusBarH+kNavigationBarH+kTitleViewH,width:kScreenW,height:contentH)
        
        var childVcs = [UIViewController]()
        childVcs.append(RecommendViewController())
        childVcs.append(GameViewController())
        childVcs.append(AmuseViewController())
        childVcs.append(FunnyViewController())
        
        let contentView = PageContentView(frame: contentFrame, childVcs: childVcs, parentVC: self)
        contentView.delegate = self as PageContentViewDelegate?
        return contentView
    }()
    
    /*懒加载例子
     lazy var wkWebView: WKWebView = {
     let tempWebView = WKWebView()
     tempWebView.navigationDelegate = self
     return tempWebView
     }()
     */
    
    //系统回调函数
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setupUI()
        
        
        /*
        let afn = AFHTTPSessionManager()
        afn.get("", parameters: ["":""], progress: nil, success: {(_,JSON)->Void in
            
        }) {(_,error)->Void in
            
        }
        */
    
        
    }
    


}

//MARK:-设置UI界面
extension HomeViewController{
    func setupUI(){
        //0.不需要调整uiscorllview的内边距
        automaticallyAdjustsScrollViewInsets = false;
        
        //1.设置导航栏
        setupNavigationBar()
        
        //2.添加TitleView
        view.addSubview(pageTitleView)
        
        //3.添加ContentView
        view.addSubview(pageContentView)
        pageContentView.backgroundColor = UIColor.green
    }
    fileprivate func setupNavigationBar(){
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(imageName: "logo")
        
        let size = CGSize(width:40,height:40)
        
        //历史
        //类方法
        //let historyItem = UIBarButtonItem.createItem(imageName: "image_my_history", highImageName: "Image_my_history_click", size: size)
        //构造方法（建议使用）
        let historyItem = UIBarButtonItem(imageName: "image_my_history", highImageName: "Image_my_history_click", size: size)
        //搜索
        //let searchItem = UIBarButtonItem.createItem(imageName: "btn_search", highImageName: "btn_search_clicked", size: size)
        let searchItem = UIBarButtonItem(imageName: "btn_search", highImageName: "btn_search_clicked", size: size)
        //扫一扫
        //let qrcodeItem = UIBarButtonItem.createItem(imageName: "Image_scan", highImageName: "Image_scan_click", size: size)
        let qrcodeItem = UIBarButtonItem(imageName: "Image_scan", highImageName: "Image_scan_click", size: size)
        
        self.navigationItem.rightBarButtonItems = [historyItem,searchItem,qrcodeItem]
    }
}

//遵守代理协议
extension HomeViewController:PageTitleViewDelegate{
    func pageTitleView(_ titleView: PageTitleView, selectedIndex index: Int) {
        pageContentView.setCurrentIndex(index)
    }
}

extension HomeViewController:PageContentViewDelegate{
    func pageContentView(_ contentView: PageContentView, progress: CGFloat, sourceIndex: Int, targetIndex: Int) {
        pageTitleView.setTitleWithData(progress, sourceIndex: sourceIndex, targetIndex: targetIndex)
    }
}
