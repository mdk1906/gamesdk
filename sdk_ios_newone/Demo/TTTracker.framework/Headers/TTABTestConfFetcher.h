//
//  TTABTestConfFetcher.h
//  TTTracker
//
//  Created by fengyadong on 2017/6/18.
//  Copyright © 2017年 fengyadong. All rights reserved.
//

//#if (defined TOBSDK) || (defined VALIDATION)

#import <Foundation/Foundation.h>

typedef void(^TTABTestFinishBlock)(NSDictionary *allConfigs);

@interface TTABTestConfFetcher : NSObject

@property (atomic, copy, readonly) NSDictionary *allConfigs;/*当前最新的全量的配置信息*/
@property (atomic, copy, readonly) NSString *abVersions;/*该用户命中的所有客户端AB实验标示*/
@property (atomic, copy, readonly) NSString *abServerVersions;/*该用户命中的所有服务端AB实验标示*/

/**
 单例方法
 
 @return TTABTestConfFetcher单例
 */
+ (instancetype)sharedInstance;

/**
 开始异步拉取ABTest配置信息

 @param finishBlock 拉取结束的回调
 */
- (void)startFetchABTestConf:(TTABTestFinishBlock)finishBlock;

/**
 获取指定ABTest实验的返回值

 @param key ABTest实验的名字
 @param defaultValue 默认值，如果下发Conf中没有找到对应的key
 @return ABTest的返回值
 */
- (id)getConfig:(NSString *)key defaultValue:(id)defaultValue;

/**
 设置服务端实验的AB实验参数

 @param versions 服务端实验的AB实验参数
 */
- (void)setServerVersions:(NSString *)versions;

@end

//#endif
