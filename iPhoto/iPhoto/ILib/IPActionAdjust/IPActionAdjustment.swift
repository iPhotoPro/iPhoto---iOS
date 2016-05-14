//
//  IPActionAdjustment.swift
//  iPhoto
//
//  Created by ngodacdu on 5/12/16.
//  Copyright © 2016 ngodacdu. All rights reserved.
//

import UIKit

class IPActionAdjustment: UIView {
    
    let kPhotoTopPadding: CGFloat = 1.0

    @IBOutlet weak var collectionView: UICollectionView!
    
    private var actions: [(imageName: String?, contentName: String)] = [(imageName: String?, contentName: String)]()
    
    class func loadFromNib() -> IPActionAdjustment? {
        let objects = NSBundle.mainBundle().loadNibNamed("IPActionAdjustment", owner: self, options: nil)
        return objects.first as? IPActionAdjustment
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        prepareDataSource()
        registerActionAdjustmentCell()
    }
    
    private func prepareDataSource() {
        actions.append(("adjust-brightness", "Brightness"))
        actions.append(("adjust-contrast", "Contrast"))
        actions.append(("adjust-temperature", "Temperature"))
        actions.append(("adjust-exposure", "Exposure"))
        actions.append(("adjust-highlight", "Highlight"))
        actions.append(("adjust-shadow", "Shadow"))
        actions.append(("adjust-saturation", "Saturation"))
        actions.append(("adjust-rgb", "RGB"))
        actions.append(("adjust-hue", "Hue"))
        actions.append(("adjust-level", "Level"))
        actions.append(("adjust-sharpness", "Sharpness"))
        actions.append(("adjust-vignette", "Vignette"))
        actions.append(("adjust-gamma", "Gamma"))
        actions.append(("adjust-lookup", "Lookup"))
        actions.append(("adjust-monochrome", "Mono Chrome"))
        actions.append(("adjust-falsecolor", "False Color"))
        actions.append(("adjust-haze", "Haze"))
        actions.append(("adjust-opacity", "Opacity"))
        actions.append(("adjust-solidcolor", "Solid Color"))
        actions.append(("adjust-chromakey", "Chroma Key"))
    }
    
}

extension IPActionAdjustment: UICollectionViewDelegate, UICollectionViewDataSource {
    
    private func registerActionAdjustmentCell() {
        collectionView.registerNib(
            UINib(nibName: IPActionAdjustmentCell.Constant.name, bundle: nil),
            forCellWithReuseIdentifier: IPActionAdjustmentCell.Constant.identifier
        )
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return actions.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(IPActionAdjustmentCell.Constant.identifier, forIndexPath: indexPath) as! IPActionAdjustmentCell
        
        dispatch_async(dispatch_get_main_queue()) {
            if collectionView.indexPathsForVisibleItems().contains(indexPath) {
                let functionObject = self.actions[indexPath.row]
                cell.update(functionObject.imageName, name: functionObject.contentName)
            }
        }
        
        return cell
    }
    
}

extension IPActionAdjustment: UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: frame.height, height: frame.height)
    }
   
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return kPhotoTopPadding
    }
    
}
