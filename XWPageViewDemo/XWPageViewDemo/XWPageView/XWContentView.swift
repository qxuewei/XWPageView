//
//  XWContentView.swift
//  XWPageViewDemo
//
//  Created by 邱学伟 on 2016/12/9.
//  Copyright © 2016年 邱学伟. All rights reserved.
//

import UIKit

class XWContentView: UIView {
    fileprivate let childVcS : [UIViewController]
    fileprivate let parentVc : UIViewController
    fileprivate let CellID = "kCollectionCellID"
    fileprivate lazy var collection : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: self.bounds.width, height: self.bounds.height)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        
        let collection : UICollectionView = UICollectionView(frame: self.bounds, collectionViewLayout: layout)
        collection.dataSource = self
        collection.isPagingEnabled = true
        collection.bounces = false
        collection.scrollsToTop = false
        collection.showsVerticalScrollIndicator = false
        collection.showsHorizontalScrollIndicator = false
        
        return collection
    }()
    init(frame: CGRect, childVcS : [UIViewController],parentVc : UIViewController) {
        self.childVcS = childVcS
        self.parentVc = parentVc
        super.init(frame: frame)
        setUpUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension XWContentView {
    fileprivate func setUpUI() {
        for VC in childVcS {
            parentVc.addChildViewController(VC)
        }
        collection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: CellID)
        addSubview(collection)
    }
}

extension XWContentView : UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return childVcS.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellID, for: indexPath)
        let VC = childVcS[indexPath.row]
        VC.view.frame = cell.contentView.bounds
        for view in cell.contentView.subviews {
            view.removeFromSuperview()
        }
        cell.contentView.addSubview(VC.view)
        return cell
    }
}
