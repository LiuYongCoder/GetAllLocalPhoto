//
//  SelectAssetsViewController.h
//  StandardApplication
//
//  Created by Cathy on 2019/11/20.
//  Copyright © 2019 DTiOS. All rights reserved.
//

#import "GKNavigationBarViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, SelectImageVideoType) {
    SelectImageType= 0, //选择图片
    SelectVideoType     //选择视频
};

typedef void (^SelectImagesVideoBlock) (NSInteger type,NSMutableArray *imageArray);

@interface SelectAssetsViewController : GKNavigationBarViewController
@property (nonatomic, copy)SelectImagesVideoBlock selectImagesVideoBlock;

@property (nonatomic, assign) NSInteger selectCount;
@end

NS_ASSUME_NONNULL_END
