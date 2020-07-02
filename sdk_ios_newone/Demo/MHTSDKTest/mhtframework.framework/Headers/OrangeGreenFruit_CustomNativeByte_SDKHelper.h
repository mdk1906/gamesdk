//
//  OrangeGreenFruit_CustomNativeByte_SDKHelper.h
//  GreenFruit_CustomNativeByte_SDK
//
//  Created by shuangfei on 2018/2/8.
//  Copyright © 2018年 Hu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GreenFruit_CustomNativeByte_SDKUser : NSObject

@property (nonatomic,copy) NSString *appId;
@property (nonatomic,copy) NSString *channellevel1;
@property (nonatomic,copy) NSString *userId;
@property (nonatomic,copy) NSString *accountname;
@property (nonatomic,copy) NSString *ssid;
@property (nonatomic,copy) NSString *channellevel2;

@end

@interface GreenFruit_CustomNativeByte_SDKRoleData : NSObject

@property (nonatomic,copy) NSString *roleId;// 角色唯一标识
@property (nonatomic,copy) NSString *roleName;// 角色名
@property (nonatomic,copy) NSString *roleLevel;// 角色等级
@property (nonatomic,copy) NSString *zoneId;// 角色所在区
@property (nonatomic,copy) NSString *zoneName;// 角色所在区名称

-(id)initWithRoleId:(NSString*)roleId roleName:(NSString*)roleName roleLevel:(NSString*)roleLevel zoneId:(NSString*)zoneId zoneName:(NSString*)zoneName;

@end

@interface GreenFruit_CustomNativeByte_SDKPay : NSObject

@property (nonatomic,copy) NSString *GreenFruitOrderName;// 角色所在区
@property (nonatomic,copy) NSString *GreenFruitOrderDetail;// 角色所在区名称
@property (nonatomic,copy) NSString *GreenFruitOrderAmt;// 充值金额(单位:分)
@property (nonatomic,copy) NSString *consumerId;// 游戏唯一标识
@property (nonatomic,copy) NSString *consumerName;// 自定义名称
@property (nonatomic,copy) NSString *zonename;// 区服名
@property (nonatomic,copy) NSString *GreenFruitCurrency; // 游戏货币数量
@property (nonatomic,copy) NSString *notifyUrl;// 回调地址
@property (nonatomic,copy) NSString *productID;// 商品id


-(id)initWithGreenFruitOrderName:(NSString*)GreenFruitOrderName GreenFruitOrderDetail:(NSString*)GreenFruitOrderDetail GreenFruitOrderAmt:(NSString*)GreenFruitOrderAmt consumerId:(NSString*)consumerId consumerName:(NSString*)consumerName zoneName:(NSString*)zoneName GreenFruitCurrency:(NSString*)GreenFruitCurrency notifyUrl:(NSString*)notifyUrl productID:(NSString*)productID;
-(NSDictionary*)getDictionary;
@end

@interface OrangeGreenFruit_CustomNativeByte_SDKHelper : NSObject

@end
