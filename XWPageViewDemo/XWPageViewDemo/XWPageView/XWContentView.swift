//
//  XWContentView.swift
//  XWPageViewDemo
//
//  Created by 邱学伟 on 2016/12/9.
//  Copyright © 2016年 邱学伟. All rights reserved.
//

import UIKit

protocol XWContentViewDelegate : class {
    func contentView(_ contentView : XWContentView, targetIndex : Int)
    func contentView(_ contentVuew : XWContentView, targetIndex : Int, progress : CGFloat)
}

class XWContentView: UIView {
    
    weak var delegate : XWContentViewDelegate?
    fileprivate let childVcS : [UIViewController]
    fileprivate let parentVc : UIViewController
    fileprivate let CellID = "kCollectionCellID"
    fileprivate var startOffsetX : CGFloat = 0
    
    fileprivate lazy var collection : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: self.bounds.width, height: self.bounds.height)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        let collection : UICollectionView = UICollectionView(frame: self.bounds, collectionViewLayout: layout)
        collection.dataSource = self
        collection.delegate = self
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

extension XWContentView : UICollectionViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        contentEndScroll()
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if decelerate == false {
            contentEndScroll()
        }
    }
    private func contentEndScroll() {
        guard let delegate = delegate else {
            return
        }
        delegate.contentView(self, targetIndex: Int(collection.contentOffset.x / collection.bounds.width))
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        startOffsetX = scrollView.contentOffset.x
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentOffsetX : CGFloat = scrollView.contentOffset.x
        guard currentOffsetX != startOffsetX else {
            return
        }
        guard let delegate = delegate else {
            return
        }
        var targetIndex : Int = 0
        var progress : CGFloat = 0.0
        let collectionWidth = collection.bounds.width
        if startOffsetX < currentOffsetX {
            targetIndex = Int(startOffsetX / collectionWidth) + 1
            if targetIndex > childVcS.count {
                targetIndex = childVcS.count
            }
            progress = (currentOffsetX - startOffsetX) / collectionWidth
        }else{
            targetIndex = Int(startOffsetX / collectionWidth) - 1
            if targetIndex < 0 {
                targetIndex = 0
            }
            progress = (startOffsetX - currentOffsetX) / collectionWidth
        }
        delegate.contentView(self, targetIndex: targetIndex, progress: progress)
    }
}

extension XWContentView : XWTitleViewDelegate {
    func titleView(_ titleView: XWTitleView, targetIndex: Int) {
        let indexPath : IndexPath = IndexPath(item: targetIndex, section: 0)
        collection.scrollToItem(at: indexPath, at: .left, animated: false)
    }
}
