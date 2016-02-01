//
//  XMNPhotoPicker.m
//  XMNPhotoPickerKitExample
//
//  Created by XMFraker on 16/2/1.
//  Copyright © 2016年 XMFraker. All rights reserved.
//

#import "XMNPhotoPicker.h"
#import "XMNAssetCell.h"

#import "XMNPhotoPickerController.h"
#import "XMNPhotoPreviewController.h"
#import "XMNVideoPreviewController.h"

#import "XMNPhotoManager.h"
#import "XMNPhotoPickerDefines.h"

#import "UIView+Animations.h"

@interface XMNPhotoPicker   () <UICollectionViewDelegate,UICollectionViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,PHPhotoLibraryChangeObserver>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIButton *cameraButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cameraButtonHConstarint;
@property (weak, nonatomic) IBOutlet UIView *cameraLineView;
@property (weak, nonatomic) IBOutlet UIButton *photoLibraryButton;

@property (weak, nonatomic) IBOutlet UIView *contentView;


@property (nonatomic, strong) NSArray <XMNAssetModel *>* assets;
@property (nonatomic, strong) NSMutableArray <XMNAssetModel *> *selectedAssets;

@property (nonatomic, assign, readonly) CGFloat contentViewHeight;

@end

@implementation XMNPhotoPicker

+ (instancetype)sharePhotoPicker {
    static id photoPicker;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        photoPicker = [[[self class] alloc] initWithMaxCount:9];
    });
    return photoPicker;
}

- (instancetype)initWithMaxCount:(NSUInteger)maxCount {
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"XMNPhotoPicker" owner:nil options:nil];
    if ((self = (XMNPhotoPicker *)[array firstObject])) {
        self.frame = [UIScreen mainScreen].bounds;
        [self _setup];
        self.maxCount = maxCount ? : self.maxCount;
    }
    return self;
}

- (void)dealloc {
    NSLog(@"XMNPhotoPicker dealloc");
}

#pragma mark - Methods

- (void)showAnimated:(BOOL)animated {
    [self.parentController.view addSubview:self];
    if (animated) {
        CGPoint fromPoint = CGPointMake(self.frame.size.width/2, self.contentViewHeight/2 + self.frame.size.height);
        CGPoint toPoint   = CGPointMake(self.frame.size.width/2, self.frame.size.height - self.contentViewHeight/2);
        CABasicAnimation *positionAnim = [UIView animationWithFromValue:[NSValue valueWithCGPoint:fromPoint] toValue:[NSValue valueWithCGPoint:toPoint] duration:.2f forKeypath:@"position"];
        [self.contentView.layer addAnimation:positionAnim forKey:nil];
    }
}

- (void)hideAnimated:(BOOL)animated {
    if (animated) {
        CGPoint fromPoint   = CGPointMake(self.frame.size.width/2, self.frame.size.height - self.contentViewHeight/2);
        CGPoint toPoint = CGPointMake(self.frame.size.width/2, self.contentViewHeight/2 + self.frame.size.height);
        CABasicAnimation *positionAnim = [UIView animationWithFromValue:[NSValue valueWithCGPoint:fromPoint] toValue:[NSValue valueWithCGPoint:toPoint] duration:.2f forKeypath:@"position"];
        positionAnim.delegate = self;
        [self.contentView.layer addAnimation:positionAnim forKey:nil];
    }else {
        [self removeFromSuperview];
    }
}

- (void)showPhotoPickerwithController:(UIViewController *)controller animated:(BOOL)animated {
    self.hidden = NO;
    self.parentController = controller;
    [self _loadAssets];
    [self showAnimated:animated];
}

- (void)_setup {
    
    self.maxPreviewCount = 20;
    self.maxCount = MIN(self.maxPreviewCount, NSUIntegerMax);
    
    UITapGestureRecognizer *hideTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_handleButtonAction:)];
    [self addGestureRecognizer:hideTap];
    
    [[PHPhotoLibrary sharedPhotoLibrary] registerChangeObserver:self];
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        self.cameraButtonHConstarint.constant = 40;
        self.cameraButton.hidden = NO;
        self.cameraLineView.hidden = NO;
    }else {
        self.cameraButton.hidden = YES;
        self.cameraLineView.hidden = YES;
        self.cameraButtonHConstarint.constant = 0;
    }
        
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumInteritemSpacing = kXMNMargin;
    layout.sectionInset = UIEdgeInsetsMake(0, 5, 0, 5);

    [self.collectionView registerNib:[UINib nibWithNibName:@"XMNAssetCell" bundle:nil] forCellWithReuseIdentifier:@"XMNAssetCell"];
    self.collectionView.collectionViewLayout = layout;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    self.selectedAssets = [NSMutableArray array];
    
}

- (void)_loadAssets {
    
    __weak typeof(*&self) wSelf = self;
    self.loadingView.hidden = NO;
    [self.selectedAssets removeAllObjects];
    [self.collectionView setContentOffset:CGPointZero];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[XMNPhotoManager sharedManager] getAlbumsPickingVideoEnable:YES completionBlock:^(NSArray<XMNAlbumModel *> *albums) {
            if (albums && [albums firstObject]) {
                [[XMNPhotoManager sharedManager] getAssetsFromResult:[[albums firstObject] fetchResult] pickingVideoEnable:YES completionBlock:^(NSArray<XMNAssetModel *> *assets) {
                    __weak typeof(*&self) self = wSelf;
                    NSMutableArray *tempAssets = [NSMutableArray array];
                    [assets enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(XMNAssetModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        __weak typeof(*&self) self = wSelf;
                        [tempAssets addObject:obj];
                        *stop = ( tempAssets.count > self.maxPreviewCount);
                    }];
                    self.assets = [NSMutableArray arrayWithArray:tempAssets];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        __weak typeof(*&self) self = wSelf;
                        self.loadingView.hidden = YES;
                        [self.collectionView reloadData];
                    });
                }];
            }
        }];
    });
    
}

- (IBAction)_handleButtonAction:(UIButton *)sender {
    if ([sender isKindOfClass:[UITapGestureRecognizer class]]) {
        UITapGestureRecognizer *tap = (UITapGestureRecognizer *)sender;
        if (!CGRectContainsPoint(self.contentView.frame, [tap locationInView:self])) {
            [self hideAnimated:YES];
        }
        return;
    }
    switch (sender.tag) {
        case kXMNCancel:
            [self hideAnimated:YES];
            break;
        case kXMNConfirm:
        {
//            NSMutableArray *images = [NSMutableArray array];
//            [self.selectedAssets enumerateObjectsUsingBlock:^(XMNAssetModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                [images addObject:obj.previewImage];
//            }];
//            self.didFinishPickingPhotosBlock ? self.didFinishPickingPhotosBlock(images,self.selectedAssets) : nil;
//            [self hideAnimated:YES];
        }
            
            break;
        case kXMNCamera:
        {
            [self _showImageCameraController];
        }
            break;
        case kXMNPhotoLibrary:
        {
            [self _showPhotoPickerController];
        }
            break;
        default:
            break;
    }
}

- (void)_updateCancelButton {
    if (self.selectedAssets.count == 0) {
        self.photoLibraryButton.tag = kXMNPhotoLibrary;
        [self.photoLibraryButton setTitle:[NSString stringWithFormat:@"相册"] forState:UIControlStateNormal];
        [self.photoLibraryButton setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
    }else {
        self.photoLibraryButton.tag = kXMNConfirm;
        [self.photoLibraryButton setTitle:[NSString stringWithFormat:@"确定(%d)",(int)self.selectedAssets.count] forState:UIControlStateNormal];
        [self.photoLibraryButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    }
}

- (void)_showPhotoPickerController {
    XMNPhotoPickerController *photoPickerController = [[XMNPhotoPickerController alloc] initWithMaxCount:self.maxCount delegate:nil];
    __weak typeof(*&self) wSelf = self;
    [photoPickerController setDidFinishPickingPhotosBlock:^(NSArray<UIImage *> *images, NSArray<XMNAssetModel *> *assets) {
        __weak typeof(*&self) self = wSelf;
        self.didFinishPickingPhotosBlock ?self.didFinishPickingPhotosBlock(images,assets) : nil;
        [self.parentController dismissViewControllerAnimated:YES completion:nil];
        [self hideAnimated:YES];
    }];
    [photoPickerController setDidFinishPickingVideoBlock:^(UIImage *coverImage, id asset) {
        __weak typeof(*&self) self = wSelf;
        self.didFinishPickingVideoBlock ? self.didFinishPickingVideoBlock(coverImage,asset) : nil;
        [self.parentController dismissViewControllerAnimated:YES completion:nil];
        [self hideAnimated:YES];
    }];
    [self.parentController presentViewController:photoPickerController animated:YES completion:nil];
}

- (void)_showImageCameraController {
    UIImagePickerController *imagePickerC = [[UIImagePickerController alloc] init];
    imagePickerC.delegate = self;
    imagePickerC.allowsEditing = NO;
    imagePickerC.videoQuality = UIImagePickerControllerQualityTypeLow;
    imagePickerC.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self.parentController presentViewController:imagePickerC animated:YES completion:nil];
}

#pragma mark - UICollectionViewDelegate & UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.assets.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    XMNAssetCell *assetCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XMNAssetCell" forIndexPath:indexPath];
    assetCell.backgroundColor = [UIColor lightGrayColor];
    [assetCell configPreviewCellWithItem:self.assets[indexPath.row]];
    
    __weak typeof(*&self) wSelf = self;
    // 设置assetCell willChangeBlock
    [assetCell setWillChangeSelectedStateBlock:^BOOL(UIButton *button) {
        if (!button.selected) {
            __weak typeof(*&self) self = wSelf;
//            if (<#condition#>) {
//                <#statements#>
//            }else{
//
//            }
            return self.selectedAssets.count < self.maxCount;
        }else {
            return NO;
        }
    }];
    
    // 设置assetCell didChangeBlock
    [assetCell setDidChangeSelectedStateBlock:^(BOOL selected, XMNAssetModel *asset) {
        __weak typeof(*&self) self = wSelf;
        if (selected) {
            [self.selectedAssets containsObject:asset] ? nil : [self.selectedAssets addObject:asset];
            asset.selected = YES;
        }else {
            [self.selectedAssets containsObject:asset] ? [self.selectedAssets removeObject:asset] : nil;
            asset.selected = NO;
        }
        [self _updateCancelButton];
    }];
    
    [assetCell setDidSendAsset:^(XMNAssetModel *asset) {
        if (asset.type == XMNAssetTypePhoto) {
            self.didFinishPickingPhotosBlock ? self.didFinishPickingPhotosBlock(@[asset.previewImage],@[asset]) : nil;
        }else {
            self.didFinishPickingVideoBlock ? self.didFinishPickingVideoBlock(asset.previewImage , asset) : nil;
        }
        [self hideAnimated:YES];
    }];
    
    return assetCell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    XMNAssetModel *asset = self.assets[indexPath.row];
    CGSize size = asset.previewImage.size;
    CGFloat scale = (size.width - 10)/size.height;
    return CGSizeMake(scale * (self.collectionView.frame.size.height),self.collectionView.frame.size.height);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    XMNAssetModel *assetModel = self.assets[indexPath.row];
    if (assetModel.type == XMNAssetTypeVideo) {
        XMNVideoPreviewController *videoPreviewC = [[XMNVideoPreviewController alloc] init];
        videoPreviewC.selectedVideoEnable = self.selectedAssets.count == 0;
        videoPreviewC.asset = assetModel;
//        [self.navigationController pushViewController:videoPreviewC animated:YES];
    }else {
        XMNPhotoPreviewController *previewC = [[XMNPhotoPreviewController alloc] initWithCollectionViewLayout:[XMNPhotoPreviewController photoPreviewViewLayoutWithSize:[UIScreen mainScreen].bounds.size]];
        previewC.assets = self.assets;
        previewC.selectedAssets = [NSMutableArray arrayWithArray:self.selectedAssets];
        previewC.currentIndex = indexPath.row;
        __weak typeof(*&self) wSelf = self;
        [previewC setDidPreviewFinishBlock:^(NSArray<XMNAssetModel *> *selectedAssets) {
            __weak typeof(*&self) self = wSelf;
            self.selectedAssets = [NSMutableArray arrayWithArray:selectedAssets];
//            [self.bottomBar updateBottomBarWithAssets:self.selectedAssets];
            [self.collectionView reloadData];
        }];
//        [self.navigationController pushViewController:previewC animated:YES];
    }
    
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
}

#pragma mark - CAAnimationDelegate

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    self.hidden = YES;
    [self removeFromSuperview];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self.parentController dismissViewControllerAnimated:YES completion:nil];
    [self hideAnimated:YES];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {

    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    self.didFinishPickingPhotosBlock ? self.didFinishPickingPhotosBlock(@[image], nil) : nil;
    [self.parentController dismissViewControllerAnimated:YES completion:nil];
    [self hideAnimated:YES];
    
}

#pragma mark - PHPhotoLibraryChangeObserver


- (void)photoLibraryDidChange:(PHChange *)changeInstance {
    [self _loadAssets];
}

#pragma mark - Getters

- (CGFloat)contentViewHeight {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        return 41 * 3 + 160 + 8;
    }else {
        return 41 * 2  + 160 + 8;
    }
}

@end
