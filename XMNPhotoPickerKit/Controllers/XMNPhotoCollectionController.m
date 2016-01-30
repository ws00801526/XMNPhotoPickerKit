//
//  XMNPhotoCollectionController.m
//  XMNPhotoPickerKitExample
//
//  Created by XMFraker on 16/1/29.
//  Copyright © 2016年 XMFraker. All rights reserved.
//

#import "XMNPhotoCollectionController.h"
#import "XMNPhotoPickerController.h"
#import "XMNPhotoPreviewController.h"
#import "XMNVideoPreviewController.h"

#import "XMNAssetModel.h"
#import "XMNPhotoManager.h"

#import "XMNAssetCell.h"
#import "XMNBottomBar.h"

@interface XMNPhotoCollectionController ()

@property (nonatomic, assign) BOOL scrollBottom;

@property (nonatomic, weak)   XMNBottomBar *bottomBar;

@property (nonatomic, copy)   NSArray *assets;
@property (nonatomic, strong) NSMutableArray *selectedAssets;

@end

@implementation XMNPhotoCollectionController

static NSString * const kXMNAssetCellIdentifier = @"XMNAssetCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    self.navigationItem.title = self.album.name;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(_handleCancelAction)];
    

    self.selectedAssets = [NSMutableArray array];
    self.scrollBottom = YES;
    
    [self _setupCollectionView];
    __weak typeof(*&self) wSelf = self;
    [[XMNPhotoManager sharedManager] getAssetsFromResult:self.album.fetchResult pickingVideoEnable:[(XMNPhotoPickerController *)self.navigationController pickingVideoEnable] completionBlock:^(NSArray<XMNAssetModel *> *assets) {
        __weak typeof(*&self) self = wSelf;
        self.assets = [NSArray arrayWithArray:assets];
        [self.collectionView reloadData];
        if (self.scrollBottom) {
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.assets.count - 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionBottom animated:NO];
            self.scrollBottom = !self.scrollBottom;
        }
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    NSLog(@"photo collection dealloc ");
}

#pragma mark - Methods

- (void)_setupCollectionView {
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.alwaysBounceHorizontal = NO;
    self.collectionView.contentInset = UIEdgeInsetsMake(4, 4, 54, 4);
    self.collectionView.scrollIndicatorInsets = self.collectionView.contentInset;
    self.collectionView.contentSize = CGSizeMake(self.view.frame.size.width, ((self.assets.count + 3) / 4) * self.view.frame.size.width);
    [self.collectionView registerNib:[UINib nibWithNibName:kXMNAssetCellIdentifier bundle:nil] forCellWithReuseIdentifier:kXMNAssetCellIdentifier];
    
    XMNBottomBar *bottomBar = [[XMNBottomBar alloc] initWithBarType:XMNCollectionBottomBar];
    bottomBar.frame = CGRectMake(0, self.view.frame.size.height - 50, self.view.frame.size.width, 50);
    __weak typeof(*&self) wSelf = self;
    [bottomBar setConfirmBlock:^{
        __weak typeof(*&self) self = wSelf;
        [(XMNPhotoPickerController *)self.navigationController didFinishPickingPhoto:self.selectedAssets];
    }];
    [self.view addSubview:self.bottomBar = bottomBar];
}

- (void)_handleCancelAction {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    XMNPhotoPickerController *photoPickerVC = (XMNPhotoPickerController *)self.navigationController;
    [photoPickerVC didCancelPickingPhoto];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.assets.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    XMNAssetCell *assetCell = [collectionView dequeueReusableCellWithReuseIdentifier:kXMNAssetCellIdentifier forIndexPath:indexPath];
    [assetCell configCellWithItem:self.assets[indexPath.row]];
    __weak typeof(*&self) wSelf = self;
    [assetCell setWillChangeSelectedStateBlock:^BOOL(UIButton *button) {
        if (!button.selected) {
            __weak typeof(*&self) self = wSelf;
            XMNPhotoPickerController *photoPickerC = (XMNPhotoPickerController *)self.navigationController;
            if (self.selectedAssets.count < photoPickerC.maxCount) {
                return YES;
            }else{
                [photoPickerC showAlertWithTitle:[NSString stringWithFormat:@"最多只能选择%ld张照片",photoPickerC.maxCount]];
            }
            return self.selectedAssets.count < photoPickerC.maxCount;
        }else {
            return NO;
        }
    }];
    
    [assetCell setDidChangeSelectedStateBlock:^(BOOL selected, XMNAssetModel *asset) {
        __weak typeof(*&self) self = wSelf;
        if (selected) {
            [self.selectedAssets containsObject:asset] ? nil : [self.selectedAssets addObject:asset];
        }else {
            [self.selectedAssets containsObject:asset] ? [self.selectedAssets removeObject:asset] : nil;
        }
        asset.selected = YES;
        [self.bottomBar updateBottomBarWithAssets:self.selectedAssets];
    }];
    
    return assetCell;
}

#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    XMNAssetModel *assetModel = self.assets[indexPath.row];
    if (assetModel.type == XMNAssetTypeVideo) {
        XMNVideoPreviewController *videoPreviewC = [[XMNVideoPreviewController alloc] init];
        videoPreviewC.asset = assetModel;
        [self.navigationController pushViewController:videoPreviewC animated:YES];
    }else {
        XMNPhotoPreviewController *previewC = [[XMNPhotoPreviewController alloc] initWithCollectionViewLayout:[XMNPhotoPreviewController photoPreviewViewLayoutWithSize:[UIScreen mainScreen].bounds.size]];
        previewC.assets = self.assets;
        previewC.selectedAssets = [NSMutableArray arrayWithArray:self.selectedAssets];
        previewC.currentIndex = indexPath.row;
        __weak typeof(*&self) wSelf = self;
        [previewC setDidPreviewFinishBlock:^(NSArray<XMNAssetModel *> *selectedAssets) {
            __weak typeof(*&self) self = wSelf;
            self.selectedAssets = [NSMutableArray arrayWithArray:selectedAssets];
            [self.bottomBar updateBottomBarWithAssets:self.selectedAssets];
            [self.collectionView reloadData];
        }];
        [self.navigationController pushViewController:previewC animated:YES];
    }
    
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
}


#pragma mark - Getters

+ (UICollectionViewLayout *)photoCollectionViewLayoutWithWidth:(CGFloat)width {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat margin = 4;
    CGFloat itemWH = (width - 2 * margin - 4) / 4 - margin;
    layout.itemSize = CGSizeMake(itemWH, itemWH);
    layout.minimumInteritemSpacing = margin;
    layout.minimumLineSpacing = margin;
    return layout;
}

@end