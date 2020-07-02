//
//  TTTracker.h
//  TTTracker
//
//  Created by fengyadong on 2017-3-14.
//  Copyright (c) 2017 toutiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TTInstallIDManager.h"
#ifndef TOBSDK
#import "TTTrackerHeader.h"
#import "TTInstallBaseMacro.h"
#endif

//+----------------+----------+----------+---------+--------------------------+
//| Key            | Type     | Required | Default |  Meaning                 |
//+----------------+----------+----------+---------+--------------------------+
//| user_id        | String   | NO       | NULL    | login user_id            |
//| need_encrypt   | BOOL     | NO       | YES     | whether encrypt          |
//| user_unique_id | String   | NO       | NULL    | unique_id for login user |
//+----------------+----------+----------+---------+--------------------------+
typedef NSDictionary *_Nullable(^TTTrackerConfigParamsBlock)(void);
/** 捕获一个即将被缓存的log */
typedef void(^TTTrackerLogHookBlock)(NSDictionary * _Nonnull hookedLog);

@interface TTTracker : NSObject

@property (nonatomic, copy, readonly) NSString * _Nonnull appID;/** 应用唯一标示 */
@property (nonatomic, copy, readonly) NSString * _Nonnull channel;/** 应用发布的渠道名 */

//可选配置
@property (nonatomic, copy) TTTrackerConfigParamsBlock _Nullable configParamsBlock;/** 外部使用方配置是否加密等参数 */
@property (nonatomic, copy) TTCustomHeaderBlock _Nullable customHeaderBlock;/** 使用方自定义Header参数 */
@property (nonatomic, copy, readonly) NSDictionary<NSString*, id> *_Nullable configParams;/** 配置信息参数 */
@property (atomic, copy, readonly) NSDictionary<NSString*, TTTrackerLogHookBlock> *_Nullable logHookDict;

//是否开启session YES开启NO关闭 default= YES ⚠️必须在+startWithAppID:channel:appName前设置才有效
@property (nonatomic, assign) BOOL sessionEnable;

//==================================单例方法======================================
+ (instancetype _Nonnull)sharedInstance;

//==================================初始化方法====================================
/**
 启动tracker服务

 @param appID 应用标示,由头条数据仓库组统一分配
 @param appName 应用名，需向头条申请
 @param channel 渠道名称，建议正式版App Store 内测版local_test 灰度版用发布的渠道名，如pp
 */
+ (void)startWithAppID:(NSString *_Nonnull)appID channel:(NSString *_Nonnull)channel appName:(NSString *_Nonnull)appName;

/**
 用户登录状态发生变更的时候需要调用此接口，传入当前的用户的user_unique_id
 
 @param uniqueID 用户当前的user_unique_id
 */
- (void)setCurrentUserUniqueID:(NSString *_Nullable)uniqueID;

/**
 用户登录状态发生变更的时候需要调用此接口，传入当前的用户的user_unique_id,并且关心SSID重新获取的时机
 
 @param uniqueID 用户当前的user_unique_id
 @param didRetriveBlock 重新获取SSID的回调
 */
- (void)setCurrentUserUniqueID:(NSString *_Nullable)uniqueID
           didRetriveSSIDBlock:(TTInstallDidRegisterBlock _Nullable)didRetriveBlock;

//=============================== V3 Interface ===================================
/**
 v3格式日志打点
 @param event 事件名称
 @param params 额外参数
 */
+ (void)eventV3:(NSString *_Nonnull)event params:(NSDictionary *_Nullable)params;


//================================== 钩子方法 ======================================
/**
 捕获一条即将被缓存的埋点日志，做一些额外的事情，比如监控等

 @param serviceID 本业务标示建议公司名.产品线.具体业务 比如bytedance.toutiao.ad
 @param logHookBlock 一条即将被缓存的埋点日志
 */
- (void)registerWithServiceID:(NSString *_Nonnull)serviceID willCacheOneLogBlock:(TTTrackerLogHookBlock _Nullable)logHookBlock;

//=============================== Debug模式配置 ====================================
/**
 设置当前环境是否为内测版本
 
 @param isInHouseVersion 是否为内测版本
 */
- (void)setIsInHouseVersion:(BOOL)isInHouseVersion;

/**
 设置debug阶段埋点验证工具的域名和端口号，一般在应用的高级调试中设置
 
 @param hostName 返回当前验证工具所在的pc主机的ip和端口号，形如：10.2.201.7:10304 */
- (void)setDebugLogServerHost:(NSString *_Nonnull)hostName;

/**
 设置debug阶段埋点验证工具的完整url地址，一般在二维码扫描回调里调用此方法
 
 @param serverAddress 返回能连接到当前验证工具的完整url地址 */
- (void)setDebugLogServerAddress:(NSString *_Nonnull)serverAddress;

@end

