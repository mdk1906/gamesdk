//
//  OrangeNSUserDefaults+Utils.m
//  GreenFruit_CustomNativeByte_SDK
//
//  Created by shuangfei on 2018/2/7.
//  Copyright © 2018年 Hu. All rights reserved.
//

#import "OrangeNSUserDefaults+Utils.h"

@implementation NSUserDefaults (Utils)

+(void)PutDefaults:(NSString *)key Value:(id)value{
    if (key!=NULL&&value!=NULL) {
        NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
        [userDefaults setObject:value forKey:key];
        [userDefaults synchronize];
    }
}

+(id)GetDefaults:(NSString *)key{
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    id obj;
    if (key!=NULL) {
        obj=[userDefaults objectForKey:key];
    }
    return obj;
}

@end
