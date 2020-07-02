//
//  OrangeGreenFruit_CustomNativeByte_SDKHelper.m
//  GreenFruit_CustomNativeByte_SDK
//
//  Created by shuangfei on 2018/2/8.
//  Copyright © 2018年 Hu. All rights reserved.
//

#import "OrangeGreenFruit_CustomNativeByte_SDKHelper.h"

@implementation GreenFruit_CustomNativeByte_SDKUser

@end

@implementation GreenFruit_CustomNativeByte_SDKRoleData

-(id)initWithRoleId:(NSString*)roleId roleName:(NSString*)roleName roleLevel:(NSString*)roleLevel zoneId:(NSString*)zoneId zoneName:(NSString*)zoneName{
    self = [super init];
    if(self){
        self.roleId = roleId;
        self.roleName = roleName;
        self.roleLevel = roleLevel;
        self.zoneId = zoneId;
        self.zoneName = zoneName;
    }
    return self;
}
@end

@implementation GreenFruit_CustomNativeByte_SDKPay

-(id)initWithGreenFruitOrderName:(NSString*)GreenFruitOrderName GreenFruitOrderDetail:(NSString*)GreenFruitOrderDetail GreenFruitOrderAmt:(NSString*)GreenFruitOrderAmt consumerId:(NSString*)consumerId consumerName:(NSString*)consumerName zoneName:(NSString*)zoneName GreenFruitCurrency:(NSString*)GreenFruitCurrency notifyUrl:(NSString*)notifyUrl productID:(NSString*)productID {
    self = [super init];
    if(self){
        self.GreenFruitOrderName = GreenFruitOrderName;
        self.GreenFruitOrderDetail = GreenFruitOrderDetail;
        self.GreenFruitOrderAmt = GreenFruitOrderAmt;
        self.consumerId = consumerId;
        self.consumerName = consumerName;
        self.zonename = zoneName;
        self.GreenFruitCurrency = GreenFruitCurrency;
        self.notifyUrl = notifyUrl;
        self.productID = productID;
    }
    return self;
}

-(NSDictionary*)getDictionary{
    return @{@"GreenFruitOrderName":self.GreenFruitOrderName,
             @"GreenFruitOrderDetail":self.GreenFruitOrderDetail,
             @"GreenFruitOrderAmt":self.GreenFruitOrderAmt,
             @"consumerId":self.consumerId,
             @"consumerName":self.consumerName,
             @"zonename":self.zonename,
             @"GreenFruitCurrency":self.GreenFruitCurrency,
             @"notifyUrl":self.notifyUrl==nil?@"":self.notifyUrl,
             @"productID":self.productID,
             };
}
@end

@implementation OrangeGreenFruit_CustomNativeByte_SDKHelper


@end
