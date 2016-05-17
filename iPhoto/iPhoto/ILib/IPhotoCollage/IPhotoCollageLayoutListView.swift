//
//  IPhotoCollageLayoutListView.swift
//  iPhoto
//
//  Created by ngodacdu on 5/16/16.
//  Copyright © 2016 ngodacdu. All rights reserved.
//

import UIKit

protocol IPhotoCollageLayoutListViewDelegate: class {
    func didSelectItemAtIndexPath(indexPath: NSIndexPath)
}

class IPhotoCollageLayoutListView: UIView {

    @IBOutlet weak var collectionView: UICollectionView!
    weak var delegate: IPhotoCollageLayoutListViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        registerPhotoCollageLayoutCell()
    }
    
    class func loadFromNib() -> IPhotoCollageLayoutListView? {
        let objects = NSBundle.mainBundle().loadNibNamed("IPhotoCollageLayoutListView", owner: self, options: nil)
        return objects.first as? IPhotoCollageLayoutListView
    }

}

extension IPhotoCollageLayoutListView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    private func registerPhotoCollageLayoutCell() {
        collectionView.registerNib(
            UINib(nibName: IPhotoCollageLayoutCell.Constant.name, bundle: nil),
            forCellWithReuseIdentifier: IPhotoCollageLayoutCell.Constant.identifier
        )
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return IPhotoCollageManager.shareInstance.photoCollages.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(IPhotoCollageLayoutCell.Constant.identifier, forIndexPath: indexPath) as! IPhotoCollageLayoutCell
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            
            dispatch_async(dispatch_get_main_queue(), {
                if collectionView.indexPathsForVisibleItems().contains(indexPath) {
                    
                }
            })
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        delegate?.didSelectItemAtIndexPath(indexPath)
    }
    
}
