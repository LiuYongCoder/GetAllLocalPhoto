//
//  PHAssetGetThumbnailImages.m
//  StandardApplication
//
//  Created by Cathy on 2019/11/19.
//  Copyright © 2019 DTiOS. All rights reserved.
//

#import "PHAssetGetThumbnailImages.h"
#import "SelectImageStatusObj.h"

@implementation PHAssetGetThumbnailImages

static PHAssetGetThumbnailImages *DefaultManager = nil;

+ (PHAssetGetThumbnailImages *)shareManager{
    if (!DefaultManager){
        DefaultManager = [[self allocWithZone:NULL] init];
    }
    return DefaultManager;
}

- (void)getThumbnailImages:(GetThumbnailImagesBlock)block
{
    // 从asset中获得图片
    __weak typeof(self) weakSelf = self;
    
    if (weakSelf.phAssetArr.count > 0) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            for (SelectImageStatusObj *model in weakSelf.modelArr) {
                model.isSelectImage = NO;
            }
            block(weakSelf.phAssetArr,weakSelf.modelArr);
        });
        return;
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 获得所有的自定义相簿
        PHFetchResult<PHAssetCollection *> *assetCollections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
        // 遍历所有的自定义相簿
        for (PHAssetCollection *assetCollection in assetCollections) {
            [self enumerateAssetsInAssetCollection:assetCollection original:NO];
        }
        // 获得相机胶卷
        PHAssetCollection *cameraRoll = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil].lastObject;
         [self enumerateAssetsInAssetCollection:cameraRoll original:NO];
         
        block(weakSelf.phAssetArr,weakSelf.modelArr);
    });
}

// *  遍历相簿中的全部图片
// *  @param assetCollection 相簿
// *  @param original        是否要原图
// */
- (void)enumerateAssetsInAssetCollection:(PHAssetCollection *)assetCollection original:(BOOL)original
{
//    NSLog(@"相簿名:%@", assetCollection.localizedTitle);
    
    // 获得某个相簿中的所有PHAsset对象
    PHFetchResult<PHAsset *> *assets = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
    for (PHAsset *asset in assets) {
        
        // 从asset中获得图片
        __weak typeof(self) weakSelf = self;
        
        // mediaType文件类型
        // PHAssetMediaTypeUnknown = 0, 位置类型
        // PHAssetMediaTypeImage   = 1, 图片
        // PHAssetMediaTypeVideo   = 2, 视频
        // PHAssetMediaTypeAudio   = 3, 音频
//        NSInteger fileType = asset.mediaType;
        
        [weakSelf.phAssetArr addObject:asset];
        
        SelectImageStatusObj *model = [SelectImageStatusObj new];
        [weakSelf.modelArr addObject:model];
        
    }
}

- (void)getUploadVideoAssetData:(PHAsset *)videoAsset Complete:(void (^)(NSData *uploadData,NSString *videoTime,NSURL *uploadUrl))resultBack
{
    PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
    options.version = PHImageRequestOptionsVersionCurrent;
    options.deliveryMode = PHVideoRequestOptionsDeliveryModeAutomatic;
    options.networkAccessAllowed = true;
    [[PHImageManager defaultManager]requestAVAssetForVideo:videoAsset options:options resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
         // 获取信息 asset audioMix info
         // 上传视频时用到data
         AVURLAsset *urlAsset = (AVURLAsset *)asset;
         NSData *videoData = [NSData dataWithContentsOfURL:urlAsset.URL];
               
         CMTime   time = [urlAsset duration];
         int seconds = ceil(time.value/time.timescale);
          //format of minute
         NSString *str_minute = [NSString stringWithFormat:@"%d",seconds/60];
          //format of second
         NSString *str_second = [NSString stringWithFormat:@"%.2d",seconds%60];
          //format of time
         NSString *format_time = [NSString stringWithFormat:@"%@:%@",str_minute,str_second];
        
         resultBack(videoData,format_time,urlAsset.URL);
    }];
}

- (void)getVideoFromPHAsset:(PHAsset *)asset Complete:(void (^)(UIImage *image))resultBack{
    
    PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
    option.resizeMode = PHImageRequestOptionsResizeModeFast;
    
    [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:CGSizeMake(300, 300) contentMode:PHImageContentModeDefault options:option resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        
        resultBack(result);
    }];
}

- (void)getImageFromPHAsset:(PHAsset *)imageAsset original:(BOOL)original Complete:(void (^)(UIImage *image))resultBack{
    
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.resizeMode = PHImageRequestOptionsResizeModeFast;
    // 同步获得图片, 只会返回1张图片
    options.synchronous = YES;
    
    // 是否要原图
    CGSize size = original ? CGSizeMake(imageAsset.pixelWidth, imageAsset.pixelHeight) : CGSizeMake(400, 400);
    
    [[PHImageManager defaultManager] requestImageForAsset:imageAsset targetSize:size contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        
        resultBack(result);
    }];
}


- (NSMutableArray *)phAssetArr
{
    if (!_phAssetArr) {
        _phAssetArr = [NSMutableArray array];
    }
    return _phAssetArr;
}

- (NSMutableArray *)modelArr
{
    if (!_modelArr) {
        _modelArr = [NSMutableArray array];
    }
    return _modelArr;
}

@end
