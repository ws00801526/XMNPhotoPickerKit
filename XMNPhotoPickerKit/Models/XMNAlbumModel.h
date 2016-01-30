//
//  XMNAlbumModel.h
//  XMNPhotoPickerKitExample
//  专辑相关的model
//  Created by XMFraker on 16/1/28.
//  Copyright © 2016年 XMFraker. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    XMNAlbumTypeCarmeraRoll = 1,
    XMNAlbumTypeAll,
} XMNAlbumType;


@interface XMNAlbumModel : NSObject

#pragma mark - Properties

/** 相册的名称 */
@property (nonatomic, copy, readonly)   NSString *name;

/** 照片的数量 */
@property (nonatomic, assign, readonly) NSUInteger count;

/** PHFetchResult<PHAsset> or ALAssetsGroup<ALAsset> */
@property (nonatomic, strong, readonly) id fetchResult;

#pragma mark - Methods


+ (XMNAlbumModel *)albumWithResult:(id)result name:(NSString *)name;

@end
