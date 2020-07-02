//
//  TTTracker+Game.h
//  Pods
//
//  Created by fengyadong on 2017/9/13.
//
//
//#if (defined GAMESDK) || (defined VALIDATION)

#import <TTTracker/TTTracker.h>

@interface TTTracker (Game)

/**
 用户注册流程完成时调用此接口

 @param method 表示注册方式，业务方可以传任意可标识注册方式的值，如注册方式为手机号：method = @"phone" 微信注册：method = @“WeChat”等。
               这个参数作用：方便业务方在数据平台以method为key查询数据
 @param isSuccess 是否注册成功
 */
+ (void)registerEventByMethod:(NSString *)method isSuccess:(BOOL)isSuccess;

/**
 用户登录完成时调用此接口
 
 @param method 表示登录的方式，如游戏账号、手机号等
 @param isSuccess 是否登录成功
 */
+ (void)loginEventByMethod:(NSString *)method isSuccess:(BOOL)isSuccess;

/**
 绑定社交账户时调用此接口
 
 @param method 表示登录的方式，如游戏账号、手机号等
 @param isSuccess 是否注册成功
 */

/**
绑定社交账户时调用此接口

 @param type 社交账号类型 如如微信、微博等
 @param isSuccess 是否绑定成功
 */
+ (void)accessAccountEventByType:(NSString *)type isSuccess:(BOOL)isSuccess;

/**
 完成节点（如教学/任务/副本）时调用此接口

 @param questID 教学/任务/副本等关卡标识符
 @param type 节点类型
 @param name 教学/任务/副本等关卡名称
 @param number 第几个任务节点
 @param desc 节点描述
 @param isSuccess 节点是否完成
 */
+ (void)questEventWithQuestID:(NSString *)questID
                  questType:(NSString *)type
                  questName:(NSString *)name
                 questNumer:(NSUInteger)number
                description:(NSString *)desc
                  isSuccess:(BOOL)isSuccess;

/**
 用户升级后调用此接口

 @param level 当前用户等级
 */
+ (void)updateLevelEventWithLevel:(NSUInteger)level;

/**
 查看内容/商品详情时调用此接口

 @param type 内容类型如“配备”、“皮肤”
 @param name 商品或内容名称
 @param contentID 商品或内容标识符
 */
+ (void)viewContentEventWithContentType:(NSString *)type
                            contentName:(NSString *)name
                              contentID:(NSString *)contentID;

/**
 加入购买/购物车时调用此接口

 @param type 内容类型如“配备”、“皮肤”
 @param name 商品或内容名称
 @param contentID 商品或内容标识符
 @param number 商品数量
 @param isSuccess 加入购买/购物车是否成功
 */
+ (void)addCartEventWithContentType:(NSString *)type
                            contentName:(NSString *)name
                              contentID:(NSString *)contentID
                      contentNumber:(NSUInteger)number
                              isSuccess:(BOOL)isSuccess;

/**
 提交购买/下单时调用此接口

 @param type 内容类型如“配备”、“皮肤”
 @param name 商品或内容名称
 @param contentID 商品或内容标识符
 @param number 商品数量
 @param isVirtualCurrency 是否使用的是虚拟货币
 @param virtualCurrency 虚拟货币类型，如"元宝"、“金币”等
 @param currency 真实货币类型，ISO 4217代码，如：“USD”
 @param isSuccess 提交购买/下单是否成功
 */
+ (void)checkoutEventWithContentType:(NSString *)type
                        contentName:(NSString *)name
                          contentID:(NSString *)contentID
                      contentNumber:(NSUInteger)number
                   isVirtualCurrency:(BOOL)isVirtualCurrency
                    virtualCurrency:(NSString *)virtualCurrency
                            currency:(NSString *)currency
                          isSuccess:(BOOL)isSuccess;

/**
 支付时调用此接口

 @param type 内容类型如“配备”、“皮肤”
 @param name 商品或内容名称
 @param contentID 商品或内容标识符
 @param number 商品数量
 @param channel 支付渠道名，如支付宝、微信等
 @param currency 真实货币类型，ISO 4217代码，如：“USD”
 @param amount 本次支付的真实货币的金额
 @param isSuccess 支付是否成功
 */
+ (void)purchaseEventWithContentType:(NSString *)type
                         contentName:(NSString *)name
                           contentID:(NSString *)contentID
                       contentNumber:(NSUInteger)number
                      paymentChannel:(NSString *)channel
                            currency:(NSString *)currency
                     currency_amount:(unsigned long long)amount
                           isSuccess:(BOOL)isSuccess;

/**
 添加支付渠道时调用此接口

 @param channel 支付渠道名，如支付宝、微信等
 @param isSuccess 添加支付渠道是否成功
 */
+ (void)accessPaymentChannelEventByChannel:(NSString *)channel isSuccess:(BOOL)isSuccess;

@end

//#endif
