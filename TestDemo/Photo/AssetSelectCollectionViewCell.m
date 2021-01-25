//
//  AssetSelectCollectionViewCell.m
//  StandardApplication
//
//  Created by Cathy on 2019/11/20.
//  Copyright © 2019 DTiOS. All rights reserved.
//

#import "AssetSelectCollectionViewCell.h"

@implementation AssetSelectCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

- (void)setModel:(SelectImageStatusObj *)model
{
    _model = model;
}

- (IBAction)selectImageBtnClick:(UIButton *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectImageBtnClickEvent:isSelect:)]) {
        [self.delegate selectImageBtnClickEvent:self isSelect:_model];
    }
}

@end
