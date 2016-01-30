//
//  XMNVideoPreviewController.m
//  XMNPhotoPickerKitExample
//
//  Created by XMFraker on 16/1/29.
//  Copyright © 2016年 XMFraker. All rights reserved.
//

#import "XMNVideoPreviewController.h"
#import "XMNPhotoPickerController.h"

#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>

#import "XMNBottomBar.h"

#import "XMNAssetModel.h"
#import "XMNPhotoManager.h"

@interface XMNVideoPreviewController ()

@property (nonatomic, strong) AVPlayer *player;

@property (nonatomic, weak)   UIButton *playButton;
@property (nonatomic, weak)   XMNBottomBar *bottomBar;

@property (nonatomic, strong) UIImage *coverImage;


@end

@implementation XMNVideoPreviewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    self.navigationItem.title = @"视频预览";
    [self _setupPlayer];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)dealloc {
    NSLog(@"video preview dealloc");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Methods

- (void)_setupPlayer {
    
    __weak typeof(*&self) wSelf = self;
    
    [[XMNPhotoManager sharedManager] getPreviewImageWithAsset:self.asset.asset completionBlock:^(UIImage *image) {
        __weak typeof(*&self) self = wSelf;
        self.coverImage = image;
    }];
    
    [[XMNPhotoManager sharedManager] getVideoInfoWithAsset:self.asset.asset completionBlock:^(AVPlayerItem *playerItem, NSDictionary *playetItemInfo) {
        dispatch_async(dispatch_get_main_queue(), ^{
            __weak typeof(*&self) self = wSelf;
            self.player = [AVPlayer playerWithPlayerItem:playerItem];
            AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
            playerLayer.frame = self.view.bounds;
            [self.view.layer addSublayer:playerLayer];
            [self _setupPlayButton];
            [self _setupBottomBar];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_pausePlayer) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
        });
    }];
    
}

- (void)_setupPlayButton {
    UIButton *playButton  = [UIButton buttonWithType:UIButtonTypeCustom];
    playButton.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64 - 44);
    [playButton setImage:[UIImage imageNamed:@"video_preview_play_normal"] forState:UIControlStateNormal];
    [playButton setImage:[UIImage imageNamed:@"video_preview_play_highlight"] forState:UIControlStateHighlighted];
    [playButton addTarget:self action:@selector(_handlePlayAciton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.playButton = playButton];
}

- (void)_setupBottomBar {
    XMNBottomBar *bottomBar = [[XMNBottomBar alloc] initWithBarType:XMNPreviewBottomBar];
    [bottomBar setFrame:CGRectMake(0, self.view.frame.size.height - 50, self.view.frame.size.width, 50)];
    [self.view addSubview:self.bottomBar = bottomBar];
}

- (void)_handlePlayAciton {
    CMTime currentTime = self.player.currentItem.currentTime;
    CMTime durationTime = self.player.currentItem.duration;
    if (self.player.rate == 0.0f) {
        [self.playButton setImage:nil forState:UIControlStateNormal];
        if (currentTime.value == durationTime.value) [self.player.currentItem seekToTime:CMTimeMake(0, 1)];
        [self.player play];
        [self.navigationController setNavigationBarHidden:YES animated:YES];
        [UIView animateWithDuration:.2 animations:^{
            [self.bottomBar setFrame:CGRectMake(0, self.view.frame.size.height, self.bottomBar.frame.size.width, self.bottomBar.frame.size.height)];
        }];
    } else {
        [self _pausePlayer];
    }
}

- (void)_pausePlayer {
    [self.playButton setImage:[UIImage imageNamed:@"video_preview_play_normal"] forState:UIControlStateNormal];
    [self.player pause];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [UIView animateWithDuration:.2 animations:^{
        [self.bottomBar setFrame:CGRectMake(0, self.view.frame.size.height-self.bottomBar.frame.size.height, self.bottomBar.frame.size.width, self.bottomBar.frame.size.height)];
    }];
}
@end
