//
//  OrangeInfoArchive.h
//  GreenFruit_CustomNativeByte_SDK
//
//  Created by shuangfei on 2018/2/7.
//  Copyright © 2018年 Hu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OrangeGreenFruit_CustomNativeByte_SDKHelper.h"
@interface OrangeInfoArchive : NSObject

@property(nonatomic,assign) BOOL loginStatus;
@property(nonatomic,copy) NSString *sid;
@property(nonatomic,copy) NSString *userid;
@property(nonatomic,copy) NSString *accountName;
@property(nonatomic,copy) NSString *loginPwd;
@property(nonatomic,copy) NSString *zonename;

+(void)putLoginStatus:(id)loginStatus;
+(NSNumber*)getLoginStatus;
+(void)putSid:(id)sid;
+(NSString*)getSid;
+(void)putUserid:(id)userId;
+(NSString*)getUserId;
+(void)putAccountName:(id)accountName;
+(NSString*)getAccountName;
+(void)putLoginPwd:(id)loginPwd;
+(NSString*)getLoginPwd;
+(void)putZonename:(id)zonename;
+(NSString*)getZonename;
+(void)updateInfo:(NSString*)accountName loginPwd:(NSString*)pwd;
+(void)putGreenFruitUser:(GreenFruit_CustomNativeByte_SDKUser*)user;
+(GreenFruit_CustomNativeByte_SDKUser*)getGreenFruitUser;
@end
