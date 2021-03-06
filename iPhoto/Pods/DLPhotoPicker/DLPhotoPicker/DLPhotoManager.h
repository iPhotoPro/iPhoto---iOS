//
//  DLPhotoManager.h
//  DLPhotoPicker
//
//  Created by 沧海无际 on 16/2/20.
//  Copyright © 2016年 darling0825. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "DLPhotoCollection.h"
#import "DLPhotoAsset.h"


typedef NS_ENUM(NSInteger, DLAuthorizationStatus) {
    DLAuthorizationStatusSuccess          = 0,
    DLAuthorizationStatusAccessDenied     = 1,
    DLAuthorizationStatusNoAssets         = 2,
    DLAuthorizationStatusUnknown          = 3,
};



@protocol ALAssetsLibraryChangeObserver <NSObject>
@optional
-(void)assetsLibraryChanged:(NSNotification *)notification;

@end



@interface DLPhotoManager : NSObject


@property (nonatomic, strong) NSArray *photoCollections;
@property (nonatomic, strong) NSArray *fetchResults;




+ (instancetype)sharedInstance;



/**
 *  Determines whether or not the empty albums is shown in the album list.
 *
 *  All albums are visible by default. To hide albums without assets matched with `assetsFetchOptions`,
 *  set this property’s value to `NO`.
 *
 *  @see assetsFetchOptions
 */
@property (nonatomic, assign) BOOL showsEmptyAlbums;

/**
 *  Set the `assetCollectionSubtypes` to specify which asset collections (albums) to be shown in the picker.
 *  only iOS 8 or later
 *  You can specify which albums and their order to be shown in the picker by creating an `NSArray` of `NSNumber`
 *  that containing the value of `PHAssetCollectionSubtype`.
 */
@property (nonatomic, copy) NSArray *assetCollectionSubtypes NS_AVAILABLE_IOS(8.0);

/**
 *  Set the `PHFetchOptions` to specify options when fetching asset collections (albums).
 *  only iOS 8 or later
 *  @see assetsFetchOptions
 */
@property (nonatomic, strong) PHFetchOptions *assetCollectionFetchOptions NS_AVAILABLE_IOS(8.0);

/**
 *  Set the `PHFetchOptions` to specify options when fetching assets.
 *  only iOS 8 or later
 *  @see assetCollectionFetchOptions
 */
@property (nonatomic, strong) PHFetchOptions *assetsFetchOptions NS_AVAILABLE_IOS(8.0);

/**
 *  only iOS 8 or later
 */
@property (nonatomic, strong) PHImageRequestOptions *thumbnailRequestOptions NS_AVAILABLE_IOS(8.0);

/**
 *  default album (CameraRoll)
 */
@property (nonatomic, copy, readonly) NSString *defaultAlbum;
@property (nonatomic, copy, readonly) DLPhotoCollection *defaultCollection;

/**
 *  PHCachingImageManager
 *  only iOS 8 or later
 */
- (PHCachingImageManager *)phCachingImageManager NS_AVAILABLE_IOS(8.0);

/**
 *  PHCachingImageManager
 *  only iOS 8 or below
 */
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (ALAssetsLibrary *)assetsLibrary NS_DEPRECATED_IOS(4_0, 7_0, "Use Photos framework instead");
#pragma clang diagnostic pop

/**
 *  checkAuthorizationStatus
 */
- (void)checkAuthorizationStatus:(void(^)(DLAuthorizationStatus status))completion;


/**
 *  requestAuthorization
 */
- (void)requestAuthorization;

//  favorite asset
- (void)favoriteAsset:(DLPhotoAsset *)photoAsset
           completion:(void(^)(BOOL success, NSError *error))completion;

//  create album
- (void)createAlbumWithName:(NSString *)albumName
                resultBlock:(void(^)(DLPhotoCollection *collection))completion
               failureBlock:(void(^)(NSError *error))failure;
//  remove album
- (void)removeAlbum:(DLPhotoCollection *)photoCollection
        resultBlock:(void(^)(BOOL success))completion
        failureBlock:(void(^)(NSError *error))failure NS_AVAILABLE_IOS(8.0);

/**
 *  save image
 *  if albumName is nil, the image will save to default album.(CameraRoll)
 */
- (void)saveImage:(UIImage *)image
          toAlbum:(NSString *)albumName
       completion:(void(^)(BOOL success))completion
          failure:(void(^)(NSError *error))failure;

//  save video
- (void)saveVideo:(NSURL *)videoUrl
          toAlbum:(NSString *)albumName
       completion:(void(^)(BOOL success))completion
          failure:(void(^)(NSError *error))failure;

//  iOS 8 or later
- (void)removeAsset:(NSArray<DLPhotoAsset *> *)photoAssets
         completion:(void(^)(BOOL success))completion
            failure:(void(^)(NSError *error))failure NS_AVAILABLE_IOS(8.0);

//  iOS 7 or below
- (void)saveImageData:(NSData *)imageData
              toAlbum:(NSString *)albumName
             metadata:(NSDictionary *)metadata
           completion:(void(^)(BOOL success))completion
              failure:(void(^)(NSError *error))failure NS_DEPRECATED_IOS(4_0, 7_0, "Use saveImage:toAlbum:completion:failure: instead");
//  iOS 7 or below
- (void)addAssetURL:(NSURL *)assetUrl
            toAlbum:(NSString *)albumName
        resultBlock:(void(^)(BOOL success))completion
       failureBlock:(void(^)(NSError *error))failure NS_DEPRECATED_IOS(4_0, 7_0, "Use saveImage:toAlbum:completion:failure: instead");


/**
 *  can not work
 *  iOS 7 or below
 */
- (void)removeAssetURL:(NSArray<DLPhotoAsset *> *)photoAssets
           resultBlock:(void(^)(BOOL success))completion
          failureBlock:(void(^)(NSError *error))failure NS_DEPRECATED_IOS(4_0, 7_0, "Use saveImage:toAlbum:completion:failure: instead");


/**
 *  Photo edit
 *
 *  @param asset      The asset will edit
 *  @param completion completion
 */
- (void)requestContentEditing:(DLPhotoAsset *)asset
                   completion:(void (^)(UIImage *image, PHContentEditingInput *contentEditingInput, NSDictionary *info))completion NS_AVAILABLE_IOS(8.0);

- (void)saveContentEditing:(DLPhotoAsset *)asset
                     image:(UIImage *)image
       contentEditingInput:(PHContentEditingInput *)contentEditingInput
     adjustmentDescription:(NSData *)adjustmentDescription NS_AVAILABLE_IOS(8.0);



/**
 *  fetch Photo Collection
 */
- (void)fetchPhotoCollection:(void(^)(BOOL success))completion;


/**
 *  Get asset count in a 'DLPhotoCollection'
 *
 *  @param photoCollection DLPhotoCollection
 *
 *  @return The count of asset in 'DLPhotoCollection'.
 */
- (NSUInteger)assetCountOfPhotoCollection:(DLPhotoCollection *)photoCollection;

/**
 *  Get assets in a 'DLPhotoCollection'
 *
 *  @param photoCollection DLPhotoCollection
 *
 *  @return DLPhotoCollection
 */
- (NSArray *)assetsForPhotoCollection:(DLPhotoCollection *)photoCollection;


/**
 *  posterAssets
 *
 *  @param photoCollection DLPhotoCollection
 *  @param count           NSUInteger
 *
 *  @return DLPhotoAsset -> NSArray
 */
- (NSArray *)posterAssetsForPhotoCollection:(DLPhotoCollection *)photoCollection count:(NSUInteger)count;

/**
 *  posterImages
 *
 *  @param collection    DLPhotoCollection
 *  @param thumbnailSize CGSize
 *  @param count         NSUInteger(iOS 7: count = 1)
 *
 *  @return UIImage -> NSArray
 */
- (NSArray *)posterImagesForPhotoCollection:(DLPhotoCollection *)collection thumbnailSize:(CGSize)thumbnailSize count:(NSUInteger)count;

/**
 *  Register observer for photo library
 *
 *  @param observer observer
 */
- (void)registerChangeObserver:(id<PHPhotoLibraryChangeObserver,ALAssetsLibraryChangeObserver>)observer;
- (void)unregisterChangeObserver:(id<PHPhotoLibraryChangeObserver,ALAssetsLibraryChangeObserver>)observer;

/**
 *  PHImageManager start or stop caching image
 *
 *  only iOS 8 or later
 *  @param asset      DLPhotoAsset
 *  @param targetSize CGSize
 */
- (void)startCachingImagesForAssets:(DLPhotoAsset *)asset targetSize:(CGSize)targetSize NS_AVAILABLE_IOS(8.0);
- (void)stopCachingImagesForAssets:(DLPhotoAsset *)asset targetSize:(CGSize)targetSize NS_AVAILABLE_IOS(8.0);
- (void)stopCachingImagesForAllAssets NS_AVAILABLE_IOS(8.0);

// for test
- (UIImage *)originImage:(DLPhotoAsset *)photoAsset;
@end
