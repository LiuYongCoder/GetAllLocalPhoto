//
//  MBProgressHUD+Add.m
//  视频客户端
//
//  Created by mj on 13-4-18.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "MBProgressHUD+Add.h"
#import "UIImage+GIF.h"
#import "MacroDefine.h"
#import <SDWebImage/SDWebImage.h>
@implementation MBProgressHUD (Add)

#pragma mark 显示信息
+ (void)show:(NSString *)text icon:(NSString *)icon view:(UIView *)view
{
    if (IsNilOrNull(text)) {
        return;
    }
    if (view == nil) view = [UIApplication sharedApplication].keyWindow;
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    // 设置图片
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@", icon]]];
    // 再设置模式
    hud.mode = MBProgressHUDModeCustomView;
//    hud.bezelView.color = [UIColor blackColor];
    //  设置文案
    hud.detailsLabel.text = text;
//    hud.detailsLabel.textColor = [UIColor whiteColor];
//    hud.detailsLabel.font = [UIFont systemFontOfSize:13.0f];
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    
    // 2秒之后再消失
    [hud hideAnimated:YES afterDelay:2];
}

#pragma mark 显示错误信息
+ (void)showError:(NSString *)error toView:(UIView *)view{
    [self show:error icon:@"error.png" view:view];
}

+ (void)showSuccess:(NSString *)success toView:(UIView *)view
{
    [self show:success icon:@"success.png" view:view];
}

+ (instancetype)showStatus:(NSString *)status toView:(UIView *)view {
    if (view == nil) view = [UIApplication sharedApplication].keyWindow;
    MBProgressHUD *hud = [[self alloc] initWithView:view];
//    hud.removeFromSuperViewOnHide = NO;
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.bezelView.color = [UIColor clearColor];
    hud.backgroundColor = [UIColor clearColor];
    hud.backgroundView.color = [UIColor clearColor];
    hud.detailsLabel.text = status;
    [view addSubview:hud];
    [hud showAnimated:YES];
    return hud;
}

+ (BOOL)dismissHUDForView:(UIView *)view {
    MBProgressHUD *hud = [self HUDForView:view];
    if (hud != nil) {
        hud.removeFromSuperViewOnHide = YES;
        [hud hideAnimated:YES];
        return YES;
    }
    return NO;
}
+ (BOOL)dismissWithView:(UIView *)view{
    if (view == nil) view = [UIApplication sharedApplication].keyWindow;
    MBProgressHUD *hud = [self HUDForView:view];
    if (hud != nil) {
        hud.removeFromSuperViewOnHide = YES;
        [hud hideAnimated:YES];
//        [hud hideAnimated:YES afterDelay:0.3];
        return YES;
    }
    return NO;
}
+ (BOOL)dismissHUDForView:(UIView *)view withError:(NSString *)error {
    MBProgressHUD *hud = [self HUDForView:view];
    if (hud != nil) {
        hud.detailsLabel.text = error;
        hud.detailsLabel.font = [UIFont systemFontOfSize:13.0f];
        // 设置图片
        hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"error.png"]];
        // 再设置模式
        hud.mode = MBProgressHUDModeCustomView;
        
        // 隐藏时候从父控件中移除
        hud.removeFromSuperViewOnHide = YES;
        
        // 1.0秒之后再消失
        [hud hideAnimated:YES afterDelay:2.0];
        return YES;
    }
    return NO;
}

+ (BOOL)dismissHUDForView:(UIView *)view withsuccess:(NSString *)success {
    MBProgressHUD *hud = [self HUDForView:view];
    if (hud != nil) {
        hud.detailsLabel.text = success;
        hud.detailsLabel.font = [UIFont systemFontOfSize:13.0f];
        // 设置图片
        hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"success.png"]];
        // 再设置模式
        hud.mode = MBProgressHUDModeCustomView;
        
        // 隐藏时候从父控件中移除
        hud.removeFromSuperViewOnHide = YES;
        
        // 1.0秒之后再消失
        [hud hideAnimated:YES afterDelay:2.0];
        return YES;
    }
    return NO;
}

#pragma mark 显示一些信息
+ (void)showMessag:(NSString *)message toView:(UIView *)view {
    [self show:message icon:nil view:view];
}

// custem
+ (instancetype)mb_ProgressHUDStatusToView:(UIView*)view statusString:(NSString*)statusString
{
    if (view == nil) view = [UIApplication sharedApplication].keyWindow;
    MBProgressHUD* hud = [[self alloc] initWithView:view];;
    //    hud.animationType = MBProgressHUDAnimationZoom;
    hud.removeFromSuperViewOnHide = YES;
    hud.minShowTime = .3;
    hud.detailsLabel.text = statusString;
    hud.detailsLabel.font = [UIFont systemFontOfSize:13.0f];
    [view addSubview:hud];
    [hud showAnimated:YES];
    return hud;
}

- (void)dismissErrorStatusString:(NSString*)statusString hideAfterDelay:(NSTimeInterval)delay
{
    self.detailsLabel.text = statusString;
    self.detailsLabel.font = [UIFont systemFontOfSize:13.0f];
    // 设置图片
    self.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"error.png"]];
    // 再设置模式
    self.mode = MBProgressHUDModeCustomView;
    [self hideAnimated:YES afterDelay:delay];
}

- (void)dismissSuccessStatusString:(NSString *)statusString hideAfterDelay:(NSTimeInterval)delay
{
    self.detailsLabel.text = statusString;
    self.detailsLabel.font = [UIFont systemFontOfSize:13.0f];
    // 设置图片
    self.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"success.png"]];
    // 再设置模式
    self.mode = MBProgressHUDModeCustomView;
    [self hideAnimated:YES afterDelay:delay];
}

- (void)dismissMsgStatusString:(NSString *)statusString hideAfterDelay:(NSTimeInterval)delay
{
    self.detailsLabel.text = statusString;
    self.detailsLabel.font = [UIFont systemFontOfSize:13.0f];
    // 设置图片
    self.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",nil]]];
    // 再设置模式
    self.mode = MBProgressHUDModeCustomView;
    [self hideAnimated:YES afterDelay:delay];
}
+(void)customProgressHUDWithView:(UIView *)view
{
    if (view == nil) view = [UIApplication sharedApplication].keyWindow;

    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];    
    // Set the custom view mode to show any view.
    hud.mode = MBProgressHUDModeCustomView;
//    hud.bezelView.color = [UIColor blackColor];
    hud.backgroundColor = [UIColor blackColor];
    hud.alpha = 0.2;
    // Set an image view with a checkmark.
//    UIImage *image = [UIImage sd_animatedGIFNamed:@"loading"];
//    hud.customView = [[UIImageView alloc] initWithImage:image];
    // Looks a bit nicer if we make it square.
    hud.square = YES;
    // Optional label text.
//    hud.label.text = NSLocalizedString(@"Done", @"HUD done title");
    
//    [hud hideAnimated:YES afterDelay:3.f];
    [hud showAnimated:YES];
}
@end
