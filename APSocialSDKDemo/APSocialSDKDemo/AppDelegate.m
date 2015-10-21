//
//  AppDelegate.m
//  APSocialSDKDemo
//
//  Created by Alipay on 15/6/24.
//  Copyright (c) 2015年 Alipay. All rights reserved.
//

#import "AppDelegate.h"
#import "APRootViewController.h"
#import "APOpenAPI.h"

//  在需要处理支付宝应用回调的类内添加对应的Delegate
@interface AppDelegate () <APOpenAPIDelegate>

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    //  创建供Demo使用的根视图
    APRootViewController *rootViewController = [[APRootViewController alloc] initWithNibName:nil bundle:nil];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:rootViewController];
    self.window.rootViewController = navigationController;
    
    //  配置应用的AppId
    //      重要：必须先在支付宝开放平台申请您的AppId才能正常使用支付宝社交分享功能
    //      Demo中的AppId，使用xxxxxxxxxx代替
    [APOpenAPI registerApp:@"xxxxxxxxxx"];
    
    return YES;
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    //  处理支付宝通过URL启动App时传递的数据
    return [APOpenAPI handleOpenURL:url delegate:self];
}
/*
 *  收到一个来自支付宝的请求，第三方应用程序处理完后调用sendResp向支付宝发送结果
 *
 *  入参
 *      req : 支付宝向第三方发来的请求类
 */
- (void)onReq:(APBaseReq*)req
{}
/*
 *  第三方应用程序发送一个sendReq后，收到支付宝的响应结果
 *
 *  入参
 *      resp : 第三方应用收到的支付宝的响应结果类，目前支持的类型包括 APSendMessageToAPResp(分享消息)
 */
- (void)onResp:(APBaseResp*)resp
{
    //  Demo内主要是将响应结果通过alert的形式反馈出来，第三方应用可以根据 errCode 进行相应的处理。
    NSString *title = nil;
    NSString *message = nil;
    if (resp.errCode == APSuccess) {
        title = @"成功";
    } else {
        title = @"失败";
        message = [NSString stringWithFormat:@"%@(%d)", resp.errStr, resp.errCode];
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
}

@end
