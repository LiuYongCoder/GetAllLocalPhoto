//
//  PHAssetGetThumbnailImages.h
//  StandardApplication
//
//  Created by Cathy on 2019/11/19.
//  Copyright © 2019 DTiOS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^GetThumbnailImagesBlock) (NSMutableArray *imageArray,NSMutableArray *modelArray);

@interface PHAssetGetThumbnailImages : NSObject

@property (strong, nonatomic) NSMutableArray *phAssetArr;

@property (strong, nonatomic) NSMutableArray *modelArr;

+ (PHAssetGetThumbnailImages *)shareManager;

- (void)getThumbnailImages:(GetThumbnailImagesBlock)block;

// 获取上传video的data
- (void)getUploadVideoAssetData:(PHAsset *)videoAsset Complete:(void (^)(NSData *uploadData,NSString *videoTime,NSURL *uploadUrl))resultBack;

// 获取上传video的缩率图
- (void)getVideoFromPHAsset:(PHAsset *)videoAsset Complete:(void (^)(UIImage *image))resultBack;

// 获取相册的缩率图或者原型图
- (void)getImageFromPHAsset:(PHAsset *)imageAsset original:(BOOL)original Complete:(void (^)(UIImage *image))resultBack;

@end

NS_ASSUME_NONNULL_END
