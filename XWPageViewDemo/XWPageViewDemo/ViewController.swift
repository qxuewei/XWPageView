//
//  ViewController.swift
//  XWPageViewDemo
//
//  Created by 邱学伟 on 2016/12/9.
//  Copyright © 2016年 邱学伟. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false
//        let titles : [String] = ["民谣","摇滚","流行","古典","爵士"]
        let titles : [String] = ["民谣","民谣民谣","摇滚哈","流行","古典","爵是士","流行","古典","爵士"]
        var childVcS : [UIViewController] = [UIViewController]()
        let titleStyle : XWTitleStyle = XWTitleStyle()
        titleStyle.isScrollEnable = true
        titleStyle.isShowBottomLine = true
        
        for _ in 0..<titles.count {
            let VC : UIViewController = UIViewController()
            VC.view.backgroundColor = UIColor.getRandomColor()
            childVcS.append(VC)
        }
        
        
        let pageView : XWPageView = XWPageView(frame: CGRect(x: 0, y: 64, width: view.bounds.width, height: view.bounds.height - 64), titles: titles, style: titleStyle, childVcs: childVcS, parentVc: self)
        view.addSubview(pageView)
    }
}

