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
        scrollView.showsVerticalScrollIndicator = false
        scrollView.scrollsToTop = false
        return scrollView
    }()
    fileprivate lazy var scrollLine : UIView = {
        let line = UIView()
        line.backgroundColor = self.style.scrollLineColor
        line.frame.origin.y = self.bounds.height - self.style.scrollLineHeight
        line.frame.size.height = self.style.scrollLineHeight
        return line
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
        if style.isShowScrollLine {
            scrollView.addSubview(scrollLine)
        }
    }
    fileprivate func setUpTitleLBS() {
        for (i,title) in titles.enumerated() {
            let titleLB = UILabel()
            titleLB.text = title
            titleLB.textAlignment = .center
            titleLB.textColor = ( i == 0 ? style.selecedColor : style.nomalColor )
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
                    if style.isShowScrollLine {
                        scrollLine.frame.origin.x = X
                        scrollLine.frame.size.width = W
                    }
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
            if style.isShowScrollLine {
                scrollLine.frame.origin.x = 0
                scrollLine.frame.size.width = W
            }
        }
    }
}

//MARK: - Selector
extension XWTitleView {
    @objc fileprivate func titleLBClick(_ tap : UITapGestureRecognizer) {
        let targetLB : UILabel = tap.view as! UILabel
        adjustTitleLB(targetLB.tag)
        if style.isShowScrollLine {
            adjustScrollLine(targetLB)
        }
        delegate?.titleView(self, targetIndex: currentIndex)
    }
    private func adjustScrollLine(_ targetLB : UILabel) {
        UIView.animate(withDuration: 0.25, animations: {
            self.scrollLine.frame.origin.x = targetLB.frame.origin.x
            self.scrollLine.frame.size.width = targetLB.frame.size.width
        })
    }
    fileprivate func adjustTitleLB(_ targetIndex : Int) {
        guard targetIndex != currentIndex else {
            return
        }
        let targetLB : UILabel = titleLBs[targetIndex]
        let currentLB : UILabel = titleLBs[currentIndex]
        currentLB.textColor = style.nomalColor
        targetLB.textColor = style.selecedColor
        currentIndex = targetIndex
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

extension XWTitleView : XWContentViewDelegate {
    func contentView(_ contentView: XWContentView, targetIndex: Int) {
        adjustTitleLB(targetIndex)
    }
    func contentView(_ contentVuew: XWContentView, targetIndex: Int, progress: CGFloat) {
        //print("targetIndex:\(targetIndex) +++ progress:\(progress)")
        if style.isShowScrollLine {
            changeScrollLinePosition(targetIndex: targetIndex, progress: progress)
        }
        if style.isColorShade {
            changeTextLBColor(targetIndex: targetIndex, progress: progress)
        }
    }
    
    private func changeTextLBColor(targetIndex: Int, progress: CGFloat) {
        guard targetIndex != currentIndex else {
            return
        }
        let currentLB : UILabel = titleLBs[currentIndex]
        let targetLB : UILabel = titleLBs[targetIndex]
        let colorDelta = UIColor.getRGBDelta(oldRGBColor: style.selecedColor, newRGBColor: style.nomalColor)
        let seletedRGB = style.selecedColor.getRGBComps()
        let nomalRGB = style.nomalColor.getRGBComps()
        currentLB.textColor = UIColor(R: seletedRGB.0 - colorDelta.0 * progress, G: seletedRGB.1 - colorDelta.1 * progress, B: seletedRGB.2 - colorDelta.2 * progress)
        targetLB.textColor = UIColor(R: nomalRGB.0 + colorDelta.0 * progress, G: nomalRGB.1 + colorDelta.1 * progress, B: nomalRGB.2 + colorDelta.2 * progress)
    }
    private func changeScrollLinePosition(targetIndex: Int, progress: CGFloat) {
        guard targetIndex != currentIndex else {
            return
        }
        let currentLB : UILabel = titleLBs[currentIndex]
        let targetLB : UILabel = titleLBs[targetIndex]
        let WDelta : CGFloat = targetLB.bounds.width - currentLB.bounds.width
        let XDelta : CGFloat = targetLB.frame.origin.x - currentLB.frame.origin.x
        scrollLine.frame.size.width = currentLB.bounds.width + WDelta * progress
        scrollLine.frame.origin.x = currentLB.frame.origin.x + XDelta * progress
    }
}
