//
//  ViewController.swift
//  iPhoto
//
//  Created by ngodacdu on 5/7/16.
//  Copyright © 2016 ngodacdu. All rights reserved.
//

import UIKit
import DLPhotoPicker

class HomeViewController: UIViewController {
    
    private let kPhotoTopPadding: CGFloat = 10
    private let kNumPhotoPerRow: Int = 3
    private var photoSize: CGSize = CGSizeZero

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func show(sender: AnyObject) {
        if let picker = StoryBoardManager.shareInstance.assetPhotoViewController() {
            picker.delegate = self
            picker.showsNumberOfAssets = true
            picker.pickerType = .Display;
            let fetchOptions = PHFetchOptions()
            fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
            picker.assetsFetchOptions = fetchOptions
            presentViewController(picker, animated: true, completion: nil)
        }
    }

}

extension HomeViewController: UINavigationControllerDelegate, DLPhotoPickerViewControllerDelegate {
    
    func pickerController(picker: DLPhotoPickerViewController!, didFinishPickingAssets assets: [AnyObject]!) {
        
    }
    
    private func computePhotoSize() -> CGSize {
        if photoSize == CGSizeZero {
            let width: CGFloat = (view.frame.width - CGFloat(kNumPhotoPerRow + 1) * kPhotoTopPadding) / CGFloat(kNumPhotoPerRow)
            photoSize = CGSize(width: width, height: width)
        }
        return photoSize
    }
    
    func pickerController(picker: DLPhotoPickerViewController!, collectionViewLayoutForContentSize contentSize: CGSize, traitCollection trait: UITraitCollection!) -> UICollectionViewLayout! {
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = computePhotoSize()
        layout.minimumInteritemSpacing = kPhotoTopPadding
        layout.minimumLineSpacing = kPhotoTopPadding
        layout.sectionInset = UIEdgeInsetsMake(
            kPhotoTopPadding,
            kPhotoTopPadding,
            kPhotoTopPadding,
            kPhotoTopPadding
        )
        
        return layout
    }
    
    func pickerController(picker: DLPhotoPickerViewController!, shouldEnableAsset asset: DLPhotoAsset!) -> Bool {
        return true
    }
    
    func pickerController(picker: DLPhotoPickerViewController!, shouldScrollToBottomForPhotoCollection assetCollection: DLPhotoCollection!) -> Bool {
        return false
    }
    
    func pickerController(picker: DLPhotoPickerViewController!, shouldSelectAsset asset: DLPhotoAsset!) -> Bool {
        return false
    }
    
    func pickerController(picker: DLPhotoPickerViewController!, didSelectAsset asset: DLPhotoAsset!) {
        
    }
    
    func pickerController(picker: DLPhotoPickerViewController!, shouldDeselectAsset asset: DLPhotoAsset!) -> Bool {
        return true
    }
    
    func pickerController(picker: DLPhotoPickerViewController!, didDeselectAsset asset: DLPhotoAsset!) {
        
    }
    
    func pickerController(picker: DLPhotoPickerViewController!, shouldHighlightAsset asset: DLPhotoAsset!) -> Bool {
        return true
    }
    
    func pickerController(picker: DLPhotoPickerViewController!, didHighlightAsset asset: DLPhotoAsset!) {
        
    }
    
}
