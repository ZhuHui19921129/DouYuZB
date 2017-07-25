//
//  BaseViewController.swift
//  DYZB
//
//  Created by zhimaguanjia on 17/7/14.
//  Copyright © 2017年 ZH. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    var contentView : UIView?
    
    lazy var animImageView : UIImageView = {
        let imageView = UIImageView(image:UIImage(named: "img_loading_1"))
        imageView.center = self.view.center
        imageView.animationImages = [UIImage(named:"img_loading_1")!,UIImage(named:"img_loading_2")!]
        imageView.animationDuration = 0.5
        imageView.animationRepeatCount = LONG_MAX
        imageView.autoresizingMask = [.flexibleTopMargin,.flexibleBottomMargin]
        return imageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    
    }

}

extension BaseViewController{
    func setupUI(){
        contentView?.isHidden = true
        
        view.addSubview(animImageView)
        
        animImageView.startAnimating()
        
        view.backgroundColor = UIColor(r: 250, g: 250, b: 250)
    }
    
    func loadDataFinished(){
        animImageView.stopAnimating()
        animImageView.isHidden = true
        contentView?.isHidden = false
    }
}
