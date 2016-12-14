//
//  XWTitleView.swift
//  XWPageViewDemo
//
//  Created by 邱学伟 on 2016/12/9.
//  Copyright © 2016年 邱学伟. All rights reserved.
//

import UIKit

protocol XWTitleViewDelegate : class {
    func titleView(_ titleView : XWTitleView, targetIndex : Int)
}

class XWTitleView: UIView {
    weak var delegate : XWTitleViewDelegate?
    fileprivate let titles : [String]
    fileprivate var style : XWTitleStyle
    fileprivate var currentIndex : Int = 0
    fileprivate var titleLBs : [UILabel] =  [UILabel]()
    fileprivate lazy var scrollView : UIScrollView = {
        let scrollView : UIScrollView = UIScrollView(frame: self.bounds)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.scrollsToTop = false
        return scrollView
    }()
    init(frame: CGRect, titles : [String], style : XWTitleStyle) {
        self.titles = titles
        self.style = style
        super.init(frame: frame)
        setUpUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension XWTitleView {
    fileprivate func setUpUI() {
        addSubview(scrollView)
        setUpTitleLBS()
        setUpTitleLBFrame()
    }
    fileprivate func setUpTitleLBS() {
        for (i,title) in titles.enumerated() {
            let titleLB = UILabel()
            titleLB.text = title
            titleLB.textAlignment = .center
            titleLB.textColor = i == 0 ? style.selecedColor : style.nomalColor
            titleLB.font = UIFont.systemFont(ofSize: style.fontSize)
            titleLB.tag = i
            let tapGes : UITapGestureRecognizer = UITapGestureRecognizer(target:self , action: #selector(titleLBClick(_:)))
            titleLB.addGestureRecognizer(tapGes)
            titleLB.isUserInteractionEnabled = true
            scrollView.addSubview(titleLB)
            titleLBs.append(titleLB)
        }
    }
    fileprivate func setUpTitleLBFrame() {
        var X : CGFloat = 0
        var W : CGFloat = 0
        
        if style.isScrollEnable {
            for (i,titleLB) in titleLBs.enumerated() {
                W = (titles[i] as NSString).boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: 0), options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName : titleLB.font] , context: nil).width
                if i == 0 {
                    X = style.itemMargin * 0.5
                }else{
                    X = titleLBs[i - 1].frame.maxX + style.itemMargin
                }
                titleLB.frame = CGRect(x: X, y: 0, width: W, height: bounds.height)
            }
            
            scrollView.contentSize = CGSize(width: ((titleLBs.last?.frame.maxX)! + style.itemMargin * 0.5), height: 0)
        }else{
            W = bounds.width / CGFloat(titles.count)
            for (i,titleLB) in titleLBs.enumerated() {
                X = W * CGFloat(i)
                titleLB.frame = CGRect(x: X, y: 0, width: W, height: bounds.height)
            }
        }
        
    }
}

//MARK: - Selector
extension XWTitleView {
    @objc fileprivate func titleLBClick(_ tap : UITapGestureRecognizer) {
        let targetLB : UILabel = tap.view as! UILabel
        let currentLB : UILabel = titleLBs[currentIndex]
        currentLB.textColor = style.nomalColor
        targetLB.textColor = style.selecedColor
        currentIndex = targetLB.tag
        delegate?.titleView(self, targetIndex: currentIndex)
        if style.isScrollEnable {
            var offsetX : CGFloat = targetLB.center.x - scrollView.bounds.width * 0.5
            if offsetX < 0 {
                offsetX = 0.0
            }
            let offsetMaxX : CGFloat = scrollView.contentSize.width - scrollView.bounds.width
            if offsetX > offsetMaxX {
                offsetX = offsetMaxX
            }
            scrollView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
        }
    }
}
