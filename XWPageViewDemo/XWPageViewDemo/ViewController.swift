//
//  ViewController.swift
//  XWPageViewDemo
//
//  Created by 邱学伟 on 2016/12/9.
//  Copyright © 2016年 邱学伟. All rights reserved.
//

import UIKit
private let kCollectionViewCellID = "kCollectionViewCellID"
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
//        XWPageViewTest()
        
        XWPageCollectionviewTest()
    }
    
    fileprivate func XWPageViewTest() {
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
    
    fileprivate func XWPageCollectionviewTest() {
        
        
        
        let titles : [String] = ["民谣","流行","古典","爵士"]
        let stytle : XWTitleStyle = XWTitleStyle()
        stytle.isShowBottomLine = true
        let layout = XWPageCollectionLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
//        layout.cols = 7
//        layout.rows = 3
        let pageCollectionView : XWPageCollectionView = XWPageCollectionView(frame: CGRect(x: 0, y: 250, width: view.bounds.width, height: 300), titles: titles, style: stytle, isTitleInTop: true, layout: layout)
        automaticallyAdjustsScrollViewInsets = false
        pageCollectionView.dataSource = self
        pageCollectionView.register(cellClass: UICollectionViewCell.self, forCellWithReuseIdentifier: kCollectionViewCellID)
        view.addSubview(pageCollectionView)
    }
}

extension ViewController : XWPageCollectionViewDataSource {
    func numberOfSections(in collectionView: XWPageCollectionView) -> Int {
        return 4
    }
    func collectionView(_ collectionView: XWPageCollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 17
        case 1:
            return 7
        case 2:
            return 27
        case 3:
            return 17
        default:
            return 0
        }
    }
    func collectionView(_ pageCollection: XWPageCollectionView, _ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kCollectionViewCellID, for: indexPath)
        cell.backgroundColor = UIColor.getRandomColor()
        return cell
    }
}

