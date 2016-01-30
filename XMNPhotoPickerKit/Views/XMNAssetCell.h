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

@property (nonatomic, copy)   BOOL(^willChangeSelectedStateBlock)(UIButton *button);

@property (nonatomic, copy)   void(^didChangeSelectedStateBlock)(BOOL selected, XMNAssetModel *asset);

@property (nonatomic, strong, readonly) XMNAssetModel *asset;


- (void)configCellWithItem:(XMNAssetModel *)item;

@end
