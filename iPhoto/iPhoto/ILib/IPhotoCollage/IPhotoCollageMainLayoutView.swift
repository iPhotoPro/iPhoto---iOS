//
//  IPhotoCollageMainLayoutView.swift
//  iPhoto
//
//  Created by ngodacdu on 5/17/16.
//  Copyright © 2016 ngodacdu. All rights reserved.
//

import UIKit
import FBLikeLayout

class IPhotoCollageMainLayoutView: UIView {

    @IBOutlet weak var collectionView: UICollectionView!
    private var data: [ILayout] = [ILayout]()
    private var padding: CGFloat = 10.0 {
        didSet {
            if let fbLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                fbLayout.sectionInset = UIEdgeInsets(
                    top: padding,
                    left: padding,
                    bottom: padding,
                    right: padding
                )
                fbLayout.invalidateLayout()
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        registerPhotoCollageMainLayoutCell()
    }
    
    class func loadFromNib() -> IPhotoCollageMainLayoutView? {
        let objects = NSBundle.mainBundle().loadNibNamed("IPhotoCollageMainLayoutView", owner: self, options: nil)
        return objects.first as? IPhotoCollageMainLayoutView
    }
    
    func updatePadding(newPadding: CGFloat) {
        padding = newPadding
    }
    
    func reloadCollageViewWithData(layouts: [ILayout]) {
        weak var weakSelf = self
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { 
            weakSelf?.data = layouts
            dispatch_async(dispatch_get_main_queue(), { 
                weakSelf?.collectionView.reloadData()
            })
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        prepareLayout()
    }
    
    private func prepareLayout() {
        if collectionView.collectionViewLayout.isKindOfClass(FBLikeLayout) {
            let fbLayout = FBLikeLayout()
            fbLayout.singleCellWidth = frame.width
            fbLayout.maxCellSpace = 3
            fbLayout.forceCellWidthForMinimumInteritemSpacing = false
            fbLayout.fullImagePercentageOfOccurrency = 50
            collectionView.collectionViewLayout = fbLayout
            collectionView.reloadData()
        }
    }

}

extension IPhotoCollageMainLayoutView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private func registerPhotoCollageMainLayoutCell() {
        collectionView.registerNib(
            UINib(nibName: IPhotoCollageMainLayoutCell.Constant.name, bundle: nil),
            forCellWithReuseIdentifier: IPhotoCollageMainLayoutCell.Constant.identifier
        )
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(IPhotoCollageMainLayoutCell.Constant.identifier, forIndexPath: indexPath) as! IPhotoCollageMainLayoutCell
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            
            dispatch_async(dispatch_get_main_queue(), {
                if collectionView.indexPathsForVisibleItems().contains(indexPath) {
                    
                }
            })
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let layout = data[indexPath.row]
        var size = layout.size
        let paddingUnit = padding / 2
        size.width = size.width - layout.hPadding * paddingUnit
        size.height = size.height - layout.vPadding * paddingUnit
        return size
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return padding
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return padding
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
    }
    
}
