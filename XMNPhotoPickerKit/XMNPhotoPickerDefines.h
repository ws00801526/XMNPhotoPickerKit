//
//  XMNPhotoPickerDefines.h
//  XMNPhotoPickerKitExample
//
//  Created by XMFraker on 16/1/28.
//  Copyright © 2016年 XMFraker. All rights reserved.
//

#ifndef XMNPhotoPickerDefines_h
#define XMNPhotoPickerDefines_h

#import <UIKit/UIDevice.h>

#define kXMNBarBackgroundColor  ([UIColor colorWithRed:(34/255.0) green:(34/255.0) blue:(34/255.0) alpha:1.0])
#define kXMNButtonTitleColorNormal ([UIColor colorWithRed:(83/255.0) green:(179/255.0) blue:(17/255.0) alpha:1.0])
#define kXMNButtonTitleColorDisable  ([UIColor colorWithRed:(83/255.0) green:(179/255.0) blue:(17/255.0) alpha:0.5])
#define iOS7Later ([UIDevice currentDevice].systemVersion.floatValue >= 7.0f)
#define iOS8Later ([UIDevice currentDevice].systemVersion.floatValue >= 8.0f)
#define iOS9Later ([UIDevice currentDevice].systemVersion.floatValue >= 9.0f)

#define kXMNThumbnailSize CGSizeMake(80, 80)

#endif /* XMNPhotoPickerDefines_h */
