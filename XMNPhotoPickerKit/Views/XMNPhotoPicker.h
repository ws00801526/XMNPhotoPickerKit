//
//  XMNPhotoPicker.h
//  XMNPhotoPickerKitExample
//
//  Created by XMFraker on 16/2/1.
//  Copyright © 2016年 XMFraker. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XMNAssetModel;
@interface XMNPhotoPicker : UIView


/** 最大选择数量 默认0 不限制 */
@property (nonatomic, assign) NSUInteger maxCount;
/** 最大预览图数量 默认20 */
@property (nonatomic, assign) NSUInteger maxPreviewCount;
/** 是否可以选择视频 默认YES */
@property (nonatomic, assign) BOOL pickingVideoEnable;

/** parentController,用来显示其他controller */
@property (nonatomic, weak)   UIViewController *parentController;

/** 用户选择完照片的回调 images<previewImage>  assets<PHAsset or ALAsset>*/
@property (nonatomic, copy)   void(^didFinishPickingPhotosBlock)(NSArray<UIImage *>* images, NSArray<XMNAssetModel *>*assets);

/** 用户选择完视频的回调 coverImage:视频的封面,asset 视频资源地址 */
@property (nonatomic, copy)   void(^didFinishPickingVideoBlock)(UIImage *coverImage, id asset);

+ (instancetype)sharePhotoPicker;

- (instancetype)initWithMaxCount:(NSUInteger)maxCount;

- (void)showPhotoPickerwithController:(UIViewController *)controller animated:(BOOL)animated;

@end

