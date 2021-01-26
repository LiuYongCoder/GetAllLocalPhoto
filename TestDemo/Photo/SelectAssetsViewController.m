//
//  SelectAssetsViewController.m
//  StandardApplication
//
//  Created by Cathy on 2019/11/20.
//  Copyright © 2019 DTiOS. All rights reserved.
//

#import "SelectAssetsViewController.h"
#import "MacroDefine.h"
#import "PHAssetGetThumbnailImages.h"
#import "AssetSelectCollectionViewCell.h"
#import "SelectImageStatusObj.h"
#import "PopSelectView.h"

@interface SelectAssetsViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,AssetSelectCollectionViewCellDelegate,PopSelectViewDelegate>
@property (strong, nonatomic) NSMutableArray *assetArr;
@property (strong, nonatomic) NSMutableArray *modelArr;
@property (strong, nonatomic) NSMutableArray *selectArr;
@property (strong, nonatomic) ScottAlertViewController *alertController;
@property (weak, nonatomic) IBOutlet UIImageView *showImageView;
@property (weak, nonatomic) IBOutlet UICollectionView *assetCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *assetLayout;
@end

@implementation SelectAssetsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.gk_navTitle = @"编辑发布";
    
    self.gk_statusBarStyle = UIStatusBarStyleDefault;

    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    [nextButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [nextButton addTarget:self action:@selector(nextBtn) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:nextButton];
    self.gk_navItemRightSpace = 15;
    self.gk_navRightBarButtonItem = item;
    
    [_assetCollectionView registerNib:[UINib nibWithNibName:@"AssetSelectCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"AssetSelectCollectionViewCell"];
    _assetCollectionView.delegate = self;
    _assetCollectionView.dataSource = self;
    _assetLayout.minimumInteritemSpacing = 1;
    _assetLayout.minimumLineSpacing = 1;
    CGFloat sizeW = (SCREEN_WIDTH - 3) / 4;
    _assetLayout.itemSize = CGSizeMake(sizeW, sizeW);
    
    [MBProgressHUD showStatus:nil toView:self.view];
    __weak typeof(self) weakSelf = self;
    [[PHAssetGetThumbnailImages shareManager] getThumbnailImages:^(NSMutableArray * _Nonnull imageArray, NSMutableArray * _Nonnull modelArray) {
        [weakSelf.assetArr addObjectsFromArray:imageArray];
        [weakSelf.modelArr addObjectsFromArray:modelArray];

        dispatch_async(dispatch_get_main_queue(), ^{
            if (weakSelf.assetArr.count > 0) {
                [weakSelf showFirstImage:weakSelf.assetArr[0]];
            }
            [MBProgressHUD dismissWithView:weakSelf.view];
            [weakSelf.assetCollectionView reloadData];
        });
    }];
}

- (void)showFirstImage:(PHAsset *)asset
{
    KWeakSelf
    NSInteger fileType = asset.mediaType;
    if (fileType == PHAssetMediaTypeVideo) {
        [[PHAssetGetThumbnailImages shareManager] getVideoFromPHAsset:asset Complete:^(UIImage * _Nonnull image) {
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.showImageView.image = image;
            });
        }];
    } else if (fileType == PHAssetMediaTypeImage) {
        [[PHAssetGetThumbnailImages shareManager] getImageFromPHAsset:asset original:YES Complete:^(UIImage * _Nonnull image) {
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.showImageView.image = image;
            });
        }];
    }
}

- (void)backAction
{
//    PopSelectView *popSelectView = [PopSelectView createViewFromNib];
//    popSelectView.delegate = self;
//    popSelectView.popTitleLab.text = @"是否放弃选择？";
//    popSelectView.popContentLab.text = @"";
//    _alertController = [ScottAlertViewController alertControllerWithAlertView:popSelectView preferredStyle:ScottAlertControllerStyleAlert transitionAnimationStyle:ScottAlertTransitionStyleFade];
//    _alertController.tapBackgroundDismissEnable = NO;
//    [self presentViewController:_alertController animated:YES completion:nil];
//    [self.navigationController popViewControllerAnimated:YES];
}

- (void)popCancelBtnEvent
{
    [_alertController dismissViewControllerAnimated:YES];
}

- (void)popCommitBtnEvent
{
    [_alertController dismissViewControllerAnimated:YES];
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UICollectionViewDataSource & UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _assetArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    AssetSelectCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AssetSelectCollectionViewCell" forIndexPath:indexPath];
    cell.delegate = self;
    SelectImageStatusObj *model = _modelArr[indexPath.row];
    cell.model = model;
    [cell.assetSelectBtn setImage:model.isSelectImage ? [UIImage imageNamed:@"ec_photoselected"] : [UIImage imageNamed:@"ec_photonomal"] forState: UIControlStateNormal];
    
    PHAsset *asset = _assetArr[indexPath.row];
    NSInteger fileType = asset.mediaType;
    if (fileType == PHAssetMediaTypeVideo) {
        [[PHAssetGetThumbnailImages shareManager] getVideoFromPHAsset:asset Complete:^(UIImage * _Nonnull image) {
            dispatch_async(dispatch_get_main_queue(), ^{
                cell.assetImageView.image = image;
            });
        }];
        [[PHAssetGetThumbnailImages shareManager] getUploadVideoAssetData:asset Complete:^(NSData * _Nonnull uploadData, NSString * _Nonnull videoTime, NSURL * _Nonnull uploadUrl) {
            dispatch_async(dispatch_get_main_queue(), ^{
                cell.videoTimeLab.text = videoTime;
            });
        }];
        cell.videoTimeLab.hidden = NO;
        cell.assetSelectBtn.hidden = YES;
    } else if (fileType == PHAssetMediaTypeImage) {
        [[PHAssetGetThumbnailImages shareManager] getImageFromPHAsset:asset original:NO Complete:^(UIImage * _Nonnull image) {
            dispatch_async(dispatch_get_main_queue(), ^{
                cell.assetImageView.image = image;
            });
        }];
        cell.videoTimeLab.hidden = YES;
        cell.assetSelectBtn.hidden = NO;
    }

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    KWeakSelf
    PHAsset *asset = _assetArr[indexPath.row];
    NSInteger fileType = asset.mediaType;
    if (fileType == PHAssetMediaTypeImage) {
        [[PHAssetGetThumbnailImages shareManager] getImageFromPHAsset:asset original:YES Complete:^(UIImage * _Nonnull image) {
            dispatch_async(dispatch_get_main_queue(), ^{
               weakSelf.showImageView.image = image;
            });
        }];
    } else if (fileType == PHAssetMediaTypeVideo) {
        if (_selectArr.count > 0 || _selectCount != 9) {
            [MBProgressHUD showMessag:@"只能选择图片！" toView:self.view];
            return;
        }
        [[PHAssetGetThumbnailImages shareManager] getUploadVideoAssetData:asset Complete:^(NSData * _Nonnull uploadData, NSString * _Nonnull videoTime, NSURL * _Nonnull uploadUrl) {
            [weakSelf.selectArr addObject:uploadUrl];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (weakSelf.selectImagesVideoBlock) {
                    weakSelf.selectImagesVideoBlock(SelectVideoType, weakSelf.selectArr);
                }
                [weakSelf.navigationController popViewControllerAnimated:YES];
            });
        }];
    }
}

//  AssetSelectCollectionViewCellDelegate
- (void)selectImageBtnClickEvent:(AssetSelectCollectionViewCell *)sender isSelect:(nonnull SelectImageStatusObj *)model
{
    if (_selectArr.count >= _selectCount && !model.isSelectImage) {
        [MBProgressHUD showMessag:[NSString stringWithFormat:@"最多选择%ld张图片！",(long)_selectCount] toView:self.view];
        return;
    }
    AssetSelectCollectionViewCell *cell = (AssetSelectCollectionViewCell *)sender;
    NSIndexPath *indexPath = [self.assetCollectionView indexPathForCell:cell];
    model.isSelectImage = !model.isSelectImage;
    [cell.assetSelectBtn setImage:model.isSelectImage ? [UIImage imageNamed:@"ec_photoselected"] : [UIImage imageNamed:@"ec_photonomal"] forState: UIControlStateNormal];
    
    KWeakSelf
    PHAsset *asset = _assetArr[indexPath.row];
    [[PHAssetGetThumbnailImages shareManager] getImageFromPHAsset:asset original:YES Complete:^(UIImage * _Nonnull image) {
        dispatch_async(dispatch_get_main_queue(), ^{
           model.isSelectImage ? [weakSelf.selectArr addObject:image] : [weakSelf.selectArr removeObject:image];
        });
    }];
}

// 下一步
- (void)nextBtn
{
    if (_selectArr.count <= 0) {
        return;
    }
    if (self.selectImagesVideoBlock) {
        self.selectImagesVideoBlock(SelectImageType, _selectArr);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSMutableArray *)assetArr
{
    if (!_assetArr) {
        _assetArr = [NSMutableArray array];
    }
    return _assetArr;
}

- (NSMutableArray *)selectArr
{
    if (!_selectArr) {
        _selectArr = [NSMutableArray array];
    }
    return _selectArr;
}

- (NSMutableArray *)modelArr
{
    if (!_modelArr) {
        _modelArr = [NSMutableArray array];
    }
    return _modelArr;
}

@end
