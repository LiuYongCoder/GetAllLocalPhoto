//
//  AssetSelectCollectionViewCell.h
//  StandardApplication
//
//  Created by Cathy on 2019/11/20.
//  Copyright © 2019 DTiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelectImageStatusObj.h"
NS_ASSUME_NONNULL_BEGIN
@class AssetSelectCollectionViewCell;
@protocol AssetSelectCollectionViewCellDelegate <NSObject>

- (void)selectImageBtnClickEvent:(AssetSelectCollectionViewCell *)sender isSelect:(SelectImageStatusObj *)model;

@end

@interface AssetSelectCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *assetImageView;
@property (weak, nonatomic) IBOutlet UIButton *assetSelectBtn;
@property (weak, nonatomic) IBOutlet UILabel *videoTimeLab;

@property (strong, nonatomic) SelectImageStatusObj *model;
@property (weak, nonatomic) id<AssetSelectCollectionViewCellDelegate>delegate;
@end

NS_ASSUME_NONNULL_END
