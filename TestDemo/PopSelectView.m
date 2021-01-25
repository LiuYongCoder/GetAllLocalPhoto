//
//  PopSelectView.m
//  StandardApplication
//
//  Created by DTiOS on 2019/7/19.
//  Copyright © 2019 DTiOS. All rights reserved.
//

#import "PopSelectView.h"
#import "MacroDefine.h"

@implementation PopSelectView

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.layer.cornerRadius = 20;
    self.layer.masksToBounds = YES;
}
- (IBAction)cancelBtnClick:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(popCancelBtnEvent)]) {
        [self.delegate popCancelBtnEvent];
    }
}
- (IBAction)commitBtnClick:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(popCommitBtnEvent)]) {
        [self.delegate popCommitBtnEvent];
    }
}

@end
