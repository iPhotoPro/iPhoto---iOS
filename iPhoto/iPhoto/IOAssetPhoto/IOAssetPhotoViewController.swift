//
//  IOAssetPhotoViewController.swift
//  IOFetchAssetPhoto
//
//  Created by ngodacdu on 5/5/16.
//  Copyright © 2016 ngodacdu. All rights reserved.
//

import UIKit
import Photos

protocol IOAssetPhotoViewControllerDelegate: class {
    func didSelectedAssetImages(assets: [PHAsset])
}

class IOAssetPhotoViewController: UIViewController {
    
    let kNavigationBarHeight: CGFloat = 64.0
    let kAnimation: NSTimeInterval = 0.25
    let kPhotoTopPadding: CGFloat = 10
    let kImageViewPadding: CGFloat = 2
    let kNumPhotoPerRow: Int = 3
    
    lazy private var selectedIndexPaths: [NSIndexPath] = [NSIndexPath]()
    weak var delegate: IOAssetPhotoViewControllerDelegate?
    
    private var photoSize: CGSize = CGSizeZero
    private var imageViewSize: CGSize = CGSizeZero

    private var customNavigationBar: CustomNavigationBar!
    private var collectionView: UICollectionView!
    private var assetPhoto: IOAssetPhoto!
    private var fetchResult: PHFetchResult! {
        didSet {
            dispatch_async(dispatch_get_main_queue()) {
                self.collectionView.reloadData()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        preparePhotoViewController()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: Prepare
    private func preparePhotoViewController() {
        prepareCustomNavigationBar()
        prepareCollectionView()
        prepareDataSource()
        registerPhotoCell()
    }
    
    private func prepareCustomNavigationBar() {
        customNavigationBar = CustomNavigationBar.loadFromNib()
        if let customNavigationBar = customNavigationBar {
            var frame = view.frame
            frame.size.height = kNavigationBarHeight
            customNavigationBar.frame = frame
            customNavigationBar.closeButton.addTarget(
                self,
                action: #selector(IOAssetPhotoViewController.closeMenu(_:)),
                forControlEvents: .TouchUpInside
            )
            customNavigationBar.menuButton.addTarget(
                self,
                action: #selector(IOAssetPhotoViewController.showMenu(_:)),
                forControlEvents: .TouchUpInside
            )
            view.addSubview(customNavigationBar)
        }
    }
    
    func closeMenu(sender: UIButton) {
        let userDefault = NSUserDefaults.standardUserDefaults()
        userDefault.setValue(nil, forKey: kSectionKey)
        userDefault.setValue(nil, forKey: kRowKey)
        userDefault.synchronize()
        var assets: [PHAsset] = [PHAsset]()
        if selectedIndexPaths.count > 0 {
            for item in selectedIndexPaths {
                if let asset = fetchResult[item.row] as? PHAsset {
                    assets.append(asset)
                }
            }
        }
        dismissViewControllerAnimated(true) { 
            self.delegate?.didSelectedAssetImages(assets)
        }
    }
    
    func showMenu(sender: UIButton) {
        let controller = IOMenuViewController(nibName: IOMenuViewController.name, bundle: nil)
        controller.modalTransitionStyle = .CrossDissolve
        controller.delegate = self
        presentViewController(controller, animated: true, completion: nil)
    }
    
    private func prepareCollectionView() {
        if collectionView == nil {
            var frame = view.frame
            frame.origin.y = kNavigationBarHeight
            frame.size.height = frame.height - kNavigationBarHeight
            let layout = UICollectionViewFlowLayout()
            collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
            collectionView.backgroundColor = UIColor.groupTableViewBackgroundColor()
            collectionView.dataSource = self
            collectionView.delegate = self
            view.addSubview(collectionView)
        }
    }
    
    private func prepareDataSource() {
        if assetPhoto == nil {
            assetPhoto = IOAssetPhoto()
            fetchResult = assetPhoto.fetchAssetPhoto(.AllPhoto)
        }
    }
    
    //MARK: Compute size
    private func computePhotoSize() -> CGSize {
        if photoSize == CGSizeZero {
            let width: CGFloat = (view.frame.width - CGFloat(kNumPhotoPerRow + 1) * kPhotoTopPadding) / CGFloat(kNumPhotoPerRow)
            photoSize = CGSize(width: width, height: width)
        }
        return photoSize
    }
    
    private func computeImageViewSize() -> CGSize {
        if imageViewSize == CGSizeZero {
            let scale = UIScreen.mainScreen().scale
            if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                let itemSize = layout.itemSize
                imageViewSize.width = scale * (itemSize.width - kImageViewPadding)
                imageViewSize.height = scale * (itemSize.height - kImageViewPadding)
            }
        }
        return imageViewSize
    }
    
}

extension IOAssetPhotoViewController: IOMenuViewControllerDelegate {
    
    func tableViewDidSelected(indexPath: NSIndexPath, title: String?) {
        customNavigationBar.contentLabel.text = title
        fetchResult = currentFetchResult(indexPath)
    }
    
    private func currentFetchResult(indexPath: NSIndexPath) -> PHFetchResult? {
        if indexPath.section == IOAssetPhotoType.AllPhoto.hashValue {
            return assetPhoto.fetchAssetPhoto(.AllPhoto)
        }
        var currentFetchResult: PHFetchResult? {
            if indexPath.section == IOAssetPhotoType.SmartAlbum.hashValue {
                return assetPhoto.fetchAssetPhoto(.SmartAlbum)
            }
            return assetPhoto.fetchAssetPhoto(.UserCollection)
        }
        if let currentFetchResult = currentFetchResult, current = currentFetchResult[indexPath.row] as? PHAssetCollection {
            return PHAsset.fetchAssetsInAssetCollection(current, options: nil)
        }
        return nil
    }
    
}

extension IOAssetPhotoViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    private func registerPhotoCell() {
        collectionView.registerClass(
            IOAssetPhotoCell.self,
            forCellWithReuseIdentifier: IOAssetPhotoCell.Constant.identifier
        )
    }
    
    private func numOfRowInCollectionView() -> Int {
        return fetchResult.count
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numOfRowInCollectionView()
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(IOAssetPhotoCell.Constant.identifier, forIndexPath: indexPath) as! IOAssetPhotoCell
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) {
            if let asset = self.fetchResult[indexPath.item] as? PHAsset {
                cell.representedAssetIdentifier = asset.localIdentifier
                PHImageManager.defaultManager().requestImageForAsset(
                    asset,
                    targetSize: self.computeImageViewSize(),
                    contentMode: .AspectFill,
                    options: nil) { (result: UIImage?, info) in
                        if asset.localIdentifier == cell.representedAssetIdentifier {
                            dispatch_async(dispatch_get_main_queue(), {
                                if collectionView.indexPathsForVisibleItems().contains(indexPath) {
                                    cell.updateImage(result)
                                }
                                if self.selectedIndexPaths.contains(indexPath) {
                                    cell.updateState(true)
                                } else {
                                    cell.updateState(false)
                                }
                            })
                        }
                }
            }
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if let cell = collectionView.cellForItemAtIndexPath(indexPath) as? IOAssetPhotoCell {
            if selectedIndexPaths.contains(indexPath) {
                cell.updateState(false)
                for (index, item) in selectedIndexPaths.enumerate() {
                    if item.isEqual(indexPath) {
                        selectedIndexPaths.removeAtIndex(index)
                    }
                }
            } else {
                cell.updateState(true)
                selectedIndexPaths.append(indexPath)
            }
            let count = selectedIndexPaths.count
            var title = "Done"
            if count > 0 {
                title = "Done (\(count))"
            }
            customNavigationBar.closeButton.setTitle(title, forState: .Normal)
        }
    }
    
}

extension IOAssetPhotoViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return computePhotoSize()
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return kPhotoTopPadding
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return kPhotoTopPadding
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: kPhotoTopPadding, left: kPhotoTopPadding, bottom: kPhotoTopPadding, right: kPhotoTopPadding)
    }
    
}
