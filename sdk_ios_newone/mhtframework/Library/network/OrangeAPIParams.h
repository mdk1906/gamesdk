//
//  OrangeAPIParams.h
//  GreenFruit_CustomNativeByte_SDK
//
//  Created by shuangfei on 2018/2/1.
//  Copyright © 2018年 Hu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OrangeGreenFruit_CustomNativeByte_SDKHelper.h"
typedef void(^RequestSuccessBlock)(id response);
typedef void(^RequestFailedBlock)(NSError *error);

@interface OrangeAPIParams : NSObject

+(NSString*)signParams:(NSDictionary*)params;
+(void)requestPhone:(NSString*)phone successblock:(RequestSuccessBlock) successblock failedblock:(RequestFailedBlock)failedBlock;
+(void)requestFastRegisterSuccessBlock:(RequestSuccessBlock) successblock failedblock:(RequestFailedBlock)failedBlock;
+(void)requestFastRegisterStep2Username:(NSString*)username password:(NSString*)password SuccessBlock:(RequestSuccessBlock) successblock failedblock:(RequestFailedBlock)failedBlock;
+(void)requestUpdatePasswordUsername:(NSString*)username password:(NSString*)password vcode:(NSString*)vcode successBlock:(RequestSuccessBlock) successblock failedblock:(RequestFailedBlock)failedBlock;
+(void)requestPhone:(NSString*)phone code:(NSString*)code password:(NSString*)password successBlock:(RequestSuccessBlock) successblock failedblock:(RequestFailedBlock)failedBlock;
+(void)requestUsername:(NSString*)username successblock:(RequestSuccessBlock) successblock failedblock:(RequestFailedBlock)failedBlock;
+(void)requestLogin:(NSString*)username password:(NSString*)password SuccessBlock:(RequestSuccessBlock) successblock failedblock:(RequestFailedBlock)failedBlock;
+(void)requestCheckPhoneCondition:(NSString*)condition SuccessBlock:(RequestSuccessBlock) successblock failedblock:(RequestFailedBlock)failedBlock;
+(void)requestLogoutUserId:(NSString*)userId SuccessBlock:(RequestSuccessBlock) successblock failedblock:(RequestFailedBlock)failedBlock;

+(void)requestSettingRole:(GreenFruit_CustomNativeByte_SDKRoleData*)roleData SuccessBlock:(RequestSuccessBlock) successblock failedblock:(RequestFailedBlock)failedBlock;

+(void)requestIdentifyVertifyUserId:(NSString*)userid name:(NSString*)name identityno:(NSString*)identityno
                       successblock:(RequestSuccessBlock)successblock failedblock:(RequestFailedBlock)failedBlock;
+(void)requestCheckIdentifyUserid:(NSString*)userid successblock:(RequestSuccessBlock)successblock failedblock:(RequestFailedBlock)failedBlock;
+(void)requestGiftListSuccessblock:(RequestSuccessBlock)successblock failedblock:(RequestFailedBlock)failedBlock;
+(void)requestSettingPhoneSuccessblock:(RequestSuccessBlock)successblock failedblock:(RequestFailedBlock)failedBlock;
+(void)requestSettingQQSuccessblock:(RequestSuccessBlock)successblock failedblock:(RequestFailedBlock)failedBlock;
+(void)requestGiftUserId:(NSString*)userId awardid:(NSString*)awardid Successblock:(RequestSuccessBlock)successblock failedblock:(RequestFailedBlock)failedBlock;
+(void)requestUpdatePassword:(NSString*)password username:(NSString*)username vcode:(NSString*)vcode Successblock:(RequestSuccessBlock)successblock failedblock:(RequestFailedBlock)failedBlock;
+ (void)requestBindPhone:(NSString*)phone vcode:(NSString*)vcode Successblock:(RequestSuccessBlock)successblock failedblock:(RequestFailedBlock)failedBlock;
+(void)requestSwitchPayWithPayInfo:(GreenFruit_CustomNativeByte_SDKPay*)pay SuccessBlock:(RequestSuccessBlock) successblock failedblock:(RequestFailedBlock)failedBlock;
+ (void)requestVerifyPruchase:(NSString*)orderno data:(NSString*)data SuccessBlock:(RequestSuccessBlock) successblock failedblock:(RequestFailedBlock)failedBlock;
+ (void)requestGetOrderNo:(GreenFruit_CustomNativeByte_SDKPay*)pay SuccessBlock:(RequestSuccessBlock) successblock failedblock:(RequestFailedBlock)failedBlock;
#pragma mark -- ++++++++++++++++++++++++++++
+(void)requestCenterCheckPhoneCondition:(NSString*)condition SuccessBlock:(RequestSuccessBlock) successblock failedblock:(RequestFailedBlock)failedBlock;

//*** 新增接口
+(void)requestActiveMethodWithVersions:(NSString *)versions localIp:(NSString *)localIp  sysTermVersion:(NSString *)os  Devicetype:(NSString *)devicetype pasteboard:(NSString *)pasteboard appKey:(NSString *)appKey withSuccessBlock:(RequestSuccessBlock)successblock faildBlock:(RequestFailedBlock)failedblock;
+(void)requestForPhoneRegistionMethod:(NSString *)phoneNumber withVcode:(NSString *)code SuccessBlock:(RequestSuccessBlock)successblock failedBlock:(RequestFailedBlock)failedblock;
+(void)requestCheckComfirmPhone:(NSString *)phoneNumer withConfirmCode:(NSString *)code withStyle:(NSString *)style SuccessBlock:(RequestSuccessBlock)successblock failedBlock:(RequestFailedBlock)failedblock;
+(void)requestForModifyPassword:(NSString *)password andUserName:(NSString *)userName SuccessBlock:(RequestSuccessBlock)successblock failedBlock:(RequestFailedBlock)failedblock;
+(void)requestPhoneLogin:(NSString*)username password:(NSString*)password SuccessBlock:(RequestSuccessBlock) successblock failedblock:(RequestFailedBlock)failedBlock;
+(void)requestForUserCenterTokenwithSuccessBlock:(RequestSuccessBlock)successblock failedBlock:(RequestFailedBlock)failedblock;
+(void)requestNewCheckIdentifyUserid:(NSString*)userid successblock:(RequestSuccessBlock)successblock failedblock:(RequestFailedBlock)failedBlock;
+ (void)requestChangePhone:(NSString*)phone vcode:(NSString*)vcode Successblock:(RequestSuccessBlock)successblock failedblock:(RequestFailedBlock)failedBlock;

//封装好的post请求接口
+(void)postRequestMethodPakagedwithSuccessBlock:(RequestSuccessBlock)successblock faildBlock:(RequestFailedBlock)failedblock;
@end


