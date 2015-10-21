//
//  APRootViewController.m
//  APSocialSDKDemo
//
//  Created by Alipay on 15/6/24.
//  Copyright (c) 2015年 Alipay. All rights reserved.
//

#import "APRootViewController.h"
//  导入支付宝社交分享SDK头文件
#import "APOpenAPI.h"

@interface APRootViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSMutableArray *actions;  //  用于存储供Demo使用的 示例标题、处理方法 的数组
@end

@implementation APRootViewController

/*
 *  以下主要为Demo内的数据初始化
 */
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //  初始化 actions 数组
        NSMutableArray *actions = [NSMutableArray array];
        [actions addObject:@{@"title":@"发送文本消息到支付宝", @"action":@"sendText"}];
        [actions addObject:@{@"title":@"发送图片消息到支付宝(图片链接形式)", @"action":@"sendPhotoByUrl"}];
        [actions addObject:@{@"title":@"发送图片消息到支付宝(图片数据形式)", @"action":@"sendPhotoByData"}];
        [actions addObject:@{@"title":@"发送网页消息到支付宝(缩略图链接形式)", @"action":@"sendWebByUrl"}];
        [actions addObject:@{@"title":@"发送网页消息到支付宝(缩略图数据形式)", @"action":@"sendWebByData"}];
        self.actions = actions;
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"支付宝分享SDK";
    
    //  创建供Demo使用的 UITableView 对象
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    tableView.backgroundColor = self.view.backgroundColor;
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    
    UIView *emptyFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    tableView.tableFooterView = emptyFooterView;
}
//  处理UITableView相关的回调方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.actions count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.detailTextLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = self.actions[indexPath.row][@"title"];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *action = self.actions[indexPath.row][@"action"];
    SEL selector = NSSelectorFromString(action);
    if ([self respondsToSelector:selector]) {
        [self performSelector:selector withObject:nil];
    }
}

/*
 *  以下主要为发送消息代码示例
 */

//  发送文本消息到支付宝
- (void)sendText
{
    //  创建消息载体 APMediaMessage 对象
    APMediaMessage *message = [[APMediaMessage alloc] init];
    
    //  创建文本类型的消息对象
    APShareTextObject *textObj = [[APShareTextObject alloc] init];
    textObj.text = @"此处填充发送到支付宝的纯文本信息";
    //  回填 APMediaMessage 的消息对象
    message.mediaObject = textObj;
    
    //  创建发送请求对象
    APSendMessageToAPReq *request = [[APSendMessageToAPReq alloc] init];
    //  填充消息载体对象
    request.message = message;
    //  发送请求
    BOOL result = [APOpenAPI sendReq:request];
    if (!result) {
        //失败处理
        NSLog(@"发送失败");
    }
}

//  发送图片消息到支付宝(图片链接形式)
- (void)sendPhotoByUrl
{
    //  创建消息载体 APMediaMessage 对象
    APMediaMessage *message = [[APMediaMessage alloc] init];
    
    //  创建图片类型的消息对象
    APShareImageObject *imgObj = [[APShareImageObject alloc] init];
    imgObj.imageUrl = @"此处填充图片的url链接地址";
    //  回填 APMediaMessage 的消息对象
    message.mediaObject = imgObj;
    
    //  创建发送请求对象
    APSendMessageToAPReq *request = [[APSendMessageToAPReq alloc] init];
    //  填充消息载体对象
    request.message = message;
    //  发送请求
    BOOL result = [APOpenAPI sendReq:request];
    if (!result) {
        //失败处理
        NSLog(@"发送失败");
    }
}

//  发送图片消息到支付宝(图片数据形式)
- (void)sendPhotoByData
{
    //  创建消息载体 APMediaMessage 对象
    APMediaMessage *message = [[APMediaMessage alloc] init];
    
    //  创建图片类型的消息对象
    APShareImageObject *imgObj = [[APShareImageObject alloc] init];
    //  此处填充图片data数据,例如 UIImagePNGRepresentation(UIImage对象)
    //  此处必须填充有效的image NSData类型数据，否则无法正常分享
    imgObj.imageData = nil;
    //  回填 APMediaMessage 的消息对象
    message.mediaObject = imgObj;
    
    //  创建发送请求对象
    APSendMessageToAPReq *request = [[APSendMessageToAPReq alloc] init];
    //  填充消息载体对象
    request.message = message;
    //  发送请求
    BOOL result = [APOpenAPI sendReq:request];
    if (!result) {
        //失败处理
        NSLog(@"发送失败");
    }
}

//  发送网页消息到支付宝(缩略图链接形式)
- (void)sendWebByUrl
{
    //  创建消息载体 APMediaMessage 对象
    APMediaMessage *message = [[APMediaMessage alloc] init];
    
    message.title = @"此处填充网页标题";
    message.desc = @"此处填充网页简要内容";
    message.thumbUrl = @"此处填充缩略图的url链接地址";
    
    //  创建网页类型的消息对象
    APShareWebObject *webObj = [[APShareWebObject alloc] init];
    webObj.wepageUrl = @"此处填充网页url链接地址";
    //  回填 APMediaMessage 的消息对象
    message.mediaObject = webObj;
    
    //  创建发送请求对象
    APSendMessageToAPReq *request = [[APSendMessageToAPReq alloc] init];
    //  填充消息载体对象
    request.message = message;
    //  发送请求
    BOOL result = [APOpenAPI sendReq:request];
    if (!result) {
        //失败处理
        NSLog(@"发送失败");
    }
}

//  发送网页消息到支付宝(缩略图链接形式)
- (void)sendWebByData
{
    //  创建消息载体 APMediaMessage 对象
    APMediaMessage *message = [[APMediaMessage alloc] init];
    
    message.title = @"此处填充网页标题";
    message.desc = @"此处填充网页简要内容";
    //  此处填充缩略图data数据,例如 UIImagePNGRepresentation(UIImage对象)
    //  此处必须填充有效的image NSData类型数据，否则无法正常分享
    message.thumbData = nil;
    
    //  创建网页类型的消息对象
    APShareWebObject *webObj = [[APShareWebObject alloc] init];
    webObj.wepageUrl = @"此处填充网页url链接地址";
    //  回填 APMediaMessage 的消息对象
    message.mediaObject = webObj;
    
    //  创建发送请求对象
    APSendMessageToAPReq *request = [[APSendMessageToAPReq alloc] init];
    //  填充消息载体对象
    request.message = message;
    //  发送请求
    BOOL result = [APOpenAPI sendReq:request];
    if (!result) {
        //失败处理
        NSLog(@"发送失败");
    }
}

@end
