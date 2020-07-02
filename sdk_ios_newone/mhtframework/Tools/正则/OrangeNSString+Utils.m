//
//  OrangeNSString+Utils.m
//  GreenFruitframework
//
//  Created by shuangfei on 2018/2/1.
//  Copyright © 2018年 Hu. All rights reserved.
//

#import "OrangeNSString+Utils.h"
#import<CommonCrypto/CommonDigest.h>
#import "OrangeInfoArchive.h"
#import "OrangeGreenFruitConfig.h"
#import "OrangeAPIParams.h"
#import <sys/utsname.h>

@implementation NSString (Utils)

+ (BOOL)isValidPhoneNumber:(NSString*)phone{
    if(phone.length!=11){
        return false;
    }
//    NSString *mobile = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
//    NSString *CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
//    NSString *CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
//    NSString *CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
//    NSString *C7 = @"^1(7[0-9]|4[0-9])\\d{8}$";
//    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",mobile];
//    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",CM];
//    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",CU];
//    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",CT];
//    NSPredicate *regextestc7 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",C7];
//    if([regextestmobile evaluateWithObject:phone]
//       || [regextestcm evaluateWithObject:phone]
//       || [regextestcu evaluateWithObject:phone]
//       || [regextestct evaluateWithObject:phone]
//       || [regextestc7 evaluateWithObject:phone]){
//        return true;
//    }else{
//        return false;
//    }
    NSString * firstStr = [phone substringToIndex:1];
    if ([firstStr isEqualToString:@"1"]) {
        return true;
    }else{
        return false;
    }
    
}

+ (BOOL)isValidVerifyCode:(NSString*)code{
    NSString *mobile = @"\\d{4,6}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",mobile];
    if([regextestmobile evaluateWithObject:code]){
        return true;
    }else{
        return false;
    }
}

+ (BOOL)isValidPassword:(NSString*)password{
    if(password.length<6 || password.length>16){
        return false;
    }
    NSString *mobile = @"^[0-9A-Za-z\\u0020-\\u007e]{6,16}+$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",mobile];
    if([regextestmobile evaluateWithObject:password]){
        return true;
    }else{
        return false;
    }
}

+ (BOOL)isValidAccount:(NSString*)account{
    if(account.length<6 || account.length>16){
        return false;
    }
    NSString *mobile = @"^[0-9A-Za-z]{6,16}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",mobile];
    if([regextestmobile evaluateWithObject:account]){
        return true;
    }else{
        return false;
    }
}

+ (NSString *)md5:(NSString *)input {
    const char *cStr = [input UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, strlen(cStr), digest ); // This is the md5 call
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
    [output appendFormat:@"%02x", digest[i]];
    return  output;
}

#pragma mark ---判断字符串是否为空
+ (BOOL)isBlankString:(NSString *)aStr {
    if (!aStr) {
        return YES;
    }
    if ([aStr isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if (!aStr.length) {
        return YES;
    }
    //有值，则去掉空格等特殊符号
    NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    //去掉字符串两边的特殊符号
    NSString *trimmedStr = [aStr stringByTrimmingCharactersInSet:set];
    if (!trimmedStr.length) {
        return YES;
    }
    return NO;
}

+ (NSString*)getWebUrlStr:(NSString*)baseUrl params:(NSDictionary*)oldparams{
    NSMutableDictionary *newParam = [NSMutableDictionary dictionaryWithDictionary:oldparams];
    newParam[@"userid"] = [OrangeInfoArchive getUserId];
    newParam[@"appid"] = Appid;
    newParam[@"channellevel1"] = Channelleve1;
    newParam[@"mhtCurrencyType"] = GreenFruitCurrencyType;
    newParam[@"accountName"] = [OrangeInfoArchive getAccountName];
    newParam[@"version"] = GreenFruitCurrencyType;
    
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    paramDict[@"accountName"] = newParam[@"accountName"];
    paramDict[@"appid"] = newParam[@"appid"];
    paramDict[@"channellevel1"] = newParam[@"channellevel1"];
    paramDict[@"channellevel2"] = newParam[@"channellevel2"];
    paramDict[@"consumerId"] = newParam[@"consumerId"];
    paramDict[@"imei"] = UUID;
    
    paramDict[@"consumerName"] = newParam[@"consumerName"];
    paramDict[@"mhtCurrency"] = newParam[@"GreenFruitCurrency"];
    paramDict[@"mhtCurrencyType"] = GreenFruitCurrencyType;
    paramDict[@"mhtOrderAmt"] = newParam[@"GreenFruitOrderAmt"];
    paramDict[@"mhtOrderDetail"] = newParam[@"GreenFruitOrderDetail"];
    paramDict[@"mhtOrderName"] = newParam[@"GreenFruitOrderName"];
    paramDict[@"userUniqueId"] = @"user";
    
    paramDict[@"notifyUrl"] = newParam[@"notifyUrl"];
    paramDict[@"userid"] = newParam[@"userid"];
    paramDict[@"version"] = newParam[@"version"];
    paramDict[@"zonename"] = newParam[@"zonename"];
    //
    
    NSLog(@"平台支付的参数--:%@",paramDict);

    NSString *sign = [OrangeAPIParams signParams:paramDict];
    paramDict[@"sign"] = sign;
    NSString *temp = @"";
    for(NSString *key in paramDict){
        NSString *value = paramDict[key];
        //去掉特殊符号
        NSCharacterSet *charSet = [NSCharacterSet characterSetWithCharactersInString:@"\"`#%^{}\"[]|\\<>!@$*()+?,/&: "].invertedSet;
        NSLog(@"遍历字典的键:%@",key);
        NSLog(@"对应的值:%@",value);
        
        NSString *encodeValue = [value stringByAddingPercentEncodingWithAllowedCharacters:charSet];
        
        NSLog(@"字符串转换后的信息%@",encodeValue);
        
        temp = [temp stringByAppendingFormat:@"%@=%@&",key,encodeValue];
        
        NSLog(@"拼接的字符串:%@",temp);
    }
    //截取到倒数第二位
    temp = [temp substringToIndex:temp.length-1];
    temp = [NSString stringWithFormat:@"%@?%@",baseUrl,temp];
    NSLog(@"%@",temp);
    return temp;
}

/**
 *  JSON字符串转NSDictionary
 *
 *  @param jsonString JSON字符串
 *
 *  @return NSDictionary
 */
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    if(error) {
        NSLog(@"json解析失败：%@",error);
        return nil;
    }
    return dic;
}
/**
 *  字典转JSON字符串
 *
 *  @param dic 字典
 *
 *  @return JSON字符串
 */
+ (NSString*)dictionaryToJson:(NSDictionary *)dic{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

+ (NSString *)getDeviceType{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString*platform = [NSString stringWithCString: systemInfo.machine encoding:NSASCIIStringEncoding];
    if([platform isEqualToString:@"iPhone1,1"])return @"iPhone2G";
    if([platform isEqualToString:@"iPhone1,2"])return@"iPhone3G";
    if([platform isEqualToString:@"iPhone2,1"])return@"iPhone3GS";
    if([platform isEqualToString:@"iPhone3,1"])return@"iPhone4";
    if([platform isEqualToString:@"iPhone3,2"])return@"iPhone4";
    if([platform isEqualToString:@"iPhone3,3"])return@"iPhone4";
    if([platform isEqualToString:@"iPhone4,1"])return@"iPhone4S";
    if([platform isEqualToString:@"iPhone5,1"])return@"iPhone5";
    if([platform isEqualToString:@"iPhone5,2"])return@"iPhone5";
    if([platform isEqualToString:@"iPhone5,3"])return@"iPhone5c";
    if([platform isEqualToString:@"iPhone5,4"])return@"iPhone5c";
    if([platform isEqualToString:@"iPhone6,1"])return@"iPhone5s";
    if([platform isEqualToString:@"iPhone6,2"])return@"iPhone5s";
    if([platform isEqualToString:@"iPhone7,1"])return@"iPhone6Plus";
    if([platform isEqualToString:@"iPhone7,2"])return@"iPhone6";
    if([platform isEqualToString:@"iPhone8,1"])return@"iPhone6s";
    if([platform isEqualToString:@"iPhone8,2"])return@"iPhone6sPlus";
    if([platform isEqualToString:@"iPhone8,4"])return@"iPhoneSE";
    if([platform isEqualToString:@"iPhone9,1"])return@"iPhone7";
    if([platform isEqualToString:@"iPhone9,2"])return@"iPhone7Plus";
    if([platform isEqualToString:@"iPhone10,1"])return@"iPhone8";
    if([platform isEqualToString:@"iPhone10,4"])return@"iPhone8";
    if([platform isEqualToString:@"iPhone10,2"])return@"iPhone8Plus";
    if([platform isEqualToString:@"iPhone10,5"])return@"iPhone8Plus";
    if([platform isEqualToString:@"iPhone10,3"])return@"iPhoneX";
    if([platform isEqualToString:@"iPhone10,6"])return@"iPhoneX";
    if([platform isEqualToString:@"iPod1,1"])return@"iPodTouchG";
    if([platform isEqualToString:@"iPod2,1"])return@"iPodTouch2G";
    if([platform isEqualToString:@"iPod3,1"])return@"iPodTouch3G";
    if([platform isEqualToString:@"iPod4,1"])return@"iPodTouch4G";
    if([platform isEqualToString:@"iPod5,1"])return@"iPodTouch5G";
    if([platform isEqualToString:@"iPad1,1"])return@"iPad1G";
    if([platform isEqualToString:@"iPad2,1"])return@"iPad2";
    if([platform isEqualToString:@"iPad2,2"])return@"iPad2";
    if([platform isEqualToString:@"iPad2,3"])return@"iPad2";
    if([platform isEqualToString:@"iPad2,4"])return@"iPad2";
    if([platform isEqualToString:@"iPad2,5"])return@"iPadMini1G";
    if([platform isEqualToString:@"iPad2,6"])return@"iPadMini1G";
    if([platform isEqualToString:@"iPad2,7"])return@"iPadMini1G";
    if([platform isEqualToString:@"iPad3,1"])return@"iPad3";
    if([platform isEqualToString:@"iPad3,2"])return@"iPad3";
    if([platform isEqualToString:@"iPad3,3"])return@"iPad3";
    if([platform isEqualToString:@"iPad3,4"])return@"iPad4";
    if([platform isEqualToString:@"iPad3,5"])return@"iPad4";
    if([platform isEqualToString:@"iPad3,6"])return@"iPad4";
    if([platform isEqualToString:@"iPad4,1"])return@"iPadAir";
    if([platform isEqualToString:@"iPad4,2"])return@"iPadAir";
    if([platform isEqualToString:@"iPad4,3"])return@"iPadAir";
    if([platform isEqualToString:@"iPad4,4"])return@"iPadMini2G";
    if([platform isEqualToString:@"iPad4,5"])return@"iPadMini2G";
    if([platform isEqualToString:@"iPad4,6"])return@"iPadMini2G";
    if([platform isEqualToString:@"iPad4,7"])return@"iPadMini3";
    if([platform isEqualToString:@"iPad4,8"])return@"iPadMini3";
    if([platform isEqualToString:@"iPad4,9"])return@"iPadMini3";
    if([platform isEqualToString:@"iPad5,1"])return@"iPadMini4";
    if([platform isEqualToString:@"iPad5,2"])return@"iPadMini4";
    if([platform isEqualToString:@"iPad5,3"])return@"iPadAir2";
    if([platform isEqualToString:@"iPad5,4"])return@"iPadAir2";
    if([platform isEqualToString:@"iPad6,3"])return@"iPadPro9.7";
    if([platform isEqualToString:@"iPad6,4"])return@"iPadPro9.7";
    if([platform isEqualToString:@"iPad6,7"])return@"iPadPro12.9";
    if([platform isEqualToString:@"iPad6,8"])return@"iPadPro12.9";
    if([platform isEqualToString:@"i386"])return@"iPhoneSimulator";
    if([platform isEqualToString:@"x86_64"])return@"iPhoneSimulator";
    return platform;

}


@end
