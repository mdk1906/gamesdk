//
//  OrangeNSUserDefaults+Utils.h
//  GreenFruit_CustomNativeByte_SDK
//
//  Created by shuangfei on 2018/2/7.
//  Copyright © 2018年 Hu. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface NSUserDefaults (Utils)

+(void)PutDefaults:(NSString *)key Value:(id)value;
+(id)GetDefaults:(NSString *)key;

@end
