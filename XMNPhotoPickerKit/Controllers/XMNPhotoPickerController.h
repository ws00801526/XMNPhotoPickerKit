//
//  XMNPhotoPickerController.h
//  XMNPhotoPickerKitExample
//  照片选择控件
//  Created by XMFraker on 16/1/28.
//  Copyright © 2016年 XMFraker. All rights reserved.
//

/**
 *  只有在用户点击了cancel后才会主动dismiss掉
 *
 */


#import <UIKit/UIKit.h>

@class XMNAssetModel;
@protocol XMNPhotoPickerControllerDelegate;
@interface XMNPhotoPickerController : UINavigationController

#pragma mark - Properties

/** 是否允许选择视频 默认YES*/
@property (nonatomic, assign) BOOL pickingVideoEnable;
/** 是否自动push到相册页面 默认YES*/
@property (nonatomic, assign) BOOL autoPushToPhotoCollection;
/** 每次最多可以选择带图片数量 默认9*/
@property (nonatomic, assign) NSUInteger maxCount;

/** delegate 回调 */
@property (nonatomic, weak)   id<XMNPhotoPickerControllerDelegate> photoPickerDelegate;

/** 用户选择完照片的回调 images<previewImage>  assets<PHAsset or ALAsset>*/
@property (nonatomic, copy)   void(^didFinishPickingPhotosBlock)(NSArray<UIImage *>* images, NSArray<XMNAssetModel *>*assets);

/** 用户选择完视频的回调 coverImage:视频的封面,asset 视频资源地址 */
@property (nonatomic, copy)   void(^didFinishPickingVideoBlock)(UIImage *coverImage, id asset);
/** 用户点击取消的block 回调 */
@property (nonatomic, copy)   void(^didCancelPickingPhotosBlock)();


#pragma mark - Life Cycle

/**
 *  初始化XMNPhotoPickerController
 *
 *  @param maxCount 最大选择数量 0则不限制
 *  @param delegate 使用delegate 回调
 *
 *  @return XMNPhotoPickerController实例 或者 nil
 */
- (instancetype)initWithMaxCount:(NSUInteger)maxCount delegate:(id<XMNPhotoPickerControllerDelegate>)delegate NS_DESIGNATED_INITIALIZER;

#pragma mark - Methods

/**
 *  call photoPickerDelegate & didFinishPickingPhotosBlock
 *  
 *  @param assets 具体回传的资源
 */
- (void)didFinishPickingPhoto:(NSArray<XMNAssetModel *> *)assets;
/**
 *  call photoPickerDelegate  & didFinishPickingVideoBlock
 *
 *  @param asset 具体选择的视频资源
 */
- (void)didFinishPickingVideo:(XMNAssetModel *)asset;

/**
 *  call photoPickerDelegate & didCancelPickingPhotosBlock
 */
- (void)didCancelPickingPhoto;

/**
 *  显示一个alert提示框
 *
 *  @param title 具体提示的message
 */
- (void)showAlertWithTitle:(NSString *)title;

@end


@protocol XMNPhotoPickerControllerDelegate <NSObject>

@optional

/**
 *  photoPickerController 点击确定后 代理回调
 *
 *  @param picker 具体的pickerController
 *  @param photos 选择的照片 -- 预览图
 *  @param assets 选择的原图数组  NSArray<PHAsset *>  or NSArray<ALAsset *> or nil
 */
- (void)photoPickerController:(XMNPhotoPickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets;

/**
 *  photoPickerController 点击取消后回调
 *
 *  @param picker 具体的pickerController
 */
- (void)photoPickerControllerDidCancel:(XMNPhotoPickerController *)picker;

/**
 *  photoPickerController选择一个视频后的回调
 *
 *  @param picker     具体的photoPickerController
 *  @param coverImage 视频的预览图
 *  @param asset      视频的具体资源 PHAsset or ALAsset
 */
- (void)photoPickerController:(XMNPhotoPickerController *)picker didFinishPickingVideo:(UIImage *)coverImage sourceAssets:(id)asset;

@end


@interface XMNAlbumListController : UITableViewController

@property (nonatomic, copy)   NSArray *albums;

@end