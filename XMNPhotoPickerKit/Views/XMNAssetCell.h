//
//  XMNAssetCell.h
//  XMNPhotoPickerKitExample
//
//  Created by XMFraker on 16/1/28.
//  Copyright © 2016年 XMFraker. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XMNAssetModel;
@interface XMNAssetCell : UICollectionViewCell

/**
 *  按钮点击后的回调
 *  返回按钮的状态是否会被更改
 */
@property (nonatomic, copy)   BOOL(^_Nullable willChangeSelectedStateBlock)(XMNAssetModel * _Nonnull asset);

/**
 *  当按钮selected状态改变后,回调
 */
@property (nonatomic, copy)   void(^_Nullable didChangeSelectedStateBlock)(BOOL selected, XMNAssetModel * _Nonnull asset);

@property (nonatomic, copy)   void(^_Nullable didSendAsset)(XMNAssetModel * _Nonnull asset, CGRect frame);


/**
 *  具体的资源model
 */
@property (nonatomic, strong, readonly) XMNAssetModel * _Nonnull asset;

/**
 *  XMNPhotoCollectionController 中配置collectionView的cell
 *
 *  @param item 具体的AssetModel
 */
- (void)configCellWithItem:(XMNAssetModel * _Nonnull )item;

/**
 *  XMNPhotoPicker 中配置collectionView的cell
 *
 *  @param item 具体的AssetModel
 */
- (void)configPreviewCellWithItem:(XMNAssetModel * _Nonnull )item;

@end
