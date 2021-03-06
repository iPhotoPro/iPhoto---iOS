//
//  IOAssetPhotoViewController.swift
//  iPhoto
//
//  Created by ngodacdu on 5/8/16.
//  Copyright © 2016 ngodacdu. All rights reserved.
//

import UIKit
import DLPhotoPicker

enum Target {
    case Edit
    case Union
}

protocol IOAssetPhotoViewControllerDelegate: class {
    func collectionViewDidSelectedPhotos(photoAssets: [DLPhotoAsset])
}

class IOAssetPhotoViewController: DLPhotoCollectionViewController {
    
    let kPhotoTopPadding: CGFloat = 7
    let kImageViewPadding: CGFloat = 2
    let kNumPhotoPerRow: Int = 3
    
    var limit: Int = 0
    var target: Target = .Edit
    lazy private var selectedIndexPaths: [NSIndexPath] = [NSIndexPath]()
    lazy private var selectedAssets: [DLPhotoAsset] = [DLPhotoAsset]()
    weak var collectionDelegate: IOAssetPhotoViewControllerDelegate?
    
    var navigationTitle: String = "Camera Roll" {
        didSet {
            navigationController?.navigationBar.topItem?.title = navigationTitle
        }
    }
    private var photoSize: CGSize = CGSizeZero
    private var imageViewSize: CGSize = CGSizeZero
    private var noAssetView: IOAssetPhotoEmptyView?
    private var assets: [AnyObject] = [AnyObject]()

    override func viewDidLoad() {
        super.viewDidLoad()
        prepareAssetPhoto()
        registerAssetPhotoCell()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        prepareNavigationItem()
    }
    
    override func viewDidLayoutSubviews() {
        //TODO override but do nothing
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func prepareNavigationItem() {
        navigationItem.leftBarButtonItem = nil
        navigationItem.rightBarButtonItem = nil
        collectionView?.backgroundColor = UIColor.groupTableViewBackgroundColor()
        let dismissBarButton = UIBarButtonItem(
            image: UIImage(named: "dismiss"),
            style: .Plain,
            target: self,
            action: #selector(IOAssetPhotoViewController.didTouchUpInsideDismisButton(_:))
        )
        navigationItem.leftBarButtonItem = dismissBarButton
        let menuBarButton = UIBarButtonItem(
            image: UIImage(named: "menu"),
            style: .Plain,
            target: self,
            action: #selector(IOAssetPhotoViewController.didTouchUpInsideMenuButton(_:))
        )
        navigationItem.rightBarButtonItem = menuBarButton
    }
    
    func didTouchUpInsideDismisButton(sender: UIBarButtonItem) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            self.selectedAssets.removeAll(keepCapacity: false)
            for indexPath in self.selectedIndexPaths {
                if let item = self.assets[indexPath.row] as? DLPhotoAsset {
                    self.selectedAssets.append(item)
                }
            }
            dispatch_async(dispatch_get_main_queue(), {
                self.collectionDelegate?.collectionViewDidSelectedPhotos(self.selectedAssets)
                self.dismissViewControllerAnimated(true, completion: nil)
            })
        }
    }
    
    func didTouchUpInsideMenuButton(sender: UIBarButtonItem) {
        if let menu = StoryBoardManager.shareInstance.menuViewController() {
            if let controller = menu.visibleViewController as? IOMenuViewController {
                controller.delegate = self
            }
            menu.modalTransitionStyle = .CrossDissolve
            presentViewController(menu, animated: true, completion: nil)
        }
    }

    private func prepareAssetPhoto() {
        weak var weakSelf = self
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            if weakSelf?.photoCollection == nil {
                let fetchOptions = PHFetchOptions()
                fetchOptions.predicate = NSPredicate(format: "mediaType == %d", PHAssetMediaType.Image.rawValue)
                DLPhotoManager.sharedInstance().assetsFetchOptions = fetchOptions
                DLPhotoManager.sharedInstance().fetchPhotoCollection({ (success) in
                    if success {
                        if let first = DLPhotoManager.sharedInstance().photoCollections.first as? DLPhotoCollection {
                            weakSelf?.photoCollection = first
                            weakSelf?.assets = DLPhotoManager.sharedInstance().assetsForPhotoCollection(weakSelf?.photoCollection)
                            dispatch_async(dispatch_get_main_queue(), {
                                self.resetAssetsAndReload()
                                self.navigationTitle = self.photoCollection.title
                            })
                        }
                    }
                })
            }
        }
    }
    
}

extension IOAssetPhotoViewController {
    
    private func registerAssetPhotoCell() {
        collectionView?.registerNib(
            UINib(nibName: IOAssetPhotoCell.name, bundle: nil),
            forCellWithReuseIdentifier: IOAssetPhotoCell.identifier
        )
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(IOAssetPhotoCell.identifier, forIndexPath: indexPath) as! IOAssetPhotoCell
        
        weak var weakSelf = self
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            if let currentAsset = weakSelf?.assets[indexPath.row] as? DLPhotoAsset {
                cell.identifier = currentAsset.phAsset.localIdentifier
                if let size = weakSelf?.computeImageViewSize() {
                    currentAsset.requestThumbnailImageWithSize(size) { (image: UIImage!, info: [NSObject : AnyObject]!) in
                        dispatch_async(dispatch_get_main_queue(), {
                            if currentAsset.phAsset.localIdentifier == cell.identifier {
                                if collectionView.indexPathsForVisibleItems().contains(indexPath) {
                                    cell.photoImageView.image = image
                                }
                            }
                        })
                    }
                }
            }
        }
        if self.selectedIndexPaths.contains(indexPath) {
            cell.updateState(true)
        } else {
            cell.updateState(false)
        }
        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        switch target {
        case .Edit:
            if let controller = StoryBoardManager.shareInstance.photoEditViewController() {
                if let currentAsset = assets[indexPath.row] as? DLPhotoAsset {
                    controller.asset = currentAsset
                }
                navigationController?.pushViewController(controller, animated: true)
            }
            break
        case .Union:
            if selectedIndexPaths.count < limit {
                if let cell = collectionView.cellForItemAtIndexPath(indexPath) as? IOAssetPhotoCell {
                    cell.updateState(true)
                }
                selectedIndexPaths.append(indexPath)
            }
            break
        }
    }
    
    override func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        if let cell = collectionView.cellForItemAtIndexPath(indexPath) as? IOAssetPhotoCell {
            if self.selectedIndexPaths.contains(indexPath) {
                cell.updateState(false)
                for (index, item) in selectedIndexPaths.enumerate() {
                    if item.isEqual(indexPath) {
                        selectedIndexPaths.removeAtIndex(index)
                    }
                }
            }
        }
    }
    
}

extension IOAssetPhotoViewController: UICollectionViewDelegateFlowLayout {
    
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
            if let layout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
                let itemSize = layout.itemSize
                imageViewSize.width = scale * (itemSize.width - kImageViewPadding)
                imageViewSize.height = scale * (itemSize.height - kImageViewPadding)
            }
        }
        return imageViewSize
    }
    
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

extension IOAssetPhotoViewController: IOMenuViewControllerDelegate {
    
    override func reloadData() {
        dispatch_async(dispatch_get_main_queue(), {
            if self.assets.count > 0 {
                self.hideNoAssetView()
            } else {
                self.showNoAssetView()
            }
            self.collectionView?.reloadData()
            self.collectionView?.setContentOffset(CGPointZero, animated: false)
        })
    }
    
    private func showNoAssetView() {
        noAssetView = IOAssetPhotoEmptyView.loadFromNib()
        if let noAssetView = noAssetView {
            noAssetView.frame = view.bounds
            view.addSubview(noAssetView)
            noAssetView.setNeedsUpdateConstraints()
            noAssetView.updateConstraintsIfNeeded()
        }
    }
    
    private func hideNoAssetView() {
        noAssetView?.removeFromSuperview()
    }
    
    func didSelectedRow(collection: DLPhotoCollection) {
        if photoCollection == collection {
            return
        }
        weak var weakSelf = self
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            weakSelf?.photoCollection = collection
            weakSelf?.assets = DLPhotoManager.sharedInstance().assetsForPhotoCollection(weakSelf?.photoCollection)
            dispatch_async(dispatch_get_main_queue(), {
                self.resetAssetsAndReload()
                self.navigationTitle = self.photoCollection.title
            })
        }
    }
    
}
