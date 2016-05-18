//
//  IPhotoCollageMainLayoutView.swift
//  iPhoto
//
//  Created by ngodacdu on 5/17/16.
//  Copyright © 2016 ngodacdu. All rights reserved.
//

import UIKit

class IPhotoCollageMainLayoutView: UIView {
    
    let kPaddingDefault: CGFloat = 10.0

    @IBOutlet weak var collectionView: UICollectionView!
    private var data: ILayout = ILayout()
    private var padding: CGFloat = 10.0 {
        didSet {
            if let layout = collectionView.collectionViewLayout as? AJFCollectionViewWaterfallLayout {
                layout.invalidateLayout()
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
    
    func reloadCollageViewWithData(layouts: ILayout) {
        weak var weakSelf = self
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { 
            weakSelf?.data = layouts
            dispatch_async(dispatch_get_main_queue(), {
                weakSelf?.padding = self.kPaddingDefault
                weakSelf?.collectionView.reloadData()
            })
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        prepareLayout()
    }
    
    private func prepareLayout() {
        if let layout = collectionView.collectionViewLayout as? AJFCollectionViewWaterfallLayout {
            layout.stretchingType = .NoStretching
        }
    }

}

extension IPhotoCollageMainLayoutView: AJFCollectionViewWaterfallLayoutDelegate {
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return data.sections.count
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.sections[section].sizes.count
    }
    
    func collectionView(collectionView: UICollectionView!, numberOfColumnsInSection section: Int) -> Int {
        return data.sections[section].numColumn
    }
    
    func collectionView(collectionView: UICollectionView!, layout collectionViewLayout: UICollectionViewLayout!, columnSpacingForSection section: Int) -> Int {
        return Int(padding)
    }
    
    func collectionView(collectionView: UICollectionView!, layout collectionViewLayout: UICollectionViewLayout!, minimumInteritemSpacingForSectionAtIndex section: Int) -> Int {
        return Int(padding)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
    }
    
}

extension IPhotoCollageMainLayoutView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    private func registerPhotoCollageMainLayoutCell() {
        collectionView.registerNib(
            UINib(nibName: IPhotoCollageMainLayoutCell.Constant.name, bundle: nil),
            forCellWithReuseIdentifier: IPhotoCollageMainLayoutCell.Constant.identifier
        )
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
        let section = data.sections[indexPath.section]
        let iSize = section.sizes[indexPath.row]
        var size = iSize.size
        let paddingUnit: CGFloat = padding / 2.0
        size.width = size.width - iSize.hPadding * paddingUnit
        size.height = size.height - iSize.vPadding * paddingUnit
        return size
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
    }
    
}
