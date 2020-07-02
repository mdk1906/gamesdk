//
//  OrangeAPIParams.m
//  GreenFruit_CustomNativeByte_SDK
//
//  Created by shuangfei on 2018/2/1.
//  Copyright © 2018年 Hu. All rights reserved.
//

#import "OrangeAPIParams.h"
#import "OrangeYYModel.h"
#import "OrangeNSString+Utils.h"
#import "OrangeGreenFruitConfig.h"
#import "OrangeGreenFruitNetworking.h"
#import "OrangeMBManager.h"
#import "OrangeInfoArchive.h"
#import "OrangeGreenFruitIAPManager.h"
#import "OrangeGreenFruitConfigModel.h"

@interface OrangeAPIParams ()

@end

@implementation OrangeAPIParams


+(NSString*)signParams:(NSDictionary*)params{
    NSString *temp = @"";
    NSArray *allKeys = [[params allKeys] sortedArrayUsingSelector:@selector(compare:)];
    for(NSString *key in allKeys){//遍历所有的KEY
        NSString *value = [NSString stringWithFormat:@"%@",params[key]];
        if(![NSString isBlankString:value]){
            temp = [temp stringByAppendingFormat:@"%@=%@&",key,value];
        }
    }
    NSString *url = [temp substringToIndex:temp.length-1];
        
    //关键一笔  签名合成的字典需要符合json格式
    NSString * appidStr = [NSString stringWithFormat:@"%@",Appid];
    NSString *md5Appid = [NSString md5:appidStr];//AppID MD5加密
    NSString *md5Secret = [NSString md5:secretKey];//秘钥 加密
    temp = [NSString stringWithFormat:@"%@%@%@",url,md5Appid,md5Secret];
    return [NSString md5:temp];//返回拼接过并加密的字符串
}

#pragma mark -- 请求短信验证码
+(void)requestPhone:(NSString*)phone successblock:(RequestSuccessBlock) successblock failedblock:(RequestFailedBlock)failedBlock{
    NSString *url = [NSString stringWithFormat:@"%@/%@",baseUrl,getVertifyCode];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"userid"] = @"NULL";
    params[@"phone"] = phone;
    
    OrangeGreenFruitConfig *config = [OrangeGreenFruitConfig share_CustomNativeByte_Manager];
    config.appid = Appid;
    config.channelleve1 = Channelleve1;
    
    params[@"appid"] = config.appid;
    params[@"channellevel1"] = config.channelleve1;
    
    params[@"style"] = @"1";
    
    NSString * GreenFruitcid = [NSString stringWithFormat:@"%@",GreenFruitCid];
    if (GreenFruitCid != nil && ![GreenFruitcid isEqualToString:@""]) {
        params[@"cid"] = GreenFruitcid;
    }
    
    NSString *sign = [OrangeAPIParams signParams:params];
    params[@"sign"] = sign;
    [[OrangeGreenFruitNetworking shaerdInstance] postWithUrl:url cache:NO params:params progressBlock:^(int64_t bytesRead, int64_t totalBytes) {
        
    } successBlock:^(id response) {
        successblock(response);
    } failBlock:^(NSError *error) {
        failedBlock(error);
        
    }];
}

#pragma mark -- 请求用户名称
+(void)requestUsername:(NSString*)username successblock:(RequestSuccessBlock) successblock failedblock:(RequestFailedBlock)failedBlock{
    [OrangeMBManager showLoading];
    NSString *url = [NSString stringWithFormat:@"%@/%@",baseUrl,getVertifyCode2];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"userid"] = @"NULL";
    params[@"username"] = username;
    
    OrangeGreenFruitConfig *config = [OrangeGreenFruitConfig share_CustomNativeByte_Manager];
    config.appid = Appid;
    config.channelleve1 = Channelleve1;
    
    params[@"appid"] = config.appid;
    params[@"channellevel1"] = config.channelleve1;
    params[@"style"] = @"2";
    
    NSString * GreenFruitcid = [NSString stringWithFormat:@"%@",GreenFruitCid];
    if (GreenFruitCid != nil && ![GreenFruitcid isEqualToString:@""]) {
        params[@"cid"] = GreenFruitcid;
    }
    
    NSString *sign = [OrangeAPIParams signParams:params];
    params[@"sign"] = sign;
    [[OrangeGreenFruitNetworking shaerdInstance] postWithUrl:url cache:NO params:params progressBlock:^(int64_t bytesRead, int64_t totalBytes) {
        
    } successBlock:^(id response) {
        [OrangeMBManager hideAlert];
        successblock(response);
    } failBlock:^(NSError *error) {
        [OrangeMBManager hideAlert];
        failedBlock(error);
        
    }];
}

#pragma mark -- 快速注册
+(void)requestFastRegisterSuccessBlock:(RequestSuccessBlock) successblock failedblock:(RequestFailedBlock)failedBlock{
    [OrangeMBManager showLoading];
    NSString *url = [NSString stringWithFormat:@"%@/%@",baseUrl,registerFast];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    OrangeGreenFruitConfig *config = [OrangeGreenFruitConfig share_CustomNativeByte_Manager];
    config.channelleve1 = Channelleve1;
    config.channellevel2 = Channellevel2;
    config.appid = Appid;
    
    params[@"channellevel1"] = config.channelleve1;
    params[@"channellevel2"] = config.channellevel2;
    params[@"appid"] = config.appid;
    
    params[@"imei"] = UUID;
    params[@"openUDID"] = PasteBroadString;
    
    params[@"style"] = @"2";
    
    NSString * GreenFruitcid = [NSString stringWithFormat:@"%@",GreenFruitCid];
    if (GreenFruitCid != nil && ![GreenFruitcid isEqualToString:@""]) {
        params[@"cid"] = GreenFruitcid;
    }
    
    NSLog(@"拿到的字典参数:%@",params);
    
    
    NSString *sign = [OrangeAPIParams signParams:params];
    params[@"sign"] = sign;
    [[OrangeGreenFruitNetworking shaerdInstance] postWithUrl:url cache:NO params:params progressBlock:^(int64_t bytesRead, int64_t totalBytes) {
        
    } successBlock:^(id response) {
        [OrangeMBManager hideAlert];
        successblock(response);
    } failBlock:^(NSError *error) {
        [OrangeMBManager hideAlert];
        failedBlock(error);
    }];
}

#pragma mark -- 注册成功
+(void)requestFastRegisterStep2Username:(NSString*)username password:(NSString*)password SuccessBlock:(RequestSuccessBlock) successblock failedblock:(RequestFailedBlock)failedBlock{
    [OrangeMBManager showLoading];
    NSString *url = [NSString stringWithFormat:@"%@/%@",baseUrl,registerFast];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *md5pwd = [NSString md5:[NSString md5:password]] ;
    params[@"username"] = username;
    params[@"password"] = md5pwd;
    
    OrangeGreenFruitConfig *config = [OrangeGreenFruitConfig share_CustomNativeByte_Manager];
    config.channelleve1 = Channelleve1;
    config.channellevel2 = Channellevel2;
    config.appid = Appid;
    
    params[@"channellevel1"] = config.channelleve1;
    params[@"channellevel2"] = config.channellevel2;
    params[@"appid"] = config.appid;
    
    NSString * GreenFruitcid = [NSString stringWithFormat:@"%@",GreenFruitCid];
    if (GreenFruitCid != nil && ![GreenFruitcid isEqualToString:@""]) {
        params[@"cid"] = GreenFruitcid;
    }
    
    params[@"imei"] = UUID;
    params[@"openUDID"] = PasteBroadString;

    params[@"style"] = @"1";

    NSString *sign = [OrangeAPIParams signParams:params];
    params[@"sign"] = sign;
    [[OrangeGreenFruitNetworking shaerdInstance] postWithUrl:url cache:NO params:params progressBlock:^(int64_t bytesRead, int64_t totalBytes) {
        
    } successBlock:^(id response) {
        [OrangeMBManager hideAlert];

        successblock(response);
    } failBlock:^(NSError *error) {
        [OrangeMBManager hideAlert];
        failedBlock(error);
    }];
}

#pragma mark -- 修改密码
+(void)requestUpdatePasswordUsername:(NSString*)username password:(NSString*)password vcode:(NSString*)vcode successBlock:(RequestSuccessBlock) successblock failedblock:(RequestFailedBlock)failedBlock{
    [OrangeMBManager showLoading];
    NSString *url = [NSString stringWithFormat:@"%@/%@",baseUrl,updatePassword];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *md5pwd = [NSString md5:[NSString md5:password]] ;
    
    OrangeGreenFruitConfig *config = [OrangeGreenFruitConfig share_CustomNativeByte_Manager];
    config.channelleve1 = Channelleve1;
    config.appid = Appid;
    
    params[@"appid"] = config.appid;
    params[@"channellevel1"] = config.channelleve1;
    
    params[@"username"] = username;
    params[@"vcode"] = vcode;
    params[@"password"] = md5pwd;
    
    NSString * GreenFruitcid = [NSString stringWithFormat:@"%@",GreenFruitCid];
    if (GreenFruitCid != nil && ![GreenFruitcid isEqualToString:@""]) {
        params[@"cid"] = GreenFruitcid;
    }
    
    NSString *sign = [OrangeAPIParams signParams:params];
    params[@"sign"] = sign;
    [[OrangeGreenFruitNetworking shaerdInstance] postWithUrl:url cache:NO params:params progressBlock:^(int64_t bytesRead, int64_t totalBytes) {
        
    } successBlock:^(id response) {
        [OrangeMBManager hideAlert];
        successblock(response);
    } failBlock:^(NSError *error) {
        [OrangeMBManager hideAlert];
        failedBlock(error);
    }];
}

#pragma mark -- 注册进入游戏
//这个接口暂时没有用到
+(void)requestPhone:(NSString*)phone code:(NSString*)code password:(NSString*)password successBlock:(RequestSuccessBlock) successblock failedblock:(RequestFailedBlock)failedBlock{
    [OrangeMBManager showLoading];
    NSString *url = [NSString stringWithFormat:@"%@/%@",baseUrl,registers];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *md5pwd = [NSString md5:[NSString md5:password]] ;
    params[@"username"] = phone;
    params[@"password"] = md5pwd;
    params[@"vcode"] = code;
    
    OrangeGreenFruitConfig *config = [OrangeGreenFruitConfig share_CustomNativeByte_Manager];
    config.channelleve1 = Channelleve1;
    config.channellevel2 = Channellevel2;
    config.appid = Appid;
    
    params[@"channellevel1"] = config.channelleve1;
    params[@"channellevel2"] = config.channellevel2;
    params[@"imei"] = UUID;
    params[@"openUDID"] = PasteBroadString;

    params[@"appid"] = config.appid;
    params[@"style"] = @"1";
    
    NSString * GreenFruitcid = [NSString stringWithFormat:@"%@",GreenFruitCid];
    if (GreenFruitCid != nil && ![GreenFruitcid isEqualToString:@""]) {
        params[@"cid"] = GreenFruitcid;
    }
    
    NSString *sign = [OrangeAPIParams signParams:params];
    params[@"sign"] = sign;
    [[OrangeGreenFruitNetworking shaerdInstance] postWithUrl:url cache:NO params:params progressBlock:^(int64_t bytesRead, int64_t totalBytes) {
        
    } successBlock:^(id response) {
        [OrangeMBManager hideAlert];
        successblock(response);
    } failBlock:^(NSError *error) {
        [OrangeMBManager hideAlert];
        failedBlock(error);
    }];
}

#pragma mark -- 进入游戏  登录方法
+(void)requestLogin:(NSString*)username password:(NSString*)password SuccessBlock:(RequestSuccessBlock) successblock failedblock:(RequestFailedBlock)failedBlock{
    [OrangeMBManager showLoading];
    NSString *url = [NSString stringWithFormat:@"%@/%@",baseUrl,login];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *md5pwd = [NSString md5:[NSString md5:password]] ;
    params[@"username"] = username;
    params[@"password"] = md5pwd;
    
    OrangeGreenFruitConfig *config = [OrangeGreenFruitConfig share_CustomNativeByte_Manager];
    config.channelleve1 = Channelleve1;
    config.channellevel2 = Channellevel2;
    config.appid = Appid;
    
    params[@"channellevel1"] = config.channelleve1;
    params[@"channellevel2"] = config.channellevel2;
    params[@"imei"] = UUID;
    params[@"openUDID"] = PasteBroadString;

    params[@"appid"] = config.appid;
    
    params[@"style"] = @"1";
    params[@"devicetype"] = DeviceName;
    
    NSString * GreenFruitcid = [NSString stringWithFormat:@"%@",GreenFruitCid];
    if (GreenFruitCid != nil && ![GreenFruitcid isEqualToString:@""]) {
        params[@"cid"] = GreenFruitcid;
    }

    NSString *sign = [OrangeAPIParams signParams:params];
    params[@"sign"] = sign;
    
    
    [[OrangeGreenFruitNetworking shaerdInstance] postWithUrl:url cache:NO params:params progressBlock:^(int64_t bytesRead, int64_t totalBytes) {
        
    } successBlock:^(id response) {
        [OrangeMBManager hideAlert];
        successblock(response);
    } failBlock:^(NSError *error) {
        [OrangeMBManager hideAlert];
        failedBlock(error);
    }];
}
//***新增
+(void)requestPhoneLogin:(NSString*)username password:(NSString*)password SuccessBlock:(RequestSuccessBlock) successblock failedblock:(RequestFailedBlock)failedBlock{
    [OrangeMBManager showLoading];
    NSString *url = [NSString stringWithFormat:@"%@/%@",baseUrl,login];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"username"] = username;
    params[@"password"] = password;//手机号登录的密码，不进行两次MD5加密
    
    OrangeGreenFruitConfig *config = [OrangeGreenFruitConfig share_CustomNativeByte_Manager];
    config.channelleve1 = Channelleve1;
    config.channellevel2 = Channellevel2;
    config.appid = Appid;
    
    params[@"channellevel1"] = config.channelleve1;
    params[@"channellevel2"] = config.channellevel2;
    params[@"imei"] = UUID;
    params[@"openUDID"] = PasteBroadString;

    params[@"appid"] = config.appid;
    
    
    params[@"style"] = @"1";
    params[@"devicetype"] = DeviceName;
    
    NSString * GreenFruitcid = [NSString stringWithFormat:@"%@",GreenFruitCid];
    if (GreenFruitCid != nil && ![GreenFruitcid isEqualToString:@""]) {
        params[@"cid"] = GreenFruitcid;
    }

    NSString *sign = [OrangeAPIParams signParams:params];
    params[@"sign"] = sign;
    [[OrangeGreenFruitNetworking shaerdInstance] postWithUrl:url cache:NO params:params progressBlock:^(int64_t bytesRead, int64_t totalBytes) {
        
    } successBlock:^(id response) {
        [OrangeMBManager hideAlert];
        successblock(response);
    } failBlock:^(NSError *error) {
        [OrangeMBManager hideAlert];
        failedBlock(error);
    }];
}


#pragma mark -- 检查是否绑定手机号
+(void)requestCheckPhoneCondition:(NSString*)condition SuccessBlock:(RequestSuccessBlock) successblock failedblock:(RequestFailedBlock)failedBlock{
    [OrangeMBManager showLoading];
    NSString *url = [NSString stringWithFormat:@"%@/%@",baseUrl,checkPhone];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"condition"] = condition;
    OrangeGreenFruitConfig *config = [OrangeGreenFruitConfig share_CustomNativeByte_Manager];
    config.appid = Appid;
    
    params[@"appid"] = config.appid;
    params[@"style"] = @"2";
    
    NSString * GreenFruitcid = [NSString stringWithFormat:@"%@",GreenFruitCid];
    if (GreenFruitCid != nil && ![GreenFruitcid isEqualToString:@""]) {
        params[@"cid"] = GreenFruitcid;
    }
    
    NSString *sign = [OrangeAPIParams signParams:params];
    params[@"sign"] = sign;
    [[OrangeGreenFruitNetworking shaerdInstance] postWithUrl:url cache:NO params:params progressBlock:^(int64_t bytesRead, int64_t totalBytes) {
        
    } successBlock:^(id response) {
        [OrangeMBManager hideAlert];
        successblock(response);
    } failBlock:^(NSError *error) {
        [OrangeMBManager hideAlert];
        failedBlock(error);
    }];
}

#pragma mark -- 退出登录
+(void)requestLogoutUserId:(NSString*)userId SuccessBlock:(RequestSuccessBlock) successblock failedblock:(RequestFailedBlock)failedBlock{
    [OrangeMBManager showLoading];
    NSString *url = [NSString stringWithFormat:@"%@/%@",baseUrl,logout];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"userId"] = userId;
    
    OrangeGreenFruitConfig *config = [OrangeGreenFruitConfig share_CustomNativeByte_Manager];
    config.channelleve1 = Channelleve1;
    config.appid = Appid;
    params[@"channellevel1"] = config.channelleve1;
    params[@"appid"] = config.appid;
    params[@"zonename"] = @"";
    
    NSString * GreenFruitcid = [NSString stringWithFormat:@"%@",GreenFruitCid];
    if (GreenFruitCid != nil && ![GreenFruitcid isEqualToString:@""]) {
        params[@"cid"] = GreenFruitcid;
    }
    
    NSString *sign = [OrangeAPIParams signParams:params];
    params[@"sign"] = sign;
    [[OrangeGreenFruitNetworking shaerdInstance] postWithUrl:url cache:NO params:params progressBlock:^(int64_t bytesRead, int64_t totalBytes) {
        
    } successBlock:^(id response) {
        [OrangeMBManager hideAlert];
        successblock(response);
    } failBlock:^(NSError *error) {
        [OrangeMBManager hideAlert];
        failedBlock(error);
    }];
}

#pragma mark 设置角色
+(void)requestSettingRole:(GreenFruit_CustomNativeByte_SDKRoleData*)roleData SuccessBlock:(RequestSuccessBlock) successblock failedblock:(RequestFailedBlock)failedBlock{
    NSString *url = [NSString stringWithFormat:@"%@/%@",baseUrl,settingRole];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"userid"] = [OrangeInfoArchive getUserId];
    params[@"roleid"] = roleData.roleId;
    params[@"rolename"] = roleData.roleName;
    params[@"rolelevel"] = roleData.roleLevel;
    params[@"zoneid"] = roleData.zoneId;
    params[@"zonename"] = roleData.zoneName;
    
    OrangeGreenFruitConfig *config = [OrangeGreenFruitConfig share_CustomNativeByte_Manager];
    config.channelleve1 = Channelleve1;
    config.appid = Appid;
    params[@"channellevel1"] = config.channelleve1;
    params[@"appid"] = config.appid;
    
    NSString * GreenFruitcid = [NSString stringWithFormat:@"%@",GreenFruitCid];
    if (GreenFruitCid != nil && ![GreenFruitcid isEqualToString:@""]) {
        params[@"cid"] = GreenFruitcid;
    }
    
    NSString *sign = [OrangeAPIParams signParams:params];
    params[@"sign"] = sign;
    [[OrangeGreenFruitNetworking shaerdInstance] postWithUrl:url cache:NO params:params progressBlock:^(int64_t bytesRead, int64_t totalBytes) {
        
    } successBlock:^(id response) {
        successblock(response);
    } failBlock:^(NSError *error) {
        [OrangeMBManager hideAlert];
        failedBlock(error);
    }];
}

#pragma mark -- 调用实名认证接口
+(void)requestIdentifyVertifyUserId:(NSString*)userid name:(NSString*)name identityno:(NSString*)identityno
                       successblock:(RequestSuccessBlock)successblock failedblock:(RequestFailedBlock)failedBlock{
    NSString *url = [NSString stringWithFormat:@"%@/%@",baseUrl,identifyVertify];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    OrangeGreenFruitConfig *config = [OrangeGreenFruitConfig share_CustomNativeByte_Manager];
    config.appid = Appid;
    config.channelleve1 = Channelleve1;
    
    params[@"appid"] = config.appid;
    params[@"channellevel1"] = config.channelleve1;
    
    params[@"userid"] = userid;
    params[@"name"] = name;
    params[@"identityno"] = identityno;
    
    NSString * GreenFruitcid = [NSString stringWithFormat:@"%@",GreenFruitCid];
    if (GreenFruitCid != nil && ![GreenFruitcid isEqualToString:@""]) {
        params[@"cid"] = GreenFruitcid;
    }
    
    NSString *sign = [OrangeAPIParams signParams:params];
    params[@"sign"] = sign;
    [[OrangeGreenFruitNetworking shaerdInstance] postWithUrl:url cache:NO params:params progressBlock:^(int64_t bytesRead, int64_t totalBytes) {
        
    } successBlock:^(id response) {
        [OrangeMBManager hideAlert];
        successblock(response);
    } failBlock:^(NSError *error) {
        [OrangeMBManager hideAlert];
        failedBlock(error);
    }];
}

#pragma mark -- 客服电话设置
+(void)requestQQSuccessBlock:(RequestSuccessBlock)successblock failedblock:(RequestFailedBlock)failedBlock{
    
}

#pragma mark -- 判断是否实名认证
+(void)requestCheckIdentifyUserid:(NSString*)userid successblock:(RequestSuccessBlock)successblock failedblock:(RequestFailedBlock)failedBlock{
    NSString *url = [NSString stringWithFormat:@"%@/%@",baseUrl,checkIdentify];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    OrangeGreenFruitConfig *config = [OrangeGreenFruitConfig share_CustomNativeByte_Manager];
    config.appid = Appid;
    config.channelleve1 = Channelleve1;
    
    params[@"appid"] = config.appid;
    params[@"channellevel1"] = config.channelleve1;
    params[@"userid"] = userid;
    
    NSString * GreenFruitcid = [NSString stringWithFormat:@"%@",GreenFruitCid];
    if (GreenFruitCid != nil && ![GreenFruitcid isEqualToString:@""]) {
        params[@"cid"] = GreenFruitcid;
    }
    
    NSString *sign = [OrangeAPIParams signParams:params];
    params[@"sign"] = sign;
    [[OrangeGreenFruitNetworking shaerdInstance] postWithUrl:url cache:NO params:params progressBlock:^(int64_t bytesRead, int64_t totalBytes) {
        
    } successBlock:^(id response) {
        [OrangeMBManager hideAlert];
        successblock(response);
    } failBlock:^(NSError *error) {
        [OrangeMBManager hideAlert];
        failedBlock(error);
    }];
}

//*** 新增 判断实名认证接口 在发起平台支付前使用
+(void)requestNewCheckIdentifyUserid:(NSString*)userid successblock:(RequestSuccessBlock)successblock failedblock:(RequestFailedBlock)failedBlock{
    NSString *url = [NSString stringWithFormat:@"%@/%@",baseUrl,newIdentifyVertify];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    OrangeGreenFruitConfig *config = [OrangeGreenFruitConfig share_CustomNativeByte_Manager];
    config.appid = Appid;
    config.channelleve1 = Channelleve1;
    
    params[@"appid"] = config.appid;
    params[@"channellevel1"] = config.channelleve1;
    params[@"userid"] = userid;
    
    NSString * GreenFruitcid = [NSString stringWithFormat:@"%@",GreenFruitCid];
    if (GreenFruitCid != nil && ![GreenFruitcid isEqualToString:@""]) {
        params[@"cid"] = GreenFruitcid;
    }
    
    NSString *sign = [OrangeAPIParams signParams:params];
    params[@"sign"] = sign;
    [[OrangeGreenFruitNetworking shaerdInstance] postWithUrl:url cache:NO params:params progressBlock:^(int64_t bytesRead, int64_t totalBytes) {
        
    } successBlock:^(id response) {
        [OrangeMBManager hideAlert];
        successblock(response);
    } failBlock:^(NSError *error) {
        [OrangeMBManager hideAlert];
        failedBlock(error);
    }];
}


#pragma mark -- 获取礼包列表接口
+(void)requestGiftListSuccessblock:(RequestSuccessBlock)successblock failedblock:(RequestFailedBlock)failedBlock{
    NSString *url = [NSString stringWithFormat:@"%@/%@",baseUrl,giftList];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    OrangeGreenFruitConfig *config = [OrangeGreenFruitConfig share_CustomNativeByte_Manager];
    config.appid = Appid;
    config.channelleve1 = Channelleve1;
    
    params[@"appid"] = config.appid;
    params[@"channellevel1"] = config.channelleve1;
    
    NSString * GreenFruitcid = [NSString stringWithFormat:@"%@",GreenFruitCid];
    if (GreenFruitCid != nil && ![GreenFruitcid isEqualToString:@""]) {
        params[@"cid"] = GreenFruitcid;
    }
    
    NSString *sign = [OrangeAPIParams signParams:params];
    params[@"sign"] = sign;
    [[OrangeGreenFruitNetworking shaerdInstance] postWithUrl:url cache:NO params:params progressBlock:^(int64_t bytesRead, int64_t totalBytes) {
        
    } successBlock:^(id response) {
        [OrangeMBManager hideAlert];
        successblock(response);
    } failBlock:^(NSError *error) {
        [OrangeMBManager hideAlert];
        failedBlock(error);
    }];
}

#pragma mark -- 客服
+(void)requestSettingPhoneSuccessblock:(RequestSuccessBlock)successblock failedblock:(RequestFailedBlock)failedBlock{
    NSString *url = [NSString stringWithFormat:@"%@/%@",baseUrl,settingPhone];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    OrangeGreenFruitConfig *config = [OrangeGreenFruitConfig share_CustomNativeByte_Manager];
    config.appid = Appid;
    config.channelleve1 = Channelleve1;
    
    params[@"appid"] = config.appid;
    params[@"channellevel1"] = config.channelleve1;
    
    NSString * GreenFruitcid = [NSString stringWithFormat:@"%@",GreenFruitCid];
    if (GreenFruitCid != nil && ![GreenFruitcid isEqualToString:@""]) {
        params[@"cid"] = GreenFruitcid;
    }
    
    NSString *sign = [OrangeAPIParams signParams:params];
    params[@"sign"] = sign;
    [[OrangeGreenFruitNetworking shaerdInstance] postWithUrl:url cache:NO params:params progressBlock:^(int64_t bytesRead, int64_t totalBytes) {
        
    } successBlock:^(id response) {
        [OrangeMBManager hideAlert];
        successblock(response);
    } failBlock:^(NSError *error) {
        [OrangeMBManager hideAlert];
        failedBlock(error);
    }];
}

#pragma mark -- 客服
+(void)requestSettingQQSuccessblock:(RequestSuccessBlock)successblock failedblock:(RequestFailedBlock)failedBlock{
    NSString *url = [NSString stringWithFormat:@"%@/%@",baseUrl,settingQQ];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    OrangeGreenFruitConfig *config = [OrangeGreenFruitConfig share_CustomNativeByte_Manager];
    config.appid = Appid;
    config.channelleve1 = Channelleve1;
    
    params[@"appid"] = config.appid;
    params[@"channellevel1"] = config.channelleve1;
    
    NSString * GreenFruitcid = [NSString stringWithFormat:@"%@",GreenFruitCid];
    if (GreenFruitCid != nil && ![GreenFruitcid isEqualToString:@""]) {
        params[@"cid"] = GreenFruitcid;
    }
    
    NSString *sign = [OrangeAPIParams signParams:params];
    params[@"sign"] = sign;
    [[OrangeGreenFruitNetworking shaerdInstance] postWithUrl:url cache:NO params:params progressBlock:^(int64_t bytesRead, int64_t totalBytes) {
        
    } successBlock:^(id response) {
        [OrangeMBManager hideAlert];
        successblock(response);
    } failBlock:^(NSError *error) {
        [OrangeMBManager hideAlert];
        failedBlock(error);
    }];
}

#pragma mark -- 领取礼包
+(void)requestGiftUserId:(NSString*)userId awardid:(NSString*)awardid Successblock:(RequestSuccessBlock)successblock failedblock:(RequestFailedBlock)failedBlock{
    
    NSString *url = [NSString stringWithFormat:@"%@/%@",baseUrl,getGift];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    OrangeGreenFruitConfig *config = [OrangeGreenFruitConfig share_CustomNativeByte_Manager];
    config.appid = Appid;
    config.channelleve1 = Channelleve1;
    
    params[@"appid"] = config.appid;
    params[@"channellevel1"] = config.channelleve1;
    params[@"userid"] = userId;
    params[@"awardid"] = awardid;
    
    NSString * GreenFruitcid = [NSString stringWithFormat:@"%@",GreenFruitCid];
    if (GreenFruitCid != nil && ![GreenFruitcid isEqualToString:@""]) {
        params[@"cid"] = GreenFruitcid;
    }
    
    NSString *sign = [OrangeAPIParams signParams:params];
    params[@"sign"] = sign;
    [[OrangeGreenFruitNetworking shaerdInstance] postWithUrl:url cache:NO params:params progressBlock:^(int64_t bytesRead, int64_t totalBytes) {
        
    } successBlock:^(id response) {
        [OrangeMBManager hideAlert];
        successblock(response);
    } failBlock:^(NSError *error) {
        [OrangeMBManager hideAlert];
        failedBlock(error);
    }];
}

#pragma mark -- 修改密码
+(void)requestUpdatePassword:(NSString*)password username:(NSString*)username vcode:(NSString*)vcode
                Successblock:(RequestSuccessBlock)successblock failedblock:(RequestFailedBlock)failedBlock{
    NSString *url = [NSString stringWithFormat:@"%@/%@",baseUrl,updatePassword];
    NSString *md5pwd = [NSString md5:[NSString md5:password]] ;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    OrangeGreenFruitConfig *config = [OrangeGreenFruitConfig share_CustomNativeByte_Manager];
    config.appid = Appid;
    config.channelleve1 = Channelleve1;
    
    params[@"appid"] = config.appid;
    params[@"channellevel1"] = config.channelleve1;
    
    params[@"username"] = username;
    params[@"vcode"] = vcode;
    params[@"password"] = md5pwd;
    
    NSString * GreenFruitcid = [NSString stringWithFormat:@"%@",GreenFruitCid];
    if (GreenFruitCid != nil && ![GreenFruitcid isEqualToString:@""]) {
        params[@"cid"] = GreenFruitcid;
    }
    
    NSString *sign = [OrangeAPIParams signParams:params];
    params[@"sign"] = sign;
    [[OrangeGreenFruitNetworking shaerdInstance] postWithUrl:url cache:NO params:params progressBlock:^(int64_t bytesRead, int64_t totalBytes) {
        
    } successBlock:^(id response) {
        [OrangeMBManager hideAlert];
        successblock(response);
    } failBlock:^(NSError *error) {
        [OrangeMBManager hideAlert];
        failedBlock(error);
    }];
    
}
//***  新增 手机号注册接口
+(void)requestForPhoneRegistionMethod:(NSString *)phoneNumber withVcode:(NSString *)code SuccessBlock:(RequestSuccessBlock)successblock failedBlock:(RequestFailedBlock)failedblock{
    NSString *url = [NSString stringWithFormat:@"%@/%@",baseUrl,phoneNumberRegist];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    OrangeGreenFruitConfig *config = [OrangeGreenFruitConfig share_CustomNativeByte_Manager];
    config.appid = Appid;
    config.channelleve1 = Channelleve1;
    config.channellevel2 = Channellevel2;
    
    params[@"appid"] = config.appid;
    params[@"channellevel1"] = config.channelleve1;
    params[@"channellevel2"] = config.channellevel2;
    params[@"phone"] = phoneNumber;
    params[@"vcode"] = code;
    
    NSString * GreenFruitcid = [NSString stringWithFormat:@"%@",GreenFruitCid];
    if (GreenFruitCid != nil && ![GreenFruitcid isEqualToString:@""]) {
        params[@"cid"] = GreenFruitcid;
    }

    params[@"imei"] = UUID;
    params[@"openUDID"] = PasteBroadString;

    NSString *sign = [OrangeAPIParams signParams:params];
    params[@"sign"] = sign;
    
    [[OrangeGreenFruitNetworking shaerdInstance] postWithUrl:url cache:NO params:params progressBlock:^(int64_t bytesRead, int64_t totalBytes) {
        
    } successBlock:^(id response) {
        [OrangeMBManager hideAlert];
        successblock(response);
    } failBlock:^(NSError *error) {
        [OrangeMBManager hideAlert];
        failedblock(error);
    }];
}

//*** 新增验证找回密码短信
+(void)requestCheckComfirmPhone:(NSString *)phoneNumer withConfirmCode:(NSString *)code withStyle:(NSString *)style SuccessBlock:(RequestSuccessBlock)successblock failedBlock:(RequestFailedBlock)failedblock{
    NSString *url = [NSString stringWithFormat:@"%@/%@",baseUrl,checkConfirmCode];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"phone"] = phoneNumer;
    
    OrangeGreenFruitConfig *config = [OrangeGreenFruitConfig share_CustomNativeByte_Manager];
    config.appid = Appid;
    config.channelleve1 = Channelleve1;
    config.channellevel2 = Channellevel2;
    
    params[@"appid"] = config.appid;
    params[@"channellevel1"] = config.channelleve1;
    params[@"channellevel2"] = config.channellevel2;
    params[@"vcode"] = code;
    params[@"style"] = style;
    
    NSString * GreenFruitcid = [NSString stringWithFormat:@"%@",GreenFruitCid];
    if (GreenFruitCid != nil && ![GreenFruitcid isEqualToString:@""]) {
        params[@"cid"] = GreenFruitcid;
    }
    
    NSString *sign = [OrangeAPIParams signParams:params];
    params[@"sign"] = sign;
    
    [[OrangeGreenFruitNetworking shaerdInstance] postWithUrl:url cache:NO params:params progressBlock:^(int64_t bytesRead, int64_t totalBytes) {
        
    } successBlock:^(id response) {
        [OrangeMBManager hideAlert];
        successblock(response);
    } failBlock:^(NSError *error) {
        [OrangeMBManager hideAlert];
        failedblock(error);
        
    }];
    
}

//*** 新增 修改密码接口
+(void)requestForModifyPassword:(NSString *)password andUserName:(NSString *)userName SuccessBlock:(RequestSuccessBlock)successblock failedBlock:(RequestFailedBlock)failedblock{
    NSString *url = [NSString stringWithFormat:@"%@/%@",baseUrl,modifyNewPassword];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    OrangeGreenFruitConfig *config = [OrangeGreenFruitConfig share_CustomNativeByte_Manager];
    config.appid = Appid;
    config.channelleve1 = Channelleve1;
    
    params[@"appid"] = config.appid;
    params[@"channellevel1"] = config.channelleve1;
    
    NSString * userNameString = [OrangeInfoArchive getAccountName];
    params[@"username"] = userName;
    NSString *md5pwd = [NSString md5:[NSString md5:password]] ;
    params[@"password"] = md5pwd;
    
    NSString * GreenFruitcid = [NSString stringWithFormat:@"%@",GreenFruitCid];
    if (GreenFruitCid != nil && ![GreenFruitcid isEqualToString:@""]) {
        params[@"cid"] = GreenFruitcid;
    }
    
    NSString *sign = [OrangeAPIParams signParams:params];
    params[@"sign"] = sign;
    [[OrangeGreenFruitNetworking shaerdInstance] postWithUrl:url cache:NO params:params progressBlock:^(int64_t bytesRead, int64_t totalBytes) {
        
    } successBlock:^(id response) {
        [OrangeMBManager hideAlert];
        successblock(response);
    } failBlock:^(NSError *error) {
        [OrangeMBManager hideAlert];
        failedblock(error);
    }];
}

//*** 新增 获取个人中心token
+(void)requestForUserCenterTokenwithSuccessBlock:(RequestSuccessBlock)successblock failedBlock:(RequestFailedBlock)failedblock{
    NSString *url = [NSString stringWithFormat:@"%@/%@",baseUrl,getUserCenterToken];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"userid"] = [OrangeInfoArchive getUserId];
    
    OrangeGreenFruitConfig *config = [OrangeGreenFruitConfig share_CustomNativeByte_Manager];
    config.appid = Appid;
    config.channelleve1 = Channelleve1;
    config.channellevel2 = Channellevel2;
    
    params[@"channellevel1"] = config.channelleve1;
    params[@"channellevel2"] = config.channellevel2;
    params[@"appid"] = config.appid;
    
    params[@"from"] = @"sdk";
    params[@"to"] = @"UserCenter";
    params[@"imei"] = UUID;
    params[@"openUDID"] = PasteBroadString;

    NSString * GreenFruitcid = [NSString stringWithFormat:@"%@",GreenFruitCid];
    if (GreenFruitCid != nil && ![GreenFruitcid isEqualToString:@""]) {
        params[@"cid"] = GreenFruitcid;
    }
    
    NSString *sign = [OrangeAPIParams signParams:params];
    params[@"sign"] = sign;
    
    [[OrangeGreenFruitNetworking shaerdInstance] postWithUrl:url cache:NO params:params progressBlock:^(int64_t bytesRead, int64_t totalBytes) {
        
    } successBlock:^(id response) {
        [OrangeMBManager hideAlert];
        successblock(response);
    } failBlock:^(NSError *error) {
        [OrangeMBManager hideAlert];
        failedblock(error);
    }];
}

#pragma mark --- 初始化接口，获取悬浮球图片
+(void)requestActiveMethodWithVersions:(NSString *)versions localIp:(NSString *)localIp  sysTermVersion:(NSString *)os  Devicetype:(NSString *)devicetype pasteboard:(NSString *)pasteboard appKey:(NSString *)appKey withSuccessBlock:(RequestSuccessBlock)successblock faildBlock:(RequestFailedBlock)failedblock{
    NSString *url = [NSString stringWithFormat:@"%@/%@",baseUrl,getFloatballIcon];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    
    OrangeGreenFruitConfig *config = [OrangeGreenFruitConfig share_CustomNativeByte_Manager];
    config.deviceType = DeviceName;
    config.channelleve1 = Channelleve1;
    config.channellevel2 = Channellevel2;
    config.appid = Appid;
    
//    OrangeGreenFruitConfigModel  * config = [OrangeGreenFruitConfigModel share_CustomNativeByte_Manager];
//    [OrangeGreenFruitConfigModel share_CustomNativeByte_Manager].channelLevel1 = Channelleve1;
//    [OrangeGreenFruitConfigModel share_CustomNativeByte_Manager].channelLevel2 = Channellevel2;
//    [OrangeGreenFruitConfigModel share_CustomNativeByte_Manager].appid = Appid;
    
    params[@"channellevel1"] = config.channelleve1;
    params[@"channellevel2"] = config.channellevel2;
    params[@"appid"] = config.appid;
    
    params[@"imei"] = UUID;
    params[@"openUDID"] = PasteBroadString;

    params[@"version"] = versions;
    params[@"localip"] = localIp;
    params[@"os"] = os;
    params[@"device"] = devicetype;
    params[@"pasteboard"] = pasteboard;
    params[@"key"] = appKey;
    
    NSString *sign = [OrangeAPIParams signParams:params];
    params[@"sign"] = sign;
    
    [[OrangeGreenFruitNetworking shaerdInstance] postWithUrl:url cache:NO params:params progressBlock:^(int64_t bytesRead, int64_t totalBytes) {
        
        
    } successBlock:^(id response) {

        [OrangeMBManager hideAlert];
        successblock(response);
    } failBlock:^(NSError *error) {

        [OrangeMBManager hideAlert];
        failedblock(error);
    }];
    
}

#pragma mark -- 封装的post请求
+(void)postRequestMethodPakagedwithSuccessBlock:(RequestSuccessBlock)successblock faildBlock:(RequestFailedBlock)failedblock{
    NSString * firstAddress = @"http://192.168.1.185:8081";
    /*
     第一个接口地址 /GreenFruitinstall/wwwroot
     第二个接口地址  /GreenFruitinstall/wap
     */
    NSString * address = @"/GreenFruitinstall/wwwroot";
    NSString * url = [NSString stringWithFormat:@"%@%@",firstAddress,address];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    //第一个接口参数
    params[@"ctype"] = @"1";
    params[@"appkey"] = @"BEBKFEE6R6FH6F";
    params[@"channel"] = @"mhy001";
    
    
    //第二个接口参数
//    params[@"channelCode"] = @"";
//    params[@"sw"] = @"375";
//    params[@"sh"] = @"812";

    
    [[OrangeGreenFruitNetworking shaerdInstance] postWithUrl:url cache:NO params:params progressBlock:^(int64_t bytesRead, int64_t totalBytes) {
        
    } successBlock:^(id response) {
        [OrangeMBManager hideAlert];
        successblock(response);
    } failBlock:^(NSError *error) {
        [OrangeMBManager hideAlert];
        failedblock(error);
    }];
    
}


#pragma mark -- 绑定手机
+ (void)requestBindPhone:(NSString*)phone vcode:(NSString*)vcode Successblock:(RequestSuccessBlock)successblock failedblock:(RequestFailedBlock)failedBlock{
    NSString *url = [NSString stringWithFormat:@"%@/%@",baseUrl,bindPhone];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"phone"] = phone;
    
    OrangeGreenFruitConfig *config = [OrangeGreenFruitConfig share_CustomNativeByte_Manager];
    config.appid = Appid;
    config.channelleve1 = Channelleve1;
    
    params[@"appid"] = config.appid;
    params[@"channellevel1"] = config.channelleve1;
    
    params[@"userid"] = [OrangeInfoArchive getUserId];
    params[@"vcode"] = vcode;
    
    NSString * GreenFruitcid = [NSString stringWithFormat:@"%@",GreenFruitCid];
    if (GreenFruitCid != nil && ![GreenFruitcid isEqualToString:@""]) {
        params[@"cid"] = GreenFruitcid;
    }
    
    NSString *sign = [OrangeAPIParams signParams:params];
    params[@"sign"] = sign;
    [[OrangeGreenFruitNetworking shaerdInstance] postWithUrl:url cache:NO params:params progressBlock:^(int64_t bytesRead, int64_t totalBytes) {
        
    } successBlock:^(id response) {
        [OrangeMBManager hideAlert];
        successblock(response);
    } failBlock:^(NSError *error) {
        [OrangeMBManager hideAlert];
        failedBlock(error);
    }];
}

#pragma mark -- 更换绑定手机
+ (void)requestChangePhone:(NSString*)phone vcode:(NSString*)vcode Successblock:(RequestSuccessBlock)successblock failedblock:(RequestFailedBlock)failedBlock{
    NSString *url = [NSString stringWithFormat:@"%@/%@",baseUrl,changebindPhone];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"phone"] = phone;
    
    OrangeGreenFruitConfig *config = [OrangeGreenFruitConfig share_CustomNativeByte_Manager];
    config.appid = Appid;
    config.channelleve1 = Channelleve1;
    
    params[@"appid"] = config.appid;
    params[@"channellevel1"] = config.channelleve1;
    
    params[@"userid"] = [OrangeInfoArchive getUserId];
    params[@"vcode"] = vcode;
    
    NSString * GreenFruitcid = [NSString stringWithFormat:@"%@",GreenFruitCid];
    if (GreenFruitCid != nil && ![GreenFruitcid isEqualToString:@""]) {
        params[@"cid"] = GreenFruitcid;
    }
    
    NSString *sign = [OrangeAPIParams signParams:params];
    params[@"sign"] = sign;
    [[OrangeGreenFruitNetworking shaerdInstance] postWithUrl:url cache:NO params:params progressBlock:^(int64_t bytesRead, int64_t totalBytes) {
        
    } successBlock:^(id response) {
        [OrangeMBManager hideAlert];
        successblock(response);
    } failBlock:^(NSError *error) {
        [OrangeMBManager hideAlert];
        failedBlock(error);
    }];
}



#pragma mark -- ++++++++++++++++++++++++++++
+(void)requestCenterCheckPhoneCondition:(NSString*)condition SuccessBlock:(RequestSuccessBlock) successblock failedblock:(RequestFailedBlock)failedBlock{
    [OrangeMBManager showLoading];
    NSString *url = [NSString stringWithFormat:@"%@/%@",baseUrl,checkPhone];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"condition"] = condition;
    
    OrangeGreenFruitConfig *config = [OrangeGreenFruitConfig share_CustomNativeByte_Manager];
    config.appid = Appid;
    
    params[@"appid"] = config.appid;
    params[@"style"] = @"1";
    
    NSString * GreenFruitcid = [NSString stringWithFormat:@"%@",GreenFruitCid];
    if (GreenFruitCid != nil && ![GreenFruitcid isEqualToString:@""]) {
        params[@"cid"] = GreenFruitcid;
    }
    
    NSString *sign = [OrangeAPIParams signParams:params];
    params[@"sign"] = sign;
    [[OrangeGreenFruitNetworking shaerdInstance] postWithUrl:url cache:NO params:params progressBlock:^(int64_t bytesRead, int64_t totalBytes) {
        
    } successBlock:^(id response) {
        [OrangeMBManager hideAlert];
        successblock(response);
    } failBlock:^(NSError *error) {
        [OrangeMBManager hideAlert];
        failedBlock(error);
    }];
}

#pragma mark -- 支付开关获取
+(void)requestSwitchPayWithPayInfo:(GreenFruit_CustomNativeByte_SDKPay*)pay SuccessBlock:(RequestSuccessBlock) successblock failedblock:(RequestFailedBlock)failedBlock{
    NSString *url = [NSString stringWithFormat:@"%@/%@",baseUrl,switchPay];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    OrangeGreenFruitConfig *config = [OrangeGreenFruitConfig share_CustomNativeByte_Manager];
    config.appid = Appid;
    config.channelleve1 = Channelleve1;
    
    params[@"appid"] = config.appid;
    params[@"channellevel1"] = config.channelleve1;
    params[@"username"] = [OrangeInfoArchive getAccountName];
    //*** 新增
    params[@"orderName"] = pay.GreenFruitOrderName;
    params[@"orderDetail"] = pay.GreenFruitOrderDetail;
    params[@"orderAmt"] = pay.GreenFruitOrderAmt;
    params[@"consumerId"] = pay.consumerId;
    params[@"consumerName"] = pay.consumerName;
    params[@"currency"] = pay.GreenFruitCurrency;
    params[@"notifyUrl"] = pay.notifyUrl;
    params[@"productId"] = pay.productID;
    params[@"imei"] = UUID;
    params[@"openUDID"] = PasteBroadString;

    NSLog(@"支付开关参数:%@",params);
    
    NSString * GreenFruitcid = [NSString stringWithFormat:@"%@",GreenFruitCid];
    if (GreenFruitCid != nil && ![GreenFruitcid isEqualToString:@""]) {
        params[@"cid"] = GreenFruitcid;
    }
    
    NSString *sign = [OrangeAPIParams signParams:params];
    params[@"sign"] = sign;
    
    [[OrangeGreenFruitNetworking shaerdInstance] postWithUrl:url cache:NO params:params progressBlock:^(int64_t bytesRead, int64_t totalBytes) {
        
    } successBlock:^(id response) {
        successblock(response);
    } failBlock:^(NSError *error) {
        failedBlock(error);
    }];
}

#pragma mark --
+ (void)requestVerifyPruchase:(NSString*)orderno data:(NSString*)data SuccessBlock:(RequestSuccessBlock) successblock failedblock:(RequestFailedBlock)failedBlock{
//    [OrangeMBManager showLoading];
    NSString *url = [NSString stringWithFormat:@"%@/%@",baseUrl,verifyPruchase];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    OrangeGreenFruitConfig *config = [OrangeGreenFruitConfig share_CustomNativeByte_Manager];
    config.appid = Appid;
    config.channelleve1 = Channelleve1;
    
    params[@"appid"] = config.appid;
    params[@"channellevel1"] = config.channelleve1;
    params[@"data"] = data;
    params[@"orderno"] = orderno;
    params[@"retry"] =  [NSNumber numberWithInt:[[OrangeGreenFruitIAPManager share_CustomNativeByte_Manager] getRetry]];
    
    NSString * GreenFruitcid = [NSString stringWithFormat:@"%@",GreenFruitCid];
    if (GreenFruitCid != nil && ![GreenFruitcid isEqualToString:@""]) {
        params[@"cid"] = GreenFruitcid;
    }
    
    NSString *sign = [OrangeAPIParams signParams:params];
    params[@"sign"] = sign;
    [[OrangeGreenFruitNetworking shaerdInstance] postWithUrl:url cache:NO params:params progressBlock:^(int64_t bytesRead, int64_t totalBytes) {
        
    } successBlock:^(id response) {
//        [OrangeMBManager hideAlert];
        successblock(response);
    } failBlock:^(NSError *error) {
//        [OrangeMBManager hideAlert];
        failedBlock(error);
    }];
}

+ (void)requestGetOrderNo:(GreenFruit_CustomNativeByte_SDKPay*)pay SuccessBlock:(RequestSuccessBlock) successblock failedblock:(RequestFailedBlock)failedBlock{
//    [OrangeMBManager showLoading];
    NSString *url = [NSString stringWithFormat:@"%@/%@",baseUrl,getOrderNo];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"userid"] = [OrangeInfoArchive getUserId];
    
    OrangeGreenFruitConfig *config = [OrangeGreenFruitConfig share_CustomNativeByte_Manager];
    config.appid = Appid;
    config.channelleve1 = Channelleve1;
    
    params[@"appid"] = config.appid;
    params[@"channellevel1"] = config.channelleve1;
    params[@"mhtOrderName"] = pay.GreenFruitOrderName;
    params[@"mhtOrderDetail"] = pay.GreenFruitOrderDetail;
    params[@"mhtOrderAmt"] = pay.GreenFruitOrderAmt;
    params[@"consumerId"] = pay.consumerId;
    params[@"consumerName"] = pay.consumerName;
    params[@"zonename"] = pay.zonename;
    
    if ([pay.GreenFruitCurrency isEqualToString:@""]) {
        params[@"mhtCurrency"] = @"0";
        params[@"mhtCurrencyType"] = @"156";

    }else{
        params[@"mhtCurrency"] = pay.GreenFruitCurrency;
        params[@"mhtCurrencyType"] = pay.GreenFruitCurrency;
    }    
    params[@"notifyUrl"] = pay.notifyUrl;
    params[@"accountName"] = [OrangeInfoArchive getAccountName];
    params[@"version"] = version;
    params[@"productId"] = pay.productID;
    params[@"userUniqueId"] = @"user";
    params[@"imei"] = UUID;
    params[@"openUDID"] = PasteBroadString;

    NSLog(@"内购支付订单参数--:%@",params);
    
    NSString * GreenFruitcid = [NSString stringWithFormat:@"%@",GreenFruitCid];
    if (GreenFruitCid != nil && ![GreenFruitcid isEqualToString:@""]) {
        params[@"cid"] = GreenFruitcid;
    }
    
    NSString *sign = [OrangeAPIParams signParams:params];
    params[@"sign"] = sign;
    
    NSLog(@"内购订单参数签名:%@",params);
    
    [[OrangeGreenFruitNetworking shaerdInstance] postWithUrl:url cache:NO params:params progressBlock:^(int64_t bytesRead, int64_t totalBytes) {

    } successBlock:^(id response) {
//        [OrangeMBManager hideAlert];
        successblock(response);
    } failBlock:^(NSError *error) {
//        [OrangeMBManager hideAlert];
        failedBlock(error);
    }];
}
@end
