//
//  ShowSelectImageViewController.m
//  TestDemo
//
//  Created by DTiOS on 2021/1/25.
//

#import "ShowSelectImageViewController.h"
#import "SelectAssetsViewController.h"

@interface ShowSelectImageViewController ()
@property (strong, nonatomic) NSMutableArray *imgMuAry;
@end

@implementation ShowSelectImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)selectImageBtnClick:(id)sender
{
    SelectAssetsViewController * sVC = [SelectAssetsViewController new];
    sVC.selectCount = 9 - [self.imgMuAry count];
    sVC.selectImagesVideoBlock = ^(NSInteger type, NSMutableArray * _Nonnull imageArray) {
        
        if (type == 0) // 图片
        {
        
        }else // 视频
        {
           
        }
    };
    [self.navigationController pushViewController:sVC animated:YES];
}

- (NSMutableArray *)imgMuAry
{
    if (!_imgMuAry) {
        _imgMuAry = [NSMutableArray array];
    }
    return _imgMuAry;
}

@end
