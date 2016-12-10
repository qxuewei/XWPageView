//
//  XWTitleView.swift
//  XWPageViewDemo
//
//  Created by 邱学伟 on 2016/12/9.
//  Copyright © 2016年 邱学伟. All rights reserved.
//

import UIKit

class XWTitleView: UIView {
    fileprivate let titles : [String]
    init(frame: CGRect, titles : [String]) {
        self.titles = titles
        super.init(frame: frame)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
