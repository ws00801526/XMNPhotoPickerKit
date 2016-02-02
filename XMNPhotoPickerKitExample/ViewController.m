//
//  ViewController.m
//  XMNPhotoPickerKitExample
//
//  Created by XMFraker on 16/1/28.
//  Copyright © 2016年 XMFraker. All rights reserved.
//

#import "ViewController.h"

#import "XMNPhotoPickerKit.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)_handleButtonAction {
    XMNPhotoPickerController *photoPickerC = [[XMNPhotoPickerController alloc] initWithMaxCount:9 delegate:nil];
    [photoPickerC setDidFinishPickingPhotosBlock:^(NSArray<UIImage *> *images, NSArray<XMNAssetModel *> *assets) {
        
    }];
    
    [photoPickerC setDidFinishPickingVideoBlock:^(UIImage *coverImage, XMNAssetModel * asset) {
        NSLog(@"picker image :%@\n\n asset:%@\n\n",coverImage,asset);
    }];
    
    [photoPickerC setDidCancelPickingBlock:^{
        NSLog(@"photoPickerC did Cancel");
    }];
    
    [self presentViewController:photoPickerC animated:YES completion:nil];
}

- (IBAction)presentPicker:(id)sender {
    
    [[XMNPhotoPicker sharePhotoPicker] setDidFinishPickingPhotosBlock:^(NSArray<UIImage *> *images, NSArray<XMNAssetModel *> *assets) {
        NSLog(@"picker images :%@ \n\n assets:%@",images,assets);
    }];
    
    [[XMNPhotoPicker sharePhotoPicker] setDidFinishPickingVideoBlock:^(UIImage * image, XMNAssetModel *asset) {
        NSLog(@"picker video :%@ \n\n asset :%@",image,asset);
    }];
    
    [[XMNPhotoPicker sharePhotoPicker] showPhotoPickerwithController:self animated:YES];
}

@end
