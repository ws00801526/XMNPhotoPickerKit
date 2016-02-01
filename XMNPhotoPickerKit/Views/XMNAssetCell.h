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
@property (nonatomic, copy)   BOOL(^willChangeSelectedStateBlock)(UIButton *button);

/**
 *  当按钮selected状态改变后,回调
 */
@property (nonatomic, copy)   void(^didChangeSelectedStateBlock)(BOOL selected, XMNAssetModel *asset);

@property (nonatomic, copy)   void(^didSendAsset)(XMNAssetModel *asset);


/**
 *  具体的资源model
 */
@property (nonatomic, strong, readonly) XMNAssetModel *asset;


- (void)configCellWithItem:(XMNAssetModel *)item;

- (void)configPreviewCellWithItem:(XMNAssetModel *)item;

@end
