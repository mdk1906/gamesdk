//
//  TTInstallIDManager.h
//  Article
//
//  Created by fengyadong on 17-3-14.
//
//

#import <Foundation/Foundation.h>

/** 设备注册完成回调 */
typedef void(^TTInstallDidRegisterBlock)(NSString *deviceID, NSString *installID, NSString *ssID);

/** 自定义Header中的扩展字段，在header中独立的custom结构中 */
typedef NSDictionary<NSString*, id> *(^TTCustomHeaderBlock)(void);

@interface TTInstallIDManager : NSObject

@property (nonatomic, copy, readonly) NSString *appID;/** app的唯一标示，由头条数据仓库团队统一分配 */
@property (nonatomic, copy, readonly) NSString *channel;/** 渠道名称 */
@property (nonatomic, copy, readonly) NSString *deviceID;/** 设备id */
@property (nonatomic, copy, readonly) NSString *installID;/** 安装id */
@property (nonatomic, copy, readonly) NSString *appName;
@property (nonatomic, copy, readonly) NSString *ssID;/** 用户id，串联匿名和登录用户 */
@property (nonatomic, copy, readonly) NSString *userUniqueID;/** 正在注册ssid的user_unique_id */

@property (nonatomic, copy) TTCustomHeaderBlock customHeaderBlock;/** 使用方自定义Header参数 */

+ (instancetype)sharedInstance;


/**
 是否开启激活设备开关

 @param enable YES:开启 NO:关闭 default:YES
 
 warning ⚠️：如果要关掉激活设备开关此方法必须在 -startWithAppID:channel:appName:finishBlock前调用
 */
+ (void)setActivateDeviceEnable:(BOOL)enable;

//=============================================初始化方法==================================================
/**
 开始调用服务端设备注册接口

 @param appID 当前app的唯一标示，由头条数据仓库团队统一分配
 @param channel 渠道名称，建议正式版App Store 内测版local_test 灰度版用发布的渠道名，如pp
 @param appName 由数据方指定的APP name
 @param didRegisterBlock 设备注册接口完成回调，最多回调一次，没有超时时间。如果已经注册则立马回调，如果还没有则等接口请求解析完成回调。对device_id有依赖的接口可以在这里发送
 */
- (void)startWithAppID:(NSString *)appID
               channel:(NSString *)channel
               appName:(NSString *)appName
           finishBlock:(TTInstallDidRegisterBlock)didRegisterBlock;

//===========================================注册完成回调方法================================================
/**
 设备注册完成的回调

 @param didRegisterBlock 设备注册接口完成回调，最多回调一次，没有超时时间。如果已经注册则立马回调，如果还没有则等接口请求解析完成回调。对device_id有依赖的接口可以在这里发送
 */
- (void)setDidRegisterBlock:(TTInstallDidRegisterBlock)didRegisterBlock;

//=========================================== Debug模式配置 ================================================
/**
 设置当前环境是否为内测版本
 
 @param isInHouseVersion 是否为内测版本
 */
- (void)setIsInHouseVersion:(BOOL)isInHouseVersion;

//=========================================== User-Profile ================================================

/**
 用户登录状态发生变更的时候需要调用此接口，传入当前的用户的user_unique_id

 @param uniqueID 用户当前的user_unique_id
 */
- (void)setCurrentUserUniqueID:(NSString *)uniqueID;

/**
 用户登录状态发生变更的时候需要调用此接口，传入当前的用户的user_unique_id,并且关心SSID重新获取的时机

 @param uniqueID 用户当前的user_unique_id
 @param didRetriveBlock 重新获取SSID的回调
 */
- (void)setCurrentUserUniqueID:(NSString *)uniqueID
           didRetriveSSIDBlock:(TTInstallDidRegisterBlock)didRetriveBlock;

@end
