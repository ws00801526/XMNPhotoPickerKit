//
//  XMNPhotoCollectionController.h
//  XMNPhotoPickerKitExample
//
//  Created by XMFraker on 16/1/29.
//  Copyright © 2016年 XMFraker. All rights reserved.
//

#import <UIKit/UIKit.h>


@class XMNAlbumModel;
@interface XMNPhotoCollectionController : UICollectionViewController

@property (nonatomic, strong) XMNAlbumModel *album;

+ (UICollectionViewLayout *)photoCollectionViewLayoutWithWidth:(CGFloat)width;

@end
