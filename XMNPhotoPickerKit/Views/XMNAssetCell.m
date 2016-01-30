//
//  XMNAssetCell.m
//  XMNPhotoPickerKitExample
//
//  Created by XMFraker on 16/1/28.
//  Copyright © 2016年 XMFraker. All rights reserved.
//

#import "XMNAssetCell.h"

#import "XMNAssetModel.h"
#import "XMNPhotoManager.h"

#import "UIView+Animations.h"

@interface XMNAssetCell ()
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UIView *videoView;
@property (weak, nonatomic) IBOutlet UILabel *videoTimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *photoStateButton;

@end

@implementation XMNAssetCell
@synthesize asset = _asset;

#pragma mark - Methods

- (void)configCellWithItem:(XMNAssetModel *)item {
    _asset = item;
    switch (item.type) {
        case XMNAssetTypeVideo:
        case XMNAssetTypeAudio:
            self.videoView.hidden = NO;
            self.videoTimeLabel.text = item.timeLength;
            break;
        case XMNAssetTypeLivePhoto:
        case XMNAssetTypePhoto:
            self.videoView.hidden = YES;
            break;
    }
    self.photoStateButton.selected = item.selected;
    
    [[XMNPhotoManager sharedManager] getThumbnailWithAsset:item.asset size:self.bounds.size completionBlock:^(UIImage *image) {
        self.photoImageView.image = image;
    }];
    
}

- (IBAction)_handleButtonAction:(UIButton *)sender {
    BOOL originState = sender.selected;
    self.photoStateButton.selected = self.willChangeSelectedStateBlock ? self.willChangeSelectedStateBlock(sender) : NO;
    if (self.photoStateButton.selected) {
        [UIView animationWithLayer:self.photoStateButton.layer type:XMNAnimationTypeBigger];
    }
    if (originState != self.photoStateButton.selected) {
        self.didChangeSelectedStateBlock ? self.didChangeSelectedStateBlock(self.photoStateButton.selected, self.asset) : nil;
    }
}



@end
