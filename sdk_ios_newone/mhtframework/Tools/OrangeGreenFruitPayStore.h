//
//  OrangeGreenFruitPayStore.h
//  GreenFruitframework
//
//  Created by shuangfei on 2018/3/10.
//  Copyright © 2018年 Hu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OrangeGreenFruitIAPManager.h"
#import "OrangeGreenFruit_CustomNativeByte_SDKHelper.h"
@interface OrangeGreenFruitPayStore : NSObject<GreenFruitIAPDelegate>
- (void)payGreenFruit_CustomNativeByte_SDKPay:(GreenFruit_CustomNativeByte_SDKPay*)pay;
@end
