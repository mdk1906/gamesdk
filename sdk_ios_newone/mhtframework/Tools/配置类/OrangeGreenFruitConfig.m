//
//  OrangeGreenFruitConfig.m
//  GreenFruit_CustomNativeByte_SDK
//
//  Created by shuangfei on 2018/2/23.
//  Copyright © 2018年 Hu. All rights reserved.
//

#import "OrangeGreenFruitConfig.h"
//#import "OrangeNSString+Utils.h"
//NSString *const baseUrl = @"http://115.159.186.197:28083";

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

NSString *const baseUrl = @"http://api.17173g.cn:28080";
//NSString *const baseUrl = @"http://192.168.1.203:8080";
//NSString *const baseUrl = @"http://123.206.102.102:28083";


NSString *const payBaseUrl = @"http://api.17173g.cn:28080/platform-web/pay";
//NSString *const payBaseUrl = @"http://192.168.1.203:8080/platform-web/pay_v2_i";
//NSString *const payBaseUrl = @"http://123.206.102.102:28083/platform-web/pay";

//NSString *appid; // 游戏id
NSString *const secretKey = @"eb4287c41d8318c140334da7588e4159";
//NSString *channelleve1; // 渠道
//NSString *channellevel2;  // 推广员

NSString *const login_notification = @"login_notification";// 登录通知
NSString *const logout_notification = @"logout_notification";// 退出登录通知
NSString *const createorder = @"createorder_notification";//
NSString *const payfinish = @"payfinish_notification";//订单完成通知
NSString *const payverify_notification = @"payverify_notification";//订单验证通知


NSString *const meUrl = @"http://api.17173g.cn/me/html";
//个人中心的单元格点击事件的名称
NSString *const checkIdentityString = @"checkIdentity";
NSString *const collectPacksString = @"collectPacks";
NSString *const contactServiceString = @"contactService";
NSString *const updatePwdString = @"updatePwd";
NSString *const accountSecurityString = @"accountSecurity";
//实名认证的回调方法
NSString *const bandIdentityString = @"bandIdentity";
//领取游戏相关的
NSString *const collectPacksCodeString = @"collectPacksCode";
//修改密码相关的方法
NSString *const bandPhoneString = @"bandPhone";
//绑定手机号
//获取验证码
NSString *const getVerCodeString = @"getVerCode";
//绑定手机号
NSString *const doAccountSecurityString = @"doAccountSecurity";
//修改密码
NSString *const doPwdString = @"doPwd";
//弹出qq客服
NSString *const doOpenSchema = @"doOpenSchema";
//支付开关
NSString *const switchPay = @"/platform-apple-pay/apple/switchPay_V1.do";
//内购凭证
NSString *const verifyPruchase = @"/platform-apple-pay/apple/verifyPruchase.do";
//获取支付订单
NSString *const getOrderNo = @"/platform-apple-pay/apple/getOrderNo.do";


NSString *const getVertifyCode = @"/platform-sms/user-sms/send.do";
NSString *const getVertifyCode2 = @"/platform-sms/user-sms/send.do";
NSString *const checkPhone = @"/platform-controller/user-center/check/phone.do";
NSString *const registers = @"/platform-register/user-register/register.do";
NSString *const registerFast = @"/platform-register/user-register/register.do";
NSString *const login = @"/platform-login/user-login/login.do";
NSString *const loginCheck = @"/platform-login/user-login/checkLogin.do";
NSString *const logout = @"/platform-login/user-login/logout.do";
NSString *const settingRole =@"/platform-controller/user-center/user/roleData.do";
NSString *const paySign = @"/platform-pay/user-pay/sign.do";
NSString *const  bindPhone = @"/platform-controller/user-center/bind/phone.do";
NSString *const identifyVertify = @"/platform-controller/user-center/bind/identity.do";
NSString *const checkIdentify = @"/platform-controller/user-center/check/identity.do";
NSString *const updatePassword = @"/platform-controller/user-center/update/password.do";
NSString *const settingQQ = @"/platform-setting/setting/QQ.do";
NSString *const settingPay = @"/platform-setting/setting/pay.do";
NSString *const giftList = @"/platform-web/award/toGiftList.do";
NSString *const getGift = @"/platform-web/award/getGiftCode.do";
NSString *const settingPhone = @"/platform-setting/setting/Phone.do";
NSString *const goPay = @"/platform-web/pay";

//*** 新增
NSString *const phoneNumberRegist = @"/platform-register/user-register/loginOnlyPhone.do";
NSString *const checkConfirmCode = @"/platform-sms/user-sms/smsValid.do";
NSString *const modifyNewPassword = @"/platform-controller/user-center/update/password_v1.do";
NSString *const getUserCenterToken = @"/platform-web/user/token.do";
NSString *const newIdentifyVertify = @"/platform-controller/user-center/check/identity_v1.do";
NSString *const changebindPhone = @"/platform-controller/user-center/bind/phone_v1.do";
NSString *const getFloatballIcon = @"/platform-setting/setting/init.do";

@implementation OrangeGreenFruitConfig

+ (instancetype)share_CustomNativeByte_Manager {
    
    static OrangeGreenFruitConfig *config = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        config = [[OrangeGreenFruitConfig alloc] init];
    });
    return config;
}

//-(void)setAppid:(NSString*)appid{
//    _appid = appid;
//}
//-(void)setChannelleve1:(NSString*)channelleve1{
//    _channelleve1 = channelleve1;
//}
//-(void)setChannellevel2:(NSString*)channellevel2{
//    _channellevel2 = channellevel2;
//}



@end
