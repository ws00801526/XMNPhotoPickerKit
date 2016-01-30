//
//  XMNPhotoPreviewCell.h
//  XMNPhotoPickerKitExample
//
//  Created by XMFraker on 16/1/29.
//  Copyright © 2016年 XMFraker. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XMNAssetModel;
@interface XMNPhotoPreviewCell : UICollectionViewCell

@property (nonatomic, copy)   void(^singleTapBlock)();


- (void)configCellWithItem:(XMNAssetModel *)item;

@end
