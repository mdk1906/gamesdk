//
//  OrangeGreenFruit_CustomNativeByte_SDKCreate.h
//  GreenFruit_CustomNativeByte_SDK
//
//  Created by shuangfei on 2018/2/23.
//  Copyright © 2018年 Hu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "OrangeGreenFruit_CustomNativeByte_SDKHelper.h"

typedef void(^GreenFruit_CustomNativeByte_SDKLogoutStatusBlock)(NSString * code);
typedef void(^GreenFruit_CustomNativeByte_SDKCreateReturnInfoBlock)(NSString * code);
typedef void(^GreenFruit_CustomNativeByte_SDKLogoutCompletionBlock)(NSString * code);
typedef void(^GreenFruit_CustomNativeByte_SDKSettingRoleDataCompletionBlock)(NSString * code);
typedef void(^GreenFruit_CustomNativeByte_SDKLoginCompletionBlock)(GreenFruit_CustomNativeByte_SDKUser *user,NSString * code);
typedef void(^GreenFruit_CustomNativeByte_SDKPayBackBlock)(NSString * code);

@interface OrangeGreenFruit_CustomNativeByte_SDKCreate : NSObject

/*
 初始化单例
 */
+ (instancetype)share_CustomNativeByte_Manager;

/*
 初始化游戏账号信息
 returnInfoBlock    初始化接口返回状态
 logoutStatusBlock  监听退出状态
 */
- (void)GreenFruitOnCreateAppid:(NSString*)appid channellevel1:(NSString*)channellevel1
           channellevel2:(NSString*)channellevel2 withVC:(UIViewController*)rootVC successBlock:(GreenFruit_CustomNativeByte_SDKCreateReturnInfoBlock)returnInfoBlock withLogoutStatusBlock:(GreenFruit_CustomNativeByte_SDKLogoutStatusBlock)logoutStatusBlock;

/*
 新版初始化接口  -     植入统计功能
 appid              猕猴桃AppId
 channellevel1      渠道1
 channellevel2      渠道2
 event_Ad_Id        统计功能中用户id
 event_ad_appName   统计功能中用户应用名
 returnInfoBlock    初始化接口返回状态
 logoutStatusBlock  监听退出状态
 */
- (void)GreenFruitNewOnCreateAppid:(NSString*)appid channellevel1:(NSString*)channellevel1
              channellevel2:(NSString*)channellevel2  withGreenFruit_event_ad_id:(NSString*)event_Ad_Id  andGreenFruit_event_ad_appName:(NSString *)event_ad_appName successBlock:(GreenFruit_CustomNativeByte_SDKCreateReturnInfoBlock)returnInfoBlock withLogoutStatusBlock:(GreenFruit_CustomNativeByte_SDKLogoutStatusBlock)logoutStatusBlock;

/*
 登录方法
 GreenFruit_CustomNativeByte_SDKLoginCompletionBlock 登录状态
 */
- (void)GreenFruitLoginRootVC:(UIViewController*)rootVC CompletionBlock:(GreenFruit_CustomNativeByte_SDKLoginCompletionBlock)completionBlock;

/*
 退出方法
 GreenFruit_CustomNativeByte_SDKLogoutCompletionBlock 退出状态
 */
- (void)GreenFruitLogoutRootVC:(UIViewController*)rootVC CompletionBlock:(GreenFruit_CustomNativeByte_SDKLogoutCompletionBlock)completionBlock;

/*
 设置角色信息
 GreenFruit_CustomNativeByte_SDKSettingRoleDataCompletionBlock 上报角色信息返回状态
 */
- (void)GreenFruitSettingRoleDataWithRootVC:(UIViewController*)rootVC roleData:(GreenFruit_CustomNativeByte_SDKRoleData*)roleData CompletionBlock:(GreenFruit_CustomNativeByte_SDKSettingRoleDataCompletionBlock)completionBlock;

/*
 平台支付
 */
- (void)GreenFruitPayDataWithRootVC:(UIViewController*)rootVC pay:(GreenFruit_CustomNativeByte_SDKPay*)pay;

/*
 苹果内购
 */
- (void)GreenFruitPayByStoreIAP:(UIViewController*)rootVC pay:(GreenFruit_CustomNativeByte_SDKPay*)pay;

/*
 内购支付回调
 在发起支付前进行调用 
 */
-(void)GreenFruitIAPPayReturnMethodWithCompletionBlock:(GreenFruit_CustomNativeByte_SDKPayBackBlock)completionBlock;


@end
