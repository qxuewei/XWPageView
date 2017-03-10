//
//  TwoVC.swift
//  XWPageViewDemo
//
//  Created by 邱学伟 on 2017/3/10.
//  Copyright © 2017年 邱学伟. All rights reserved.
//  类似今日头条分页布局

import UIKit

class TwoVC: UIViewController {
    
//    var pageView : XWPageView
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setUpUI()
    }
    
}

extension TwoVC {
    
    fileprivate func setUpUI()  {
        let titles : [String] = ["民谣","民谣民谣","摇滚哈","流行","古典","爵是士","流行","古典","爵士"]
        let pageStyle : XWTitleStyle = XWTitleStyle()
        pageStyle.isScrollEnable = true
        pageStyle.isShowBottomLine = true
        var childVCs : [UIViewController] = [UIViewController]()
        for _ in 0..<titles.count {
            let vc : UIViewController = UIViewController()
            vc.view.backgroundColor = UIColor.getRandomColor()
            childVCs.append(vc)
        }
        let pageView = XWPageView(frame: CGRect(x: 0, y: 64, width: self.view.bounds.size.width, height: self.view.bounds.height) , titles: titles, style: pageStyle, childVcs: childVCs, parentVc: self)
        self.view.addSubview(pageView)
    }
}
