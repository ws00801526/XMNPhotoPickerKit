//
//  XMNVideoPreviewController.h
//  XMNPhotoPickerKitExample
//
//  Created by XMFraker on 16/1/29.
//  Copyright © 2016年 XMFraker. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XMNAssetModel;
@interface XMNVideoPreviewController : UIViewController

/** 是否可以选择视频,默认视频,照片不能同时选择 */
@property (nonatomic, assign) BOOL selectedVideoEnable;
/** 资源model */
@property (nonatomic, strong) XMNAssetModel *asset;


@end
