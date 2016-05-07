//
//  IOAssetPhoto.swift
//  IOAssetPhoto
//
//  Created by Ngo Dac Du on 5/5/16.
//  Copyright © 2016 Ngo Dac Du. All rights reserved.
//

import UIKit
import Photos

@objc protocol IOAssetPhotoDelegate: class {
    func didFinishedFetchAssetPhoto(fetchResults: [PHFetchResult])
    optional func photoLibraryDidChange(changeInstance: PHChange)
    optional func didFinishedCreateNewAlbum(success: Bool, error: NSError?)
}

enum IOAssetPhotoType {
    case AllPhoto
    case SmartAlbum
    case UserCollection
}

class IOAssetPhoto: NSObject {
    
    let kNSSortDescriptorKey = "creationDate"

    weak var delegate: IOAssetPhotoDelegate?
    
    func fetchAssetPhoto(type: IOAssetPhotoType) -> PHFetchResult? {
        var fetchResult: PHFetchResult?
        switch type {
        case .AllPhoto:
            fetchResult = fetchAllPhoto()
            break
        case .SmartAlbum:
            fetchResult = fetchSmartAlbum()
            break
        case .UserCollection:
            fetchResult = fetchUserCollection()
            break
        }
        return fetchResult
    }
    
    private func fetchAllPhoto() -> PHFetchResult {
        let allPhotosOptions = PHFetchOptions()
        allPhotosOptions.sortDescriptors = [NSSortDescriptor(key: kNSSortDescriptorKey, ascending: true)]
        return PHAsset.fetchAssetsWithOptions(allPhotosOptions)
    }
    
    private func fetchSmartAlbum() -> PHFetchResult {
        return PHAssetCollection.fetchAssetCollectionsWithType(
            .SmartAlbum,
            subtype: .AlbumRegular,
            options: nil
        )
    }
    
    private func fetchUserCollection() -> PHFetchResult {
        return PHCollectionList.fetchTopLevelUserCollectionsWithOptions(nil)
    }
    
    func createNewAlbum(name: String) {
        PHPhotoLibrary.sharedPhotoLibrary().performChanges({
            PHAssetCollectionChangeRequest.creationRequestForAssetCollectionWithTitle(name)
        }) { (success, error: NSError?) in
            self.delegate?.didFinishedCreateNewAlbum?(success, error: error)
        }
    }
    
    deinit {
        PHPhotoLibrary.sharedPhotoLibrary().unregisterChangeObserver(self)
    }
    
}

extension IOAssetPhoto: PHPhotoLibraryChangeObserver {
    
    /*
     Change notifications may be made on a background queue. Re-dispatch to the
     main queue before acting on the change as we'll be updating the UI.
     */
    func photoLibraryDidChange(changeInstance: PHChange) {
        delegate?.photoLibraryDidChange?(changeInstance)
    }
    
}
