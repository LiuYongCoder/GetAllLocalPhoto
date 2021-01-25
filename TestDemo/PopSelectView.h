//
//  PopSelectView.h
//  StandardApplication
//
//  Created by DTiOS on 2019/7/19.
//  Copyright © 2019 DTiOS. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol PopSelectViewDelegate <NSObject>

- (void)popCancelBtnEvent;
- (void)popCommitBtnEvent;

@end

@interface PopSelectView : UIView
@property (weak, nonatomic) IBOutlet UILabel *popTitleLab;
@property (weak, nonatomic) IBOutlet UILabel *popContentLab;
@property (weak, nonatomic)id<PopSelectViewDelegate>delegate;
@end

NS_ASSUME_NONNULL_END
