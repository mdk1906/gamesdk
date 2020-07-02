//
//  OrangeInfoArchive.m
//  GreenFruit_CustomNativeByte_SDK
//
//  Created by shuangfei on 2018/2/7.
//  Copyright © 2018年 Hu. All rights reserved.
//

#import "OrangeInfoArchive.h"
#import "OrangeNSUserDefaults+Utils.h"

@implementation OrangeInfoArchive

+(void)putLoginStatus:(id)loginStatus{
    [NSUserDefaults PutDefaults:@"loginStatus" Value:loginStatus];
}

+(NSNumber*)getLoginStatus{
    return [NSUserDefaults GetDefaults:@"loginStatus"];
}

+(void)putSid:(id)sid{
    return [NSUserDefaults PutDefaults:@"sid" Value:sid];
}

+(NSString*)getSid{
    return [NSUserDefaults GetDefaults:@"sid"];
}

+(void)putUserid:(id)userId{
    [NSUserDefaults PutDefaults:@"userId" Value:userId];
}

+(NSString*)getUserId{
    return [NSUserDefaults GetDefaults:@"userId"];
}

+(void)putAccountName:(id)accountName{
   [NSUserDefaults PutDefaults:@"accountName" Value:accountName];
}

+(NSString*)getAccountName{
    return [NSUserDefaults GetDefaults:@"accountName"];
}

+(void)putLoginPwd:(id)loginPwd{
    [NSUserDefaults PutDefaults:@"loginPwd" Value:loginPwd];
}

+(NSString*)getLoginPwd{
    return [NSUserDefaults GetDefaults:@"loginPwd"];
}

+(void)putZonename:(id)zonename{
    [NSUserDefaults PutDefaults:@"zonename" Value:zonename];
}

+(NSString*)getZonename{
    return [NSUserDefaults GetDefaults:@"zonename"];
}

+(void)putGreenFruitUser:(GreenFruit_CustomNativeByte_SDKUser*)user{
    return [NSUserDefaults PutDefaults:@"USERINFO" Value:user];
}

+(GreenFruit_CustomNativeByte_SDKUser*)getGreenFruitUser{
    return [NSUserDefaults GetDefaults:@"USERINFO"];
}

+(void)updateInfo:(NSString*)accountName loginPwd:(NSString*)pwd{
    if(accountName && ![accountName isEqualToString:@""]){
        [NSUserDefaults PutDefaults:@"accountName" Value:accountName];
    }
    if(pwd && ![pwd isEqualToString:@""]){
        [NSUserDefaults PutDefaults:@"loginPwd" Value:pwd];
    }
    
}

@end
