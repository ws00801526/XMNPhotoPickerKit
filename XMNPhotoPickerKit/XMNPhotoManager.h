//
//  XMNPhotoManager.h
//  XMNPhotoPickerKitExample
//
//  Created by XMFraker on 16/1/28.
//  Copyright © 2016年 XMFraker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>

#import "XMNPhotoPickerDefines.h"
#import "XMNAlbumModel.h"
#import "XMNAssetModel.h"

@interface XMNPhotoManager : NSObject

@property (nonatomic, strong, readonly)  PHCachingImageManager *cachingImageManager;

#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
@property (nonatomic, strong, readonly)  ALAssetsLibrary *assetLibrary;
#pragma clang diagnostic pop


+ (instancetype)sharedManager;

#pragma mark - Methods

/**
 *  判断用户是否打开了图片授权
 *
 *  @return YES or NO
 */
- (BOOL)hasAuthorized;

/// ========================================
/// @name   获取Album相册相关方法
/// ========================================

/**
 *  获取所有的相册
 *
 *  @param pickingVideoEnable 是否允许选择视频
 *  @param completionBlock    回调block
 */
- (void)getAlbumsPickingVideoEnable:(BOOL)pickingVideoEnable completionBlock:(void(^)(NSArray<XMNAlbumModel *> *albums))completionBlock;

/**
 *  获取相册中的所有图片,视频
 *
 *  @param result             对应相册  PHFetchResult or ALAssetsGroup<ALAsset>
 *  @param pickingVideoEnable 是否允许选择视频
 *  @param completionBlock    回调block
 */
- (void)getAssetsFromResult:(id)result pickingVideoEnable:(BOOL)pickingVideoEnable completionBlock:(void(^)(NSArray<XMNAssetModel *> * assets))completionBlock;

/// ========================================
/// @name   获取Asset对应信息相关方法
/// ========================================

- (void)getOriginImageWithAsset:(id)asset completionBlock:(void(^)(UIImage *image))completionBlock;
- (void)getThumbnailWithAsset:(id)asset size:(CGSize)size completionBlock:(void(^)(UIImage *image))completionBlock;
- (void)getPreviewImageWithAsset:(id)asset completionBlock:(void(^)(UIImage *image))completionBlock;
- (void)getImageOrientationWithAsset:(id)asset completionBlock:(void(^)(UIImageOrientation imageOrientation))completionBlock;

- (void)getAssetSizeWithAsset:(id)asset completionBlock:(void(^)(CGFloat size))completionBlock;

- (void)getVideoInfoWithAsset:(id)asset completionBlock:(void(^)(AVPlayerItem *playerItem,NSDictionary *playetItemInfo))completionBlock;

@end
