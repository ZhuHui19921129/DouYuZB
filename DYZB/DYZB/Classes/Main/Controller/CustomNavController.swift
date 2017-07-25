//
//  CustomNavController.swift
//  DYZB
//
//  Created by zhimaguanjia on 17/7/17.
//  Copyright © 2017年 ZH. All rights reserved.
//

import UIKit

class CustomNavController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let systemGes = interactivePopGestureRecognizer else {
            return
        }
        guard let gesView = systemGes.view else {
            return
        }
        let targets = systemGes.value(forKey: "_targets") as?[NSObject]
        guard let targetObjc = targets?.first else {
            return
        }
        guard let target = targetObjc.value(forKey: "target")  else {
            return
        }
        let action = Selector(("handleNavigationTransition:"))
        
        let panGes = UIPanGestureRecognizer()
        gesView.addGestureRecognizer(panGes)
        panGes.addTarget(target, action: action)
        
        

    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        
        viewController.hidesBottomBarWhenPushed = true
        
        super.pushViewController(viewController, animated: animated)
    }
    
}
