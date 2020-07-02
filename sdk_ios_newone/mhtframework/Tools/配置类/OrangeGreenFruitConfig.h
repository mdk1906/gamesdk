//
//  OrangeGreenFruitConfig.h
//  GreenFruit_CustomNativeByte_SDK
//
//  Created by shuangfei on 2018/2/23.
//  Copyright © 2018年 Hu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AdSupport/AdSupport.h>
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
extern NSString *const baseUrl;
extern NSString *const payBaseUrl;
//extern NSString *appid; // 游戏id
extern NSString *const secretKey;
//extern NSString *channelleve1; // 渠道
//extern NSString *channellevel2;  // 推广员

extern NSString *const login_notification;  // 登录通知
extern NSString *const logout_notification;  // 退出登录通知
extern NSString *const createorder;
extern NSString *const payfinish;
extern NSString *const payverify_notification;
extern NSString *const meUrl;
//个人中心的单元格点击事件的名称
extern NSString *const checkIdentityString;
extern NSString *const collectPacksString;
extern NSString *const contactServiceString;
extern NSString *const updatePwdString;
extern NSString *const accountSecurityString;
//实名认证的回调方法
extern NSString *const bandIdentityString;
//领取游戏相关的
extern NSString *const collectPacksCodeString;
//修改密码相关的方法
extern NSString *const bandPhoneString;
//绑定手机号
//获取验证码
extern NSString *const getVerCodeString;

//绑定手机号
extern NSString *const doAccountSecurityString;

//修改密码
extern NSString *const doPwdString;

//打开第三方应用
extern NSString *const doOpenSchema;

//支付开关
extern NSString *const switchPay;
//内购凭证
extern NSString *const verifyPruchase;
//获取支付订单
extern NSString *const getOrderNo;

extern NSString *const getVertifyCode;
extern NSString *const getVertifyCode2;
extern NSString *const checkPhone;
extern NSString *const registers;
extern NSString *const registerFast;
extern NSString *const login;
extern NSString *const loginCheck;
extern NSString *const logout;
extern NSString *const settingRole;
extern NSString *const paySign;
extern NSString *const bindPhone;
extern NSString *const identifyVertify;
extern NSString *const checkIdentify;
extern NSString *const updatePassword;
extern NSString *const settingQQ;
extern NSString *const settingPay;
extern NSString *const giftList;
extern NSString *const getGift;
extern NSString *const settingPhone;
extern NSString *const goPay;
//***新增
extern NSString *const checkConfirmCode;
extern NSString *const modifyNewPassword;
extern NSString *const phoneNumberRegist;
extern NSString *const getUserCenterToken;
extern NSString *const newIdentifyVertify;
extern NSString *const changebindPhone;
extern NSString *const getFloatballIcon;

//取bundle里的图片
#define GreenFruitImage(file) [@"GreenFruit.bundle" stringByAppendingPathComponent:file]
//颜色
#define GreenFruitColor(r, g, b) [UIColor colorWithRed:(r) / 255.0 green:(g) / 255.0 blue:(b) / 255.0 alpha:1]
// 自定义颜色 透明度
#define GreenFruitColorWithAlpha(r, g, b, a) [UIColor colorWithRed:(r) / 255.0 green:(g) / 255.0 blue:(b) / 255.0 alpha:a]
#define ThemeColor GreenFruitColor(60, 189, 81)
#define TabBarColor GreenFruitColor(67, 187, 86)
#define LineColor GreenFruitColor(226, 226, 226)
#define ButtonBlueColor GreenFruitColor(96, 185, 247)
#define TextGaryColor GreenFruitColor(125, 148, 176)
#define ToastColor GreenFruitColorWithAlpha(0, 0, 0,0.7)
#define UUID [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString]
#define GreenFruitCurrencyType @"156"
#define version [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"]

//#define Appid [OrangeGreenFruitConfig share_CustomNativeByte_Manager].appid
//#define Channelleve1 [OrangeGreenFruitConfig share_CustomNativeByte_Manager].channelleve1
//#define Channellevel2 [OrangeGreenFruitConfig share_CustomNativeByte_Manager].channellevel2›
//#define DeviceName  [OrangeGreenFruitConfig share_CustomNativeByte_Manager].deviceType

#define Appid [[NSUserDefaults standardUserDefaults]objectForKey:@"GreenFruitAPPID"]

#define Channelleve1     [[NSUserDefaults standardUserDefaults]objectForKey:@"GreenFruitCHANNEL1"]

#define Channellevel2     [[NSUserDefaults standardUserDefaults]objectForKey:@"GreenFruitCHANNEL2"]

#define DeviceName  [[NSUserDefaults standardUserDefaults]objectForKey:@"GreenFruitDEVICETYPE"]

#define GreenFruitCid  [[NSUserDefaults standardUserDefaults]objectForKey:@"GreenFruitCID"]

#define USERID  [[NSUserDefaults standardUserDefaults]objectForKey:@"USERID"]

#define PasteBroadString [[NSUserDefaults standardUserDefaults]objectForKey:@"PasteBoardString"]

#define SDK_VERSION @"3.31"

//*** 新增
#define kWindow          [[UIApplication sharedApplication].windows firstObject]
#define User_Defaults_Get(name)  [[NSUserDefaults standardUserDefaults]objectForKey:name]
#define User_Defaules_Set(value,key) [[NSUserDefaults standardUserDefaults]setObject:value forKey:key]
#define KGreenColor [UIColor colorWithRed:0.537 green:0.741 blue:0.341 alpha:1.0]

#define KPublicImgUrl    @"http://api.17173g.cn/sdk-center/logo/"
#define KLogoImgUrl @"http://api.17173g.cn/sdk-center/logo/"

#define KPublicPath [[OrangeGreenFruitBundle mainBundle]pathForResource:@"Orangelogo_Chinese" ofType:@"png"];
#define KLogoPath [[OrangeGreenFruitBundle mainBundle]pathForResource:@"OrangesystomAccout" ofType:@"png"];

#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

#define IS_PAD (UI_USER_INTERFACE_IDIOM()== UIUserInterfaceIdiomPad)


@interface OrangeGreenFruitConfig : NSObject
+ (instancetype)share_CustomNativeByte_Manager;
@property (nonatomic,copy)NSString *appid;
@property (nonatomic,copy)NSString *channelleve1;
@property (nonatomic,copy)NSString *channellevel2;
@property (nonatomic,copy)NSString *deviceType;

@end
