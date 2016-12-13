//
//  XWPageView.swift
//  XWPageViewDemo
//
//  Created by 邱学伟 on 2016/12/9.
//  Copyright © 2016年 邱学伟. All rights reserved.
//

import UIKit

class XWPageView: UIView {
    
    //MARK: - 自定义属性
    fileprivate var titles : [String]
    fileprivate var childVcS : [UIViewController]
    fileprivate var parentVc : UIViewController
    fileprivate var titleStyle : XWTitleStyle
    fileprivate var titleView : XWTitleView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    init(frame : CGRect, titles : [String], childVcS : [UIViewController], parentVc : UIViewController, titleStyle : XWTitleStyle) {
        self.titles = titles
        self.childVcS = childVcS
        self.parentVc = parentVc
        self.titleStyle = titleStyle
        super.init(frame: frame)
        setUpUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension XWPageView {
    fileprivate func setUpUI() {
        setUpTitleView()
        setUpContentView()
    }
    
    private func setUpTitleView() {
        titleView = XWTitleView(frame: CGRect(x: 0, y: 0, width: bounds.width, height: titleStyle.height), titles: self.titles, style : self.titleStyle)
        
        addSubview(titleView)
    }
    
    private func setUpContentView() {
        let contentView = XWContentView(frame: CGRect(x: 0, y: titleView.frame.maxY, width: bounds.width, height: (bounds.height - titleView.frame.maxY)), childVcS: self.childVcS,parentVc : parentVc)
        addSubview(contentView)
    }
}
