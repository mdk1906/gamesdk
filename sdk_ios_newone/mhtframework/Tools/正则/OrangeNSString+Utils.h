//
//  OrangeNSString+Utils.h
//  GreenFruitframework
//
//  Created by shuangfei on 2018/2/1.
//  Copyright © 2018年 Hu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Utils)

//工具类  一些常用正则方法、加密、空字符串判断以及json转换
+ (BOOL)isValidPhoneNumber:(NSString*)phone;
+ (BOOL)isValidVerifyCode:(NSString*)code;
+ (BOOL)isValidPassword:(NSString*)password;
+ (BOOL)isValidAccount:(NSString*)account;
+ (NSString *) md5:(NSString *) input;
+ (BOOL)isBlankString:(NSString *)aStr;
+ (NSString*)getWebUrlStr:(NSString*)baseUrl params:(NSDictionary*)oldparams;
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;
+ (NSString*)dictionaryToJson:(NSDictionary *)dic;

+ (NSString *)getDeviceType;
@end
