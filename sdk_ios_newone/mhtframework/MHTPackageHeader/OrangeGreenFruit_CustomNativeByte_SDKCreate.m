//
//  OrangeGreenFruit_CustomNativeByte_SDKCreate.m
//  GreenFruit_CustomNativeByte_SDK
//
//  Created by shuangfei on 2018/2/23.
//  Copyright © 2018年 Hu. All rights reserved.
//

#import "OrangeGreenFruit_CustomNativeByte_SDKCreate.h"
#import "OrangeGreenFruitFloatingBall.h"
#import "OrangeRespondModel.h"
#import "OrangeGreenFruitCenterViewController.h"
#import "OrangeGreenFruitPayForViewController.h"
#import "OrangeZJAnimationPopView.h"
#import "OrangeGreenFruitConfig.h"
#import "OrangeInfoArchive.h"
#import "OrangeMBManager.h"
#import "OrangeAPIParams.h"
#import "OrangeYYModel.h"
#import "OrangeGreenFruitBundle.h"
#import "OrangeNSString+Utils.h"
#import "OrangeSwitchPayModel.h"
#import "OrangeGreenFruitPayStore.h"
#import "OrangeGreenFruitNetworking.h"
#import "OrangeVerifyModel.h"
#import "OrangeFileManager.h"

#import "GreenFruitFloatSpreadViewBlackCustomControl.h"
#import "GreenFruitTouristUserLoginViewBlackCustomControl.h"
#import "GreenFruitOtherWayLoginBlackCustomControl.h"
#import "GreenFruitAccountClickSpreadViewBlackCustomControl.h"
#import "OrangeGreenFruitUserCenterNewViewController.h"
#import "GreenFruitRealIdentityCheckViewBlackCustomControl.h"
#import "GreenFruitBoundPhoneViewBlackCustomControl.h"
#import "GreenFruitNewAotuLoginViewBlackCustomControl.h"

#import <SafariServices/SafariServices.h>
#import "OrangeGreenFruitSafariViewController.h"
#import "OrangeGreenFruitIPToolManager.h"
#import "AFNetworkReachabilityManager.h"
#import "OrangeGreenFruitDealWithBase64.h"

#import <CommonCrypto/CommonDigest.h>//openUDID

//今日头条
#import <TTTracker/TTTracker.h>
#import <TTTracker/TTTracker+Game.h>
#import <TTTracker/TTInstallIDManager.h>

@interface OrangeGreenFruit_CustomNativeByte_SDKCreate()<GreenFruitFloatingBallDelegate>

@property (nonatomic, copy) GreenFruit_CustomNativeByte_SDKCreateReturnInfoBlock createReturnInfoBlock;//激活状态回调
@property (nonatomic, copy) GreenFruit_CustomNativeByte_SDKLogoutStatusBlock logoutStatusBlock;//退出状态回调
@property (nonatomic, copy) GreenFruit_CustomNativeByte_SDKLoginCompletionBlock loginCompletionBlock;//登录接口回调
@property (nonatomic, copy) GreenFruit_CustomNativeByte_SDKLogoutCompletionBlock logoutCompletionBlock;//退出接口回调
@property (nonatomic, copy) GreenFruit_CustomNativeByte_SDKSettingRoleDataCompletionBlock setRoleDataCompletionBlock;//上报游戏角色信息
@property (nonatomic, copy) GreenFruit_CustomNativeByte_SDKPayBackBlock payBackCompletionBlock;//支付返回回调


@property (nonatomic, strong) OrangeGreenFruitFloatingBall *floating;
@property (nonatomic, assign) BOOL loginStatus;
@property (nonatomic, assign) BOOL isPaying;
@property (nonatomic, strong) UIViewController *rVC;

//新增 ***
@property (nonatomic, strong) GreenFruitFloatSpreadViewBlackCustomControl * floatSpreadView;
@property (nonatomic, strong) GreenFruitTouristUserLoginViewBlackCustomControl * touristLoginView;
@property (nonatomic, strong) GreenFruitOtherWayLoginBlackCustomControl * otherWayLoginView;
@property (nonatomic, strong) GreenFruitAccountClickSpreadViewBlackCustomControl * accountClickView;
@property (nonatomic, strong) GreenFruitRealIdentityCheckViewBlackCustomControl * realNameCheckView;
@property (nonatomic, strong) GreenFruitBoundPhoneViewBlackCustomControl * boundPhoneView;
@property (nonatomic, strong) GreenFruitNewAotuLoginViewBlackCustomControl * freshAutoLoginview;

@property (nonatomic, strong)UIView * floatBackView;//悬浮球展开的操作视图
@property (nonatomic, strong)UIView * rightFloatBackView;//悬浮球展开的操作视图
@property (nonatomic, assign)BOOL  disAllowLoginType;//不允许登录回调信息传递的状态
@property (nonatomic, retain)NSString * token;//请求个人中心的token
@property (nonatomic, strong)UIViewController * tempRootVC;
@property (nonatomic, strong)GreenFruit_CustomNativeByte_SDKPay * tempPay;
@property (nonatomic, assign)BOOL isSpreaded;//悬浮球是否打开
@property (nonatomic, assign)BOOL isHalfOffset;//是否半隐藏

@property (nonatomic, retain)NSTimer * removeTimer;
@property (nonatomic, assign)int minute;
@property (nonatomic, retain)NSThread * thread;
@property (nonatomic, retain)NSString * logoutStatus;//退出猕猴桃平台返回的code

@property (nonatomic, retain)UIImage * publicImage;
@property (nonatomic, retain)UIImage * logoImage;



@end

@implementation OrangeGreenFruit_CustomNativeByte_SDKCreate

#pragma mark  初始化单例
+ (instancetype)share_CustomNativeByte_Manager {
    static OrangeGreenFruit_CustomNativeByte_SDKCreate *config = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        config = [[OrangeGreenFruit_CustomNativeByte_SDKCreate alloc] init];
    });
    
    return config;
}

#pragma mark 新版本初始化游戏账号信息 -- 植入了今日头条埋点统计功能
- (void)GreenFruitNewOnCreateAppid:(NSString*)appid channellevel1:(NSString*)channellevel1
              channellevel2:(NSString*)channellevel2  withGreenFruit_event_ad_id:(NSString*)event_Ad_Id  andGreenFruit_event_ad_appName:(NSString *)event_ad_appName successBlock:(GreenFruit_CustomNativeByte_SDKCreateReturnInfoBlock)returnInfoBlock withLogoutStatusBlock:(GreenFruit_CustomNativeByte_SDKLogoutStatusBlock)logoutStatusBlock{
    
//    self.rVC = rootVC;
    [[NSUserDefaults standardUserDefaults]setObject:@"Yes" forKey:@"ActiveStyle"];

    //退出的回调返回信息
    self.logoutStatusBlock = logoutStatusBlock;
    
    self.createReturnInfoBlock = returnInfoBlock;
    
    NSLog(@"猕猴桃SDK版本号:%@",SDK_VERSION);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginOrLogoutNotification:) name:login_notification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginOrLogoutNotification:) name:logout_notification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(payFinishNotification:) name:payfinish object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(payVerifyNotification:) name:payverify_notification object:nil];
    
    /*
     用户初始化时，直接将用户appid，channellevel1，channellevel2储存到配置类的模型中
     如果用户是有缓存过渠道以及appid，则将channelevel1以及AppID的信息用制作好的缓存代替；如果没有归因，则用CP传的信息存到模型中
     */
    NSString * deviceName = [NSString getDeviceType];
    [[NSUserDefaults standardUserDefaults]setObject:appid forKey:@"GreenFruitAPPID"];
    [[NSUserDefaults standardUserDefaults]setObject:deviceName forKey:@"GreenFruitDEVICETYPE"];
    [[NSUserDefaults standardUserDefaults]setObject:channellevel1 forKey:@"GreenFruitCHANNEL1"];
    [[NSUserDefaults standardUserDefaults]setObject:channellevel2 forKey:@"GreenFruitCHANNEL2"];
   
    [self getOpenUDIDMethod];//获取OpenUDID 放入剪切板 增加imei参数
    
    /*
     执行今日头条统计功能
     */
    if (event_Ad_Id.length != 0  && event_ad_appName.length != 0) {
        
        [self TodayTrackerMethodwithAdAppId:event_Ad_Id andAdAppName:event_ad_appName];
        
        [[NSUserDefaults standardUserDefaults]setObject:event_Ad_Id forKey:@"toutiaoAPPID"];
        [[NSUserDefaults standardUserDefaults]setObject:event_ad_appName forKey:@"toutiaoAPPNAME"];
        
    }else{
        NSLog(@"不执行数据统计");
    }
    
    OrangeGreenFruitConfig *config = [OrangeGreenFruitConfig share_CustomNativeByte_Manager];
    config.deviceType = deviceName;
    config.channelleve1 = channellevel1;
    config.channellevel2 = channellevel2;
    config.appid = appid;
    
    NSString * weatherActiveds = [[NSUserDefaults standardUserDefaults]objectForKey:@"ActiveStyle"];
    if ([weatherActiveds isEqualToString:@"Yes"]) {
        if (self.createReturnInfoBlock) {//将激活接口的状态码返回给API接口中
            self.createReturnInfoBlock(@"200");
        }
    }else{
        [self getSafariCookieMethod];
    }
    
}

-(void)getOpenUDIDMethod{
    
    // 不创立剪切板，从自定义剪切板中取
    UIPasteboard * firstCustomPB = [UIPasteboard pasteboardWithName:@"GreenFruitPASTEBOARDSTRING" create:NO];
    NSString * pasteBoardStr = [NSString stringWithFormat:@"%@",firstCustomPB.string];
    NSLog(@"-dadadad:%@",pasteBoardStr);
    if (pasteBoardStr.length == 0 || [pasteBoardStr isEqualToString:@"(null)"]) {//没有内容，就在剪切板上创建内容
        unsigned char result[16];
        const char *cStr = [[[NSProcessInfo processInfo] globallyUniqueString] UTF8String];
        CC_MD5( cStr, strlen(cStr), result );
        NSLog(@"设备号:%s",cStr);
        
        NSString * _openUDID = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%08lx",result[0], result[1], result[2], result[3],result[4],result[5], result[6], result[7],result[8], result[9], result[10], result[11],result[12], result[13], result[14], result[15],arc4random()%4294967295];
        NSLog(@"openUDID:%@",_openUDID);
        
        UIPasteboard* slotPB = [UIPasteboard pasteboardWithName:@"GreenFruitPASTEBOARDSTRING" create:YES];
        [slotPB setString:_openUDID];
        NSLog(@"-剪切板上oppenUDID--%@",slotPB.string);
        
        User_Defaules_Set(_openUDID, @"PasteBoardString");
        
        NSLog(@"新创建的剪切板信息:%@",PasteBroadString);
        
    }
    else{//自定义上剪切板上有内容  有就拿来用
        
        User_Defaules_Set(pasteBoardStr, @"PasteBoardString");

        NSLog(@"已有的剪切板信息:%@",PasteBroadString);
        
    }
}


-(void)TodayTrackerMethodwithAdAppId:(NSString *)adAppId andAdAppName:(NSString *)adAppName{
    
    //今日头条 配置
    [[TTTracker sharedInstance] setCustomHeaderBlock:^(void) {
        return @{@"buryPoint":@"GreenFruitBury"};
    }];
    
    [[TTTracker sharedInstance] setSessionEnable:YES];
    [TTTracker startWithAppID:adAppId channel:@"channel1" appName:adAppName];
    
//    [TTTracker eventV3:@"FeiFeiRun" params:@{@"is_log_in":@(1)}];
    
}


#pragma mark 初始化游戏账号信息
- (void)GreenFruitOnCreateAppid:(NSString*)appid channellevel1:(NSString*)channellevel1
           channellevel2:(NSString*)channellevel2 withVC:(UIViewController*)rootVC successBlock:(GreenFruit_CustomNativeByte_SDKCreateReturnInfoBlock)returnInfoBlock withLogoutStatusBlock:(GreenFruit_CustomNativeByte_SDKLogoutStatusBlock)logoutStatusBlock{
    
    self.rVC = rootVC;

    //退出的回调返回信息
    self.logoutStatusBlock = logoutStatusBlock;
    
    self.createReturnInfoBlock = returnInfoBlock;
        
    NSLog(@"猕猴桃SDK版本号:%@",SDK_VERSION);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginOrLogoutNotification:) name:login_notification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginOrLogoutNotification:) name:logout_notification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(payFinishNotification:) name:payfinish object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(payVerifyNotification:) name:payverify_notification object:nil];
    
    /*
     用户初始化时，直接将用户appid，channellevel1，channellevel2储存到配置类的模型中
     如果用户是有缓存过渠道以及appid，则将channelevel1以及AppID的信息用制作好的缓存代替；如果没有归因，则用CP传的信息存到模型中
     */
    NSString * deviceName = [NSString getDeviceType];
    [[NSUserDefaults standardUserDefaults]setObject:appid forKey:@"GreenFruitAPPID"];
    [[NSUserDefaults standardUserDefaults]setObject:deviceName forKey:@"GreenFruitDEVICETYPE"];
    [[NSUserDefaults standardUserDefaults]setObject:channellevel1 forKey:@"GreenFruitCHANNEL1"];
    [[NSUserDefaults standardUserDefaults]setObject:channellevel2 forKey:@"GreenFruitCHANNEL2"];
    
    NSLog(@"模拟器设备号:%@",UUID);
    
    OrangeGreenFruitConfig *config = [OrangeGreenFruitConfig share_CustomNativeByte_Manager];
    config.deviceType = deviceName;
    config.channelleve1 = channellevel1;
    config.channellevel2 = channellevel2;
    config.appid = appid;
    
//    OrangeGreenFruitConfig *config = [OrangeGreenFruitConfig share_CustomNativeByte_Manager];
//    NSString * deviceName = [NSString getDeviceType];
//    config.deviceType = deviceName;
//    config.channellevel2 = channellevel2;//用户名
    
//    NSString * sdkChannel1 = User_Defaults_Get(@"SDKChannel1");
//    NSString * sdkAppid = User_Defaults_Get(@"SDKAppid");
//
//    if (sdkChannel1.length == 0) {
//        config.channelleve1 = channellevel1;
//    }else{
//        config.channelleve1 = sdkChannel1;//渠道
//    }
//
//    if (sdkAppid.length == 0) {
//        config.appid = appid;
//    }else{
//        config.appid = sdkAppid;//游戏id
//    }
    
    
    NSString * weatherActiveds = [[NSUserDefaults standardUserDefaults]objectForKey:@"ActiveStyle"];
    if ([weatherActiveds isEqualToString:@"Yes"]) {
        if (self.createReturnInfoBlock) {//将激活接口的状态码返回给API接口中
            NSLog(@"是否调用返回状态");
            self.createReturnInfoBlock(@"200");
        }
    }else{
        [self getSafariCookieMethod];
    }
    
}

-(void)writeToSandBox{
    
    NSString * publicString = [NSString stringWithFormat:@"%@%@/Orangelogo_Chinese.png",KPublicImgUrl,Appid];
    NSURL * publicUrl = [NSURL URLWithString:publicString];
    self.publicImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:publicUrl]];
    if (self.publicImage.size.height==0 &&self.publicImage.size.width==0) {

        NSString * publicPathString = KPublicPath;
        self.publicImage = [UIImage imageWithData:[NSData dataWithContentsOfFile:publicPathString]];
    }
    
    
    NSString * logoString = [NSString stringWithFormat:@"%@%@/OrangesystomAccout.png",KLogoImgUrl,Appid];
    NSURL * logoUrl = [NSURL URLWithString:logoString];
    self.logoImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:logoUrl]];
    
    if (self.logoImage.size.height == 0 && self.logoImage.size.width == 0) {
        NSString * logoPathString = KLogoPath;
        self.logoImage = [UIImage imageWithData:[NSData dataWithContentsOfFile:logoPathString]];
    }
    
    
    NSString *path_document = NSHomeDirectory();
    //设置一个图片的存储路径
    NSString *publicImgPath = [path_document stringByAppendingString:@"/Documents/publicImg.png"];
    NSString * logoImgPath = [path_document stringByAppendingString:@"/Documents/logoImg.png"];
    
//    先清空沙盒中对应目录下的文件，重新放置
    NSFileManager*fileManager=[NSFileManager defaultManager];
    if([[NSFileManager defaultManager]fileExistsAtPath:publicImgPath]) {
        [fileManager removeItemAtPath:publicImgPath error:nil];
    }
    if([[NSFileManager defaultManager]fileExistsAtPath:logoImgPath]) {
        [fileManager removeItemAtPath:logoImgPath error:nil];
    }
    User_Defaules_Set(publicImgPath, @"publicImgPath");
    User_Defaules_Set(logoImgPath, @"logoImgPath");
    
    
    //把图片直接保存到指定的路径（同时应该把图片的路径imagePath存起来，下次就可以直接用来取）
    [UIImagePNGRepresentation(self.publicImage) writeToFile:publicImgPath atomically:YES];
    
    [UIImagePNGRepresentation(self.logoImage) writeToFile:logoImgPath atomically:YES];
    
}

/*
  结合下方代理方法，判断连接是否含有图片 404不含
  NSURLRequest * request = [NSURLRequest requestWithURL:publicUrl];
  [[NSURLConnection alloc] initWithRequest:request delegate:self];
 */
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    if ((([httpResponse statusCode]/100) == 2)) {
        // self.earthquakeData = [NSMutableData data];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        
    } else {
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:
                                  NSLocalizedString(@"HTTP Error",
                                                    @"Error message displayed when receving a connection error.")
                                                             forKey:NSLocalizedDescriptionKey];
        NSError *error = [NSError errorWithDomain:@"HTTP" code:[httpResponse statusCode] userInfo:userInfo];

        if ([error code] == 404) {

        }else{
            
        }
    }
}

-(void)checkMoblieSignMethod{
    //1.创建网络状态监测管理者
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    //2.监听改变
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                NSLog(@"未知");
                break;
            case AFNetworkReachabilityStatusNotReachable:
                NSLog(@"没有网络");
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                NSLog(@"3G|4G");
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                NSLog(@"WiFi");
                break;
            default:
                break;
        }
        
    }];
    [manager startMonitoring];//开始监听
}


#pragma mark --- 加载safiriVC后， 通知回调的方法
-(void)getSafariCookieMethod{

    /*
     配备参数，传参初始化接口
     1 此方法获取具体的ip地址
    */
    OrangeGreenFruitIPToolManager *ipManager = [OrangeGreenFruitIPToolManager sharedManager];
    NSString * ipAddress = [ipManager currentIpAddress];
    
    //2
    NSString * deviceName = [NSString getDeviceType];
    
    //3
    NSString* phoneVersion = [[UIDevice currentDevice] systemVersion];
    
    //4  获取SDK版本号
    NSString * versions = SDK_VERSION;

    /*
     5 decodeString  获取剪切板上html文件，解析字符串后再进行特定字符的base64解密
     */
    NSString * pasteString;
    NSString * pasteContent = User_Defaults_Get(@"pasteContent");
    
    
    if (pasteContent.length != 0 && pasteContent != nil) {
        pasteString = pasteContent;

    }else{
        
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteString = [NSString stringWithFormat:@"%@",pasteboard.string];
        [[NSUserDefaults standardUserDefaults]setObject:pasteString forKey:@"pasteContent"];
        
    }
    
    NSString * decodeString;
    if (pasteString.length!=0) {
        if ([pasteString containsString:@"base64,"]) {
            NSArray * copyArr1 = [pasteString componentsSeparatedByString:@"base64,"];
              NSString * pasteString1 = [NSString stringWithFormat:@"%@",copyArr1[1]];
            if ([pasteString1 containsString:@" class="]) {
                NSArray * copyArr2 = [pasteString1 componentsSeparatedByString:@" class="];
                NSString * pasteString2 = [NSString stringWithFormat:@"%@",copyArr2[0]];

                NSString * pasreString3 = [pasteString2 substringToIndex:pasteString2.length-1];
                decodeString = pasreString3;
            }
        }
    }
    /*
     激活接口
     初始化之前把解析好的html的加密文本传递给服务器，根据后台接口返回的状态，判断是否要进行渠道号的更新
     */
    
    if (decodeString.length == 0) {
        decodeString = @"";
    }
    
    [OrangeAPIParams requestActiveMethodWithVersions:versions localIp:ipAddress sysTermVersion:phoneVersion Devicetype:deviceName pasteboard:decodeString appKey:@"" withSuccessBlock:^(id response) {
        
        NSDictionary * infoDic = (NSDictionary *)response;
        NSLog(@"info:%@",infoDic);
        
        /*
         这里如果状态为200，则获取channel 这个字段信息，若信息不为空，则将该信息赋值给缓存中的渠道号；若信息为空，则原缓存中的渠道号不变
         */
        NSString * status = [NSString stringWithFormat:@"%@",infoDic[@"code"]];
        
        if ([status isEqualToString:@"200"]) {
            
            NSDictionary * contentDic = infoDic[@"content"];
            NSLog(@"查看激活返回信息:%@",contentDic);
            
            if (contentDic != nil) {
                NSString * channelLevelStr = [NSString stringWithFormat:@"%@",contentDic[@"channelLevel1"]];
                NSString * appkeys = [NSString stringWithFormat:@"%@",contentDic[@"appKey"]];
                NSString * cId = [NSString stringWithFormat:@"%@",contentDic[@"cId"]];
            
                NSLog(@"初始化给出的cid:%@",cId);
                if (cId.length == 0 || cId == nil) {
                    [[NSUserDefaults standardUserDefaults]setObject:cId forKey:@""];
                }else{
                    [[NSUserDefaults standardUserDefaults]setObject:cId forKey:@"GreenFruitCID"];
                }

                OrangeGreenFruitConfig *config = [OrangeGreenFruitConfig share_CustomNativeByte_Manager];
                
                if (channelLevelStr.length != 0 && channelLevelStr != nil) {
                    config.channelleve1 = channelLevelStr;//渠道
                    [[NSUserDefaults standardUserDefaults]setObject:channelLevelStr forKey:@"GreenFruitCHANNEL1"];
                }
                if (appkeys.length != 0 && appkeys != nil) {
                    config.appid = appkeys;
                    [[NSUserDefaults standardUserDefaults]setObject:appkeys forKey:@"GreenFruitAPPID"];
                }
                
            }
            else{
//                NSLog(@"没有返回content信息");
            }
            
            [[NSUserDefaults standardUserDefaults]setObject:@"Yes" forKey:@"ActiveStyle"];
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"pasteContent"];
            
          
            if (self.createReturnInfoBlock) {//将激活接口的状态码返回给API接口中
//                NSLog(@"是否调用返回状态");
                self.createReturnInfoBlock(status);
            }

        }
        else{
            NSLog(@"请求失败");
            [[NSUserDefaults standardUserDefaults]setObject:@"Yes" forKey:@"ActiveStyle"];

            if (self.createReturnInfoBlock) {
                self.createReturnInfoBlock(@"-999");
            }
        }
        
        
    } faildBlock:^(NSError *error) {
        NSLog(@"初始化失败error:%@",error);
        if (self.createReturnInfoBlock) {//将激活接口的状态码返回给API接口中  网络连接失败统一为-999
            self.createReturnInfoBlock(@"-999");
        }

    }];
    
}


#pragma mark -- 清除缓存  SDK 方法
-(void)removeCache{
    
    [[NSUserDefaults standardUserDefaults]setObject:@"No" forKey:@"ActiveStyle"];
    
    NSString * String = User_Defaults_Get(@"ActiveStyle");
    
    NSLog(@"激活状态:%@",String);
    
    NSDate *date = [[NSDate alloc] initWithTimeIntervalSince1970:0];
    if(@available(iOS 9.0, *)){
        NSSet *websiteDataTypes = [WKWebsiteDataStore allWebsiteDataTypes];
        [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:date completionHandler:^{
            NSLog(@"清空缓存完成");
        }];
    }else{
        NSString *libraryPath = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES)[0];
        NSString *cookiesFolderPath = [libraryPath stringByAppendingString:@"/Cookies"];
        [[NSFileManager defaultManager] removeItemAtPath:cookiesFolderPath error:nil];
    }
}

/*
 1.若登录过程中，存在登录缓存，则返回登录失败；
 2.若登录过程中，存在正在登录状态，返回登录失败；
 */

#pragma mark 登录账号
- (void)GreenFruitLoginRootVC:(UIViewController*)rootVC CompletionBlock:(GreenFruit_CustomNativeByte_SDKLoginCompletionBlock)completionBlock{
    
    [self writeToSandBox];
    
    self.loginCompletionBlock = completionBlock;
    
    //先判断是否激活过
    NSString * activeStyle = User_Defaults_Get(@"ActiveStyle");
    if (![activeStyle isEqualToString:@"Yes"]) {
        [OrangeMBManager show_CustomNativeByte_BriefAlert:@"未初始化" time:1.0f];
        return;
    }
    
    BOOL extractedExpr = self.loginStatus;
    if(extractedExpr){

        NSLog(@"请勿重复登录");
        
        self.loginCompletionBlock(nil, @"-999");

        return;
        
    }else{
        NSLog(@"没登录");
        
    }
    
    //每次需要登录时都设置为可回调状态
    [self allowLogin];
    
    //登录的过程中，此缓存一直设置为0；
    [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"AllowLoginType"];

    [self getOpenUDIDMethod];//获取OpenUDID 放入剪切板
    
    self.rVC = rootVC;
    
 
//*** 新增 判断是否有登录缓存
    NSMutableArray * loginCacheArr = User_Defaults_Get(@"firstLoginCacheArr");
    if (loginCacheArr.count != 0) {
        //有登录缓存，跳转加载json登录页面；

        NSString * loginStatus = [NSString stringWithFormat:@"%@",[OrangeInfoArchive getLoginStatus]];

        if ([loginStatus isEqualToString:@"0"]) {//如果为0，说明调用过注销；这里让用户进入默认登录界面
            self.floatSpreadView = [[[OrangeGreenFruitBundle mainBundle]loadNibNamed:@"GreenFruitFloatSpreadViewBlackCustomControl" owner:self options:nil]lastObject];
            self.floatSpreadView.completionBlock = completionBlock;//在这里声明了回调信息
            [self pop_CustomNativeByte_SDKView:self.floatSpreadView CompletionBlock:completionBlock];
        }
        else{
            //自动登录页面
            //正在登录状态
            [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:@"loginingType"];
            self.freshAutoLoginview = [[[OrangeGreenFruitBundle mainBundle] loadNibNamed:@"GreenFruitNewAotuLoginViewBlackCustomControl" owner:self options:nil] lastObject];
            [self.freshAutoLoginview autoLoginReuest:completionBlock];//在这里声明了回调信息
            [self pop_CustomNativeByte_SDKView:self.freshAutoLoginview CompletionBlock:completionBlock];
        }
        
    }else{
        self.otherWayLoginView = [[[OrangeGreenFruitBundle mainBundle]loadNibNamed:@"GreenFruitOtherWayLoginBlackCustomControl" owner:self options:nil]lastObject];
        self.otherWayLoginView.completionBlock = completionBlock;
        [self pop_CustomNativeByte_SDKView:self.otherWayLoginView CompletionBlock:completionBlock];
   
    }
    
}

- (void)pop_CustomNativeByte_SDKView:(UIView*)view CompletionBlock:(GreenFruit_CustomNativeByte_SDKLoginCompletionBlock)completionBlock{
    
        OrangeZJAnimationPopView *popView = [[OrangeZJAnimationPopView alloc] initWith_CustomNativeByte_CustomView:view popStyle:ZJAnimationPopStyleNO dismissStyle:ZJAnimationDismissStyleNO];
        popView.popBGAlpha = 0;
        popView.isObserver_CustomNativeByte_OrientationChange = YES;
        [self handleCustom_CustomNativeByte_ActionEnvent:popView customerView:view CompletionBlock:completionBlock];
        [popView pop];
}

//#pragma mark 处理自定义视图操作事件
- (void)handleCustom_CustomNativeByte_ActionEnvent:(OrangeZJAnimationPopView *)popView customerView:(UIView*)customerView CompletionBlock:(GreenFruit_CustomNativeByte_SDKLoginCompletionBlock)completionBlock{
    if ([customerView isKindOfClass:[GreenFruitNewAotuLoginViewBlackCustomControl class]]){
        //自动登录
        GreenFruitNewAotuLoginViewBlackCustomControl *autoLoginView = (GreenFruitNewAotuLoginViewBlackCustomControl*)customerView;
        autoLoginView.autoLoginBlock = ^(GreenFruitNewAotuLoginViewBlackCustomControl *signView) {
            [popView dismiss];
        };
        autoLoginView.changeLoginBlock = ^(GreenFruitNewAotuLoginViewBlackCustomControl *signView, UIButton *button) {
            
            [popView dismiss];
            
            [[OrangeGreenFruitNetworking shaerdInstance] cancleAllRequest];//关闭所有请求
            
            //*** 设置不允许回调
            [self disAllowLogin];
            //设置是否允许登录状态
            [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:@"AllowLoginType"];
            //设置正在登录状态  点击切换
            [[NSUserDefaults standardUserDefaults]setObject:@"2" forKey:@"loginingType"];
            
            //跳转新的登录页
            self.floatSpreadView = [[[OrangeGreenFruitBundle mainBundle]loadNibNamed:@"GreenFruitFloatSpreadViewBlackCustomControl" owner:self options:nil]lastObject];
            self.floatSpreadView.completionBlock = completionBlock;
            [self pop_CustomNativeByte_SDKView:self.floatSpreadView CompletionBlock:completionBlock];
            
        };
        autoLoginView.autoLoginFailure = ^{
            [popView dismiss];
        };
    }
    else if ([customerView isKindOfClass:[GreenFruitFloatSpreadViewBlackCustomControl class]]){//自定义的展开视图--实名认证等
        GreenFruitFloatSpreadViewBlackCustomControl * spreadView = (GreenFruitFloatSpreadViewBlackCustomControl *)customerView;
        spreadView.goBackClickedBlock = ^{
            [popView dismiss];
        };
        spreadView.loginSuccessBlock = ^{//回调的block拿到了信息
          
            spreadView.completionBlock = completionBlock;
            [popView dismiss];
        };
        spreadView.cacheCleanSuccessBlock = ^{
            [popView dismiss];//取消上一个界面
            self.otherWayLoginView = [[[OrangeGreenFruitBundle mainBundle]loadNibNamed:@"GreenFruitOtherWayLoginBlackCustomControl" owner:self options:nil]lastObject];
            self.otherWayLoginView.completionBlock = completionBlock; 
            [self pop_CustomNativeByte_SDKView:self.otherWayLoginView CompletionBlock:completionBlock];
        };
    }
    else if ([customerView isKindOfClass:[GreenFruitOtherWayLoginBlackCustomControl class]]){
        //这里是应用无缓存时，直接加载多方式登录页面的操作控制
        GreenFruitOtherWayLoginBlackCustomControl * otherWayLogin = (GreenFruitOtherWayLoginBlackCustomControl *)customerView;
        otherWayLogin.goBackClickedBlock = ^{
            [popView dismiss];
        };
        otherWayLogin.completionBlock = ^(GreenFruit_CustomNativeByte_SDKUser *user, NSString *code) {
            if (self.loginCompletionBlock) {
                self.loginCompletionBlock(user, code);
            }
        };
    }
    else if ([customerView isKindOfClass:[GreenFruitRealIdentityCheckViewBlackCustomControl class]]){
        GreenFruitRealIdentityCheckViewBlackCustomControl * realIdentityView = (GreenFruitRealIdentityCheckViewBlackCustomControl *)customerView;
        realIdentityView.gobackClickBlock = ^{
            [popView dismiss];
        };
        realIdentityView.comeBackToSDKBlock = ^{
            [popView dismiss];
        };
        
    }
    else if ([customerView isKindOfClass:[GreenFruitBoundPhoneViewBlackCustomControl class]]){
        GreenFruitBoundPhoneViewBlackCustomControl * boundPhoneView = (GreenFruitBoundPhoneViewBlackCustomControl *)customerView;
        boundPhoneView.goBackClickBlock = ^{
            [popView dismiss];
        };
        boundPhoneView.comebackToSDKBlock = ^{
            [popView dismiss];
        };
    }
}

//跳转到平台支付页面
-(void)jumpToSystemPayVC:(UIViewController *)rootVC andSDKPay:(GreenFruit_CustomNativeByte_SDKPay *)pay{
    OrangeGreenFruitPayForViewController *payForVC = [[OrangeGreenFruitPayForViewController alloc] init];
    payForVC.payInfo = pay;
    UINavigationController *payForNVC = [[UINavigationController alloc] initWithRootViewController:payForVC];
    [rootVC presentViewController:payForNVC animated:YES completion:nil];
}

- (void)pop_CustomNativeByte_SDKView:(UIView*)view popView:(OrangeZJAnimationPopView*)backPopView CompletionBlock:(GreenFruit_CustomNativeByte_SDKLoginCompletionBlock)completionBlock{
    [backPopView dismiss];
    OrangeZJAnimationPopView *popView = [[OrangeZJAnimationPopView alloc] initWith_CustomNativeByte_CustomView:view popStyle:ZJAnimationPopStyleNO dismissStyle:ZJAnimationDismissStyleNO];
    popView.popBGAlpha = 0.0f;
    popView.isObserver_CustomNativeByte_OrientationChange = YES;
  
    if ([view isKindOfClass:[GreenFruitFloatSpreadViewBlackCustomControl class]]){
        self.floatSpreadView.popView = popView;
    }
    [self handleCustom_CustomNativeByte_ActionEnvent:popView customerView:view CompletionBlock:completionBlock];
    [popView pop];
}


#pragma mark ---退出登录
- (void)GreenFruitLogoutRootVC:(UIViewController*)rootVC CompletionBlock:(GreenFruit_CustomNativeByte_SDKLogoutCompletionBlock)completionBlock{
    
    self.logoutCompletionBlock = completionBlock;
    
    //重置正在登录状态
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"loginingType"];
    
    //先判断是否激活过
    NSString * activeStyle = User_Defaults_Get(@"ActiveStyle");
    if (![activeStyle isEqualToString:@"Yes"]) {
        [OrangeMBManager show_CustomNativeByte_BriefAlert:@"未初始化" time:1.0f];
        
        if (self.logoutCompletionBlock) {//退出接口的返回信息
            self.logoutCompletionBlock(@"-999");
        }

        return;
    }
    
    NSNumber *loginStatus = [OrangeInfoArchive getLoginStatus];
    if(!loginStatus.boolValue){
        [OrangeMBManager show_CustomNativeByte_BriefAlert:@"未登录" time:1];
        
        if (self.logoutCompletionBlock) {//退出接口的返回信息
            self.logoutCompletionBlock(@"-999");
        }
        
        return;
    }
    
    NSString *userId = [OrangeInfoArchive getUserId];
    [OrangeAPIParams requestLogoutUserId:userId SuccessBlock:^(id response) {
       
        NSDictionary *element = (NSDictionary*)response;

        OrangeRespondModel *model = [OrangeRespondModel yy_modelWithJSON:element];
        if(model.code == 200){
            NSMutableDictionary *loginDic = [NSMutableDictionary dictionary];
            loginDic[@"login"] = @"0";
            
            [OrangeInfoArchive putLoginStatus:[NSNumber numberWithBool:false]];
            [[NSNotificationCenter defaultCenter] postNotificationName:logout_notification object:loginDic];
            
        }else{
            NSLog(@"退出接口返回异常");
        }
        
        NSString * status = [NSString stringWithFormat:@"%@",element[@"code"]];
        if (self.logoutCompletionBlock) {//退出接口的返回信息
            self.logoutCompletionBlock(status);
        }
        
    } failedblock:^(NSError *error) {
      
        if(error.code == 4){
            [OrangeMBManager show_CustomNativeByte_BriefAlert:@"网络异常" time:1];
        }else{
            [OrangeMBManager show_CustomNativeByte_BriefAlert:@"异常错误" time:1];
        }
        if (self.logoutCompletionBlock) {//退出接口的返回信息
            self.logoutCompletionBlock(@"-999");
        }
    }];
}

#pragma mark ---设置角色信息
- (void)GreenFruitSettingRoleDataWithRootVC:(UIViewController*)rootVC roleData:(GreenFruit_CustomNativeByte_SDKRoleData*)roleData CompletionBlock:(GreenFruit_CustomNativeByte_SDKSettingRoleDataCompletionBlock)completionBlock{
    
    //先判断是否激活过
    NSString * activeStyle = User_Defaults_Get(@"ActiveStyle");
    if (![activeStyle isEqualToString:@"Yes"]) {
        [OrangeMBManager show_CustomNativeByte_BriefAlert:@"未初始化" time:1.0f];
        return;
    }
    
    NSNumber *loginStatus = [OrangeInfoArchive getLoginStatus];
    if(!loginStatus.boolValue){
        [OrangeMBManager show_CustomNativeByte_BriefAlert:@"未登录" time:1];
        return;
    }

    self.setRoleDataCompletionBlock = completionBlock;
    
    [OrangeAPIParams requestSettingRole:roleData SuccessBlock:^(id response) {
        NSDictionary *element = (NSDictionary*)response;
        
        NSString * status = [NSString stringWithFormat:@"%@",element[@"code"]];
       
        
        OrangeRespondModel *model = [OrangeRespondModel yy_modelWithJSON:element];
        if(model.code == 200){
            NSLog(@"角色设置成功");

        }else{
            NSLog(@"角色设置失败");
        }
        if (self.setRoleDataCompletionBlock) {
            self.setRoleDataCompletionBlock(status);
        }
        
    } failedblock:^(NSError *error) {
        
        if (self.setRoleDataCompletionBlock) {
            self.setRoleDataCompletionBlock(@"-999");
        }
        
        if(error.code == 4){
            [OrangeMBManager show_CustomNativeByte_BriefAlert:@"网络异常" time:1];
        }else{
            [OrangeMBManager show_CustomNativeByte_BriefAlert:@"异常错误" time:1];
        }
    }];
    
}

#pragma mark 平台支付
- (void)GreenFruitPayDataWithRootVC:(UIViewController*)rootVC pay:(GreenFruit_CustomNativeByte_SDKPay*)pay{
    
    //先判断是否激活过
    NSString * activeStyle = User_Defaults_Get(@"ActiveStyle");
    if (![activeStyle isEqualToString:@"Yes"]) {
        [OrangeMBManager show_CustomNativeByte_BriefAlert:@"未初始化" time:1.0f];
        return;
    }
    
    NSNumber *loginStatus = [OrangeInfoArchive getLoginStatus];
    if(!loginStatus.boolValue){
        [OrangeMBManager show_CustomNativeByte_BriefAlert:@"未登录" time:1];
        return;
    }
    //支付前，需先进行实名认证判断，根据接口返回信息进行跳转
    
    self.tempRootVC = rootVC;
    self.tempPay = pay;
    
    NSString * userId = [OrangeInfoArchive getUserId];
    [OrangeAPIParams requestNewCheckIdentifyUserid:userId successblock:^(id response) {
        
        NSDictionary * infoDic = (NSDictionary *)response;
        
        NSString * status = [NSString stringWithFormat:@"%@",infoDic[@"code"]];
        if ([status isEqualToString:@"200"]) {
            [OrangeMBManager show_CustomNativeByte_BriefAlert:@"已经实名认证过" time:1.0f];
            
            OrangeGreenFruitPayForViewController *payForVC = [[OrangeGreenFruitPayForViewController alloc] init];
            payForVC.payInfo = pay;
            UINavigationController *payForNVC = [[UINavigationController alloc] initWithRootViewController:payForVC];
            [rootVC presentViewController:payForNVC animated:YES completion:nil];
            
        }
        else if ([status isEqualToString:@"528"]){
            NSDictionary * componentDic = infoDic[@"content"];
            
            NSString * operationStr = [NSString stringWithFormat:@"%@",componentDic[@"component"]];
            if ([operationStr isEqualToString:@"skip"]) {//不加载实名认证界面
                OrangeGreenFruitPayForViewController *payForVC = [[OrangeGreenFruitPayForViewController alloc] init];
                payForVC.payInfo = pay;
                UINavigationController *payForNVC = [[UINavigationController alloc] initWithRootViewController:payForVC];
                [rootVC presentViewController:payForNVC animated:YES completion:nil];
            }
            else if ([operationStr isEqualToString:@"identity"]){//跳转实名认证界面
                self.realNameCheckView = [[[OrangeGreenFruitBundle mainBundle]loadNibNamed:@"GreenFruitRealIdentityCheckViewBlackCustomControl" owner:self options:nil]lastObject];
                self.realNameCheckView.JumpviewType = @"SDKView";
                [self pop_CustomNativeByte_SDKView:self.realNameCheckView CompletionBlock:self.realNameCheckView.completionBlock];
            }
            else if ([operationStr isEqualToString:@"phone"]){//跳转绑定手机界面
                self.boundPhoneView = [[[OrangeGreenFruitBundle mainBundle]loadNibNamed:@"GreenFruitBoundPhoneViewBlackCustomControl" owner:self options:nil]lastObject];
                self.boundPhoneView.jumpViewType = @"SDKView";
                [self pop_CustomNativeByte_SDKView:self.boundPhoneView CompletionBlock:self.boundPhoneView.completionBlock];

            }else{
                NSLog(@"其他操作");
            }
        }
        else{
            NSString * message = [NSString stringWithFormat:@"%@",infoDic[@"message"]];
            [OrangeMBManager show_CustomNativeByte_BriefAlert:message time:1.0f];
        }
        
    } failedblock:^(NSError *error) {
//        NSLog(@"错误:%@",error);
        if(error.code == 4){
            [OrangeMBManager show_CustomNativeByte_BriefAlert:@"网络异常" time:1];
        }else{
            [OrangeMBManager show_CustomNativeByte_BriefAlert:@"异常错误" time:1];
        }
    }];
    
}

#pragma mark 内购
- (void)GreenFruitPayByStoreIAP:(UIViewController*)rootVC pay:(GreenFruit_CustomNativeByte_SDKPay*)pay{
    
    //先判断是否激活过
    NSString * activeStyle = User_Defaults_Get(@"ActiveStyle");
    if (![activeStyle isEqualToString:@"Yes"]) {
        [OrangeMBManager show_CustomNativeByte_BriefAlert:@"未初始化" time:1.0f];
        return;
    }
    
    NSNumber *loginStatus = [OrangeInfoArchive getLoginStatus];
    if(!loginStatus.boolValue){
        [OrangeMBManager show_CustomNativeByte_BriefAlert:@"未登录" time:1];
        return;
    }
    
    [OrangeMBManager showWaitingWithTitle:@"购买中" inView:rootVC.view];
    [OrangeAPIParams requestSwitchPayWithPayInfo:pay SuccessBlock:^(id response) {
        NSDictionary *element = (NSDictionary*)response;
        OrangeSwitchPayModel *payModel = [OrangeSwitchPayModel yy_modelWithJSON:element];
        if(payModel.code == 200){
            NSString *type = payModel.content.type;
            NSLog(@"服务器返回开关：%@",type);
            if([type isEqualToString:@"1"]){
                
                NSLog(@"进入苹果内购了---dadada");
                [[OrangeGreenFruitPayStore alloc] payGreenFruit_CustomNativeByte_SDKPay:pay];
                
                [self startPay];
                
            }else if ([type isEqualToString:@"2"]){
                
                OrangeGreenFruitPayForViewController *payForVC = [[OrangeGreenFruitPayForViewController alloc] init];
                payForVC.payInfo = pay;
                UINavigationController *payForNVC = [[UINavigationController alloc] initWithRootViewController:payForVC];
                [rootVC presentViewController:payForNVC animated:YES completion:nil];
            }
        }else{
            [OrangeMBManager show_CustomNativeByte_BriefAlert:@"支付失败" time:1];
        }
    } failedblock:^(NSError *error) {
         [OrangeMBManager hideAlert];
    }];

}
    
//创建悬浮球
- (void)createFloatinBall:(UIViewController*)rootVC{
    
    self.floating = [[OrangeGreenFruitFloatingBall alloc] initWithFrame:CGRectMake(0, 200, 56, 56) inSpecifiedView:rootVC.view effectiveEdgeInsets:UIEdgeInsetsZero];

    // 自动靠边
    self.floating.autoCloseEdge = YES;
    self.floating.autoEdgeOffSet = YES;
    self.floating.edgePolicy = GreenFruitFloatingBallEdgePolicyLeftRight;
    self.isSpreaded = NO;//刚创建后，展开状态为No
    self.isHalfOffset = YES;//创建时为半隐藏
    self.floating.isTatalShow = NO;
    
    NSString * highImgString = User_Defaults_Get(@"HighlightPicture");
//    NSString * nomalImgString = User_Defaults_Get(@"NormalPicture");
    NSURL * hightimgUrl = [NSURL URLWithString:highImgString];
    UIImage * floatImageview = [UIImage imageWithData:[NSData dataWithContentsOfURL:hightimgUrl]];
    [self.floating setContent:floatImageview contentType:GreenFruitFloatingBallContentTypeImage];

    [self.floating autoEdgeRetractDuration:0.5f edgeRetractConfigHander:^GreenFruitEdgeRetractConfig{
        return GreenFruitEdgeOffsetConfigMake(CGPointMake(28, 28), 0.7f);
    }];
    
    self.floating.delegate = self;//***
//    //****之前版本
//    self.floating.clickHandler = ^(OrangeGreenFruitFloatingBall * _Nonnull floatingBall) {
//
//        //***
//        OrangeGreenFruitCenterViewController *centerVC = [[OrangeGreenFruitCenterViewController alloc] init];
//        centerVC.bindPhoneViewBlock = ^{
//
//            NSLog(@"记录此处操作 1.0 ");
//
//            [weak_self centerpop_CustomNativeByte_SDKView:bindView];
//
//        };
//        if(floatingBall.autoEdgeOffSet){//如果为半隐藏，则全部打开悬浮球
//
//            NSLog(@"完全打开悬浮球");
//            [floatingBall floatingBallShowAll];
//
//
//        }else{//如果全部打开，则跳转到操作中心
//
//            NSLog(@"点击了悬浮球--即将出现用户操作页面");
//
//            UINavigationController *centerNVC = [[UINavigationController alloc] initWithRootViewController:centerVC];
//
//            [centerNVC setNavigationBarHidden:YES];
//
//            centerVC.userName = [OrangeInfoArchive getAccountName];
//
//            centerVC.userid = [OrangeInfoArchive getUserId];
//
//            NSLog(@"传值 username %@ 和userid %@",centerVC.userName,centerVC.userid);
//
//            [rootVC presentViewController:centerNVC animated:YES completion:nil];
//
//        }
//    };
    //****
}

- (void)didClickFloatingBall:(OrangeGreenFruitFloatingBall *)floatingBall{

    if(self.floating.isTatalShow == NO){//如果为半隐藏，则全部打开悬浮球

        [floatingBall floatingBallShowAll];
        
        floatingBall.autoEdgeOffSet = NO;
        
    }else{//不是半隐藏
        
        if (self.isSpreaded == NO) {//如果还没打开操作视图
            floatingBall.autoCloseEdge = NO;
            floatingBall.weatherClose = NO;

            //保持悬浮球不动
            [self.floating autoEdgeRetractDuration:0.5f edgeRetractConfigHander:^GreenFruitEdgeRetractConfig{
                
                return GreenFruitEdgeOffsetConfigMake(CGPointMake(0, 0), 1);
                
            }];
            
            //先区分横屏竖屏
            if (floatingBall.frame.origin.x+28<kScreenWidth/2) {//在屏幕左侧
                self.rightFloatBackView.alpha = 0;
                if (self.floatBackView == nil) {
                    [self initLeftSpreadView:floatingBall];
                    [kWindow addSubview:self.floatBackView];
                }else{
                    self.floatBackView.frame = CGRectMake(0, floatingBall.frame.origin.y, 270, 56) ;
                }
                self.floatBackView.alpha = 1;
                floatingBall.frame = CGRectMake(0, self.floatBackView.frame.origin.y, 56, 56);
                [kWindow addSubview:floatingBall];
            }
            else{//在屏幕右侧
                self.floatSpreadView.alpha = 0;
                if (self.rightFloatBackView == nil) {
                    [self initRightSpreadView:floatingBall];
                    //[floatingBall.superview  同样可以加载
                    [kWindow addSubview:self.rightFloatBackView];
                }else{
                    self.rightFloatBackView.frame = CGRectMake(kScreenWidth-270, floatingBall.frame.origin.y, 270, 56) ;
                }
                self.rightFloatBackView.alpha = 1;
                
                floatingBall.frame = CGRectMake(kScreenWidth-56, self.rightFloatBackView.frame.origin.y, 56, 56);
                [kWindow addSubview:floatingBall];
            }
            //无论左右侧，只要有一个展开，则为展开状态
            self.isSpreaded = YES;
            //悬浮球操作视图展开（不论左侧右侧），取消拖动事件
            [floatingBall canclePanGestureMethod];
            floatingBall.autoEdgeOffSet = NO;
            self.isHalfOffset = NO;
            //保持悬浮球不动，同时展开操作视图
            floatingBall.isTatalShow = YES;

            self.minute = 5;
            self.removeTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(timerRemoveMethod) userInfo:nil repeats:YES];
            
        }else{

            floatingBall.weatherClose = YES;

            [self removeFloatbackView];
        }
    }
}

-(void)timerRemoveMethod{
    self.minute --;
    if (self.minute<1) {//5秒过后
        [self removeFloatbackView];
    }
}

//关闭操作视图，并初始化所有状态；使悬浮球靠边
-(void)removeFloatbackView{
    
    [self.removeTimer invalidate];
    self.removeTimer = nil;
    
    self.floatBackView.alpha = 0;
    self.rightFloatBackView.alpha = 0;
    self.floating.autoCloseEdge = YES;
    self.floating.autoEdgeOffSet = YES;
    self.isSpreaded = NO;
    self.isHalfOffset = YES;
    [self.floating openPanGestureMethod];
    [self.floating autoEdgeRetractDuration:0.5f edgeRetractConfigHander:^GreenFruitEdgeRetractConfig{
        return GreenFruitEdgeOffsetConfigMake(CGPointMake(28, 28), 0.7f);
    }];
}

//创建左侧悬浮球
-(void)initLeftSpreadView:(OrangeGreenFruitFloatingBall *)floatBall{
    self.floatBackView = [[UIView alloc]initWithFrame:CGRectMake(0, floatBall.frame.origin.y, 270, 56)];
    self.floatBackView.backgroundColor = [UIColor whiteColor];
    self.floatBackView.layer.cornerRadius = 28.0f;
   
    NSArray * titleArr = [[NSArray alloc]initWithObjects:@"Orange注销账号",@"Orange账户安全_2",@"Orange个人中心", nil];
    for (int i = 0; i<titleArr.count; i++) {
        int buttonWidth = 43.5;
        int buttonHeight = 40;
        UIButton * customButton = [[UIButton alloc]initWithFrame:CGRectMake(60+(30+buttonWidth)*i,8, buttonWidth, buttonHeight)];
        customButton.backgroundColor = [UIColor whiteColor];
        NSString * imgName = [NSString stringWithFormat:@"%@",titleArr[i]];
        NSString * imgPath = [[OrangeGreenFruitBundle mainBundle]pathForResource:imgName ofType:@"png"];
        [customButton setBackgroundImage:[UIImage imageWithData:[NSData dataWithContentsOfFile:imgPath]] forState:UIControlStateNormal];
        if (i<2) {
            UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(customButton.frame.origin.x+customButton.bounds.size.width+14.5, customButton.frame.origin.y, 1, customButton.bounds.size.height)];
            lineView.backgroundColor = [UIColor lightGrayColor];
            [self.floatBackView addSubview:lineView];
        }
        [customButton addTarget:self action:@selector(customMethod:) forControlEvents:UIControlEventTouchUpInside];
        customButton.tag = i+100;
        [self.floatBackView addSubview:customButton];
    }
    
}

//创建右侧悬浮球
-(void)initRightSpreadView:(OrangeGreenFruitFloatingBall *)floatBall{
    self.rightFloatBackView = [[UIView alloc]initWithFrame:CGRectMake(kScreenWidth-270, floatBall.frame.origin.y, 270, 56)];
    self.rightFloatBackView.backgroundColor = [UIColor whiteColor];
    self.rightFloatBackView.layer.cornerRadius = 28.0f;
    
    NSArray * titleArr = [[NSArray alloc]initWithObjects:@"Orange个人中心",@"Orange账户安全_2",@"Orange注销账号", nil];
    for (int i = 0; i<titleArr.count; i++) {
        int buttonWidth = 43.5;
        int buttonHeight = 40;
        UIButton * customButton = [[UIButton alloc]initWithFrame:CGRectMake(20+(buttonWidth+30)*i,8, buttonWidth, buttonHeight)];
        NSString * imageName = [NSString stringWithFormat:@"%@",titleArr[i]];
        NSString * imgPath = [[OrangeGreenFruitBundle mainBundle]pathForResource:imageName ofType:@"png"];
        [customButton setBackgroundImage:[UIImage imageWithData:[NSData dataWithContentsOfFile:imgPath]] forState:UIControlStateNormal];
        customButton.backgroundColor = [UIColor whiteColor];
        if (i<2) {
            UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(customButton.frame.origin.x+customButton.bounds.size.width+14.5, customButton.frame.origin.y, 1, customButton.bounds.size.height)];
            lineView.backgroundColor = [UIColor lightGrayColor];
            [self.rightFloatBackView addSubview:lineView];
        }
        [customButton addTarget:self action:@selector(customRightMethod:) forControlEvents:UIControlEventTouchUpInside];
        customButton.tag = i+200;
        [self.rightFloatBackView addSubview:customButton];
    }
    
}

//左侧悬浮球功能方法
-(void)customMethod:(UIButton *)sender{
    NSInteger code = sender.tag-100;
    
    [self removeFloatbackView];
    
    
    switch (code) {
        case 0:
        {
            [self showAlertViewMethod];
            
        }
            break;
        case 1:
        {
            self.accountClickView = [[[OrangeGreenFruitBundle mainBundle]loadNibNamed:@"GreenFruitAccountClickSpreadViewBlackCustomControl" owner:self options:nil]lastObject];
            //可以进行信息回调的跳转，这里暂未使用
            [self centerpop_CustomNativeByte_SDKView:self.accountClickView];
            
        }
            break;
        case 2:
        {
            //请求个人中心地址的token
            [self requestForUserToken];
        }
            break;

        default:
            break;
    }
}

-(void)showAlertViewMethod{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"确定要进行注销吗" preferredStyle:UIAlertControllerStyleAlert];
    [self.rVC presentViewController:alert animated:YES completion:nil];
    
    UIAlertAction * ensureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self logoutMethod];
    }];
    [alert addAction:ensureAction];
    UIAlertAction * cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alert addAction:cancleAction];
}

-(void)logoutMethod{
    
    //重置正在登录状态
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"loginingType"];
    
    NSNumber *loginStatus = [OrangeInfoArchive getLoginStatus];
    if(!loginStatus.boolValue){
        [OrangeMBManager show_CustomNativeByte_BriefAlert:@"未登录" time:1];
        return;
    }
    NSString *userId = [OrangeInfoArchive getUserId];
    [OrangeAPIParams requestLogoutUserId:userId SuccessBlock:^(id response) {
        NSDictionary *element = (NSDictionary*)response;
        
        OrangeRespondModel *model = [OrangeRespondModel yy_modelWithJSON:element];
        if(model.code == 200){
            NSMutableDictionary *loginDic = [NSMutableDictionary dictionary];
            loginDic[@"login"] = @"0";
            
            [OrangeInfoArchive putLoginStatus:[NSNumber numberWithBool:false]];
            [[NSNotificationCenter defaultCenter] postNotificationName:logout_notification object:loginDic];
            
            NSString * status = [NSString stringWithFormat:@"%ld",(long)model.code];
            if (self.logoutStatusBlock) {
                self.logoutStatusBlock(status);
            }
            
        }else{
            NSString * message = [NSString stringWithFormat:@"%@",element[@"message"]];
            [OrangeMBManager show_CustomNativeByte_BriefAlert:message time:1.0f];
            
            if (self.logoutStatusBlock) {
                self.logoutStatusBlock(@"-999");
            }
        }
        
    } failedblock:^(NSError *error) {
        if (self.logoutStatusBlock) {
            self.logoutStatusBlock(@"-999");
        }
        if(error.code == 4){
            [OrangeMBManager show_CustomNativeByte_BriefAlert:@"网络异常" time:1];
        }else{
            [OrangeMBManager show_CustomNativeByte_BriefAlert:@"异常错误" time:1];
        }
    }];
}

-(void)customRightMethod:(UIButton *)sender{
    NSInteger code = sender.tag-200;
    
    [self removeFloatbackView];
    
    switch (code) {
        case 0:
        {
            self.floating.autoCloseEdge = YES;

            
            [self requestForUserToken];
            
        }
            break;
        case 1:
        {
            
            self.accountClickView = [[[OrangeGreenFruitBundle mainBundle]loadNibNamed:@"GreenFruitAccountClickSpreadViewBlackCustomControl" owner:self options:nil]lastObject];
            //可以进行信息回调的跳转，这里暂未使用
            [self centerpop_CustomNativeByte_SDKView:self.accountClickView];
            
        }
            break;
        case 2:
        {
            [self showAlertViewMethod];
            
        }
            break;
        default:
            break;
    }
    
}

//客服中心调用方法
-(void)requestForUserToken{
    [OrangeAPIParams requestForUserCenterTokenwithSuccessBlock:^(id response) {
        NSDictionary * infoDic = (NSDictionary *)response;
        
        NSString * status = [NSString stringWithFormat:@"%@",infoDic[@"code"]];
        if ([status isEqualToString:@"200"]) {
            [OrangeMBManager show_CustomNativeByte_BriefAlert:@"获取成功" time:1.0f];
            
            NSDictionary * contentDic = infoDic[@"content"];
            self.token = [NSString stringWithFormat:@"%@",contentDic[@"token"]];
            /*
             【链接】{{userInfo.userName}}{{userInfo....
             http://api.17173g.cn/sdk-center/mine.html
             */
            OrangeGreenFruitUserCenterNewViewController * userCenterVC = [[OrangeGreenFruitUserCenterNewViewController alloc]init];
            NSString * urlString = [NSString stringWithFormat:@"http://api.17173g.cn/sdk-center/mine.html?token=%@",self.token];

            userCenterVC.webViewUrl = urlString;
            [self.floating hide];
            userCenterVC.notificationBlock = ^{
                [self.floating show];//一旦按返回按钮，则使悬浮球出现
            };
            [self.rVC presentViewController:userCenterVC animated:YES completion:nil];
            
        }else{
            NSString * message = [NSString stringWithFormat:@"%@",infoDic[@"message"]];
            [OrangeMBManager show_CustomNativeByte_BriefAlert:message time:1.0f];
        }
        
    } failedBlock:^(NSError *error) {
        
        if(error.code == 4){
            [OrangeMBManager show_CustomNativeByte_BriefAlert:@"网络异常" time:1];
        }else{
            [OrangeMBManager show_CustomNativeByte_BriefAlert:@"异常错误" time:1];
        }
    }];
    
}


-(void)deleteBackViewMethod:(UITapGestureRecognizer *)tap{
    
    [tap.view.superview removeFromSuperview];
    
}

- (void)centerpop_CustomNativeByte_SDKView:(UIView*)view{
    OrangeZJAnimationPopView *popView = [[OrangeZJAnimationPopView alloc] initWith_CustomNativeByte_CustomView:view popStyle:ZJAnimationPopStyleNO dismissStyle:ZJAnimationDismissStyleNO];
    if(popView.isPop){
        [popView dismiss];
    }
    popView.popBGAlpha = 0;
    popView.isObserver_CustomNativeByte_OrientationChange = YES;
    [self handleCenterCustomActionEnvent:popView customerView:view];
    [popView pop];
}

#pragma mark -- 个人中心事件处理
- (void)handleCenterCustomActionEnvent:(OrangeZJAnimationPopView *)popView customerView:(UIView*)customerView{
  if ([customerView isKindOfClass:[GreenFruitAccountClickSpreadViewBlackCustomControl class]]){
        GreenFruitAccountClickSpreadViewBlackCustomControl * accountCLickView = (GreenFruitAccountClickSpreadViewBlackCustomControl *)customerView;
        accountCLickView.goBackClickedBlock = ^{
            [popView dismiss];
        };
        accountCLickView.dismissPopViewBlock = ^{//取消第一层页面
            [popView dismiss];
        };
    }
}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:login_notification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:logout_notification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:payfinish object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:payverify_notification object:nil];
    //关闭定时器
    [self.removeTimer setFireDate:[NSDate distantFuture]];  //很远的将来
    
}

////内购回调接口
//-(void)GreenFruitIAPPayReturnMethodWithCompletionBlock:(GreenFruit_CustomNativeByte_SDKPayBackBlock *)completionBlock{
//
////    if (self.payBackCompletionBlock == nil) {
//        NSLog(@"设置内购的回调");
//        self.payBackCompletionBlock = completionBlock;
//
////    }
////    else{
////        NSLog(@"支付已经设置过值");
////        self.payBackCompletionBlock = nil;
////    }
//
//}

-(void)GreenFruitIAPPayReturnMethodWithCompletionBlock:(GreenFruit_CustomNativeByte_SDKPayBackBlock)completionBlock{
    
    self.payBackCompletionBlock = completionBlock;
    
}

#pragma mark - 登录退出通知方法
- (void)loginOrLogoutNotification:(NSNotification*)notification{
    NSDictionary *info = notification.object;
    NSString *login = info[@"login"];
    NSString *floatModel = info[@"floatModel"];
    
    if(login.integerValue){
        [self createFloatinBall:self.rVC];
        self.loginStatus = YES;
        
        //登录成功后开启支付结果监听,并检查是否有本地支付订单
        [[OrangeGreenFruitIAPManager share_CustomNativeByte_Manager] addTransactionObserver];
        [[OrangeGreenFruitIAPManager share_CustomNativeByte_Manager] resetRetry];
        [[OrangeGreenFruitIAPManager share_CustomNativeByte_Manager] checkLocalOrder:@"2"];
        
        //根据通知返回的悬浮球状态判断是展示 还是 隐藏
        if (floatModel == nil) {
            [self.floating show];
        }
        else if (floatModel.integerValue != 2) {
            [self.floating show];
        }
        else{
            NSLog(@"floating hide");
            NSLog(@"处理完毕");
            [self.floating hide];

        }
    }else{
        self.loginStatus = NO;
        
        [self.floating hide];
    }
    
}

- (void)payFinishNotification:(NSNotification*)notification{
    [OrangeMBManager hideAlert];
    NSDictionary *info = notification.object;
    NSNumber *result = info[@"result"];
    
    
    if([self isPay]){
        if(result.boolValue){
            [OrangeMBManager show_CustomNativeByte_BriefAlert:@"购买成功" time:2];

//            NSLog(@"支付成功啦啦啦");
            //给小游戏版本的前端支付回调
            if (self.payBackCompletionBlock) {
                self.payBackCompletionBlock(@"200");
            }
            
//#ifdef SMALLGAME
//            UnitySendMessage("GameApp","IOS_SmallPaySuccess", "1");
//            [self sayHello];
//#else
//#endif
        }else{
            [OrangeMBManager show_CustomNativeByte_BriefAlert:@"购买失败"];
            if (self.payBackCompletionBlock) {
                self.payBackCompletionBlock(@"0");
            }
        }
    }
    [self canclePay];
}

-(void)sayHello{
    NSLog(@"支付成功了-啊啊咔咔咔看");
}

/**
 支付验证
 @param notification
 */
- (void)payVerifyNotification:(NSNotification*)notification{
    NSDictionary *info = notification.object;
    NSString *orderNo = info[@"orderNo"];
    NSString *receiptData = info[@"data"];
    NSString *type = info[@"type"];//调起类型 1-在线支付调起，2-离线支付调起
    
    [OrangeAPIParams requestVerifyPruchase:orderNo data:receiptData SuccessBlock:^(id response) {
        NSDictionary *element = (NSDictionary*)response;
        OrangeVerifyModel *verifyModel =[OrangeVerifyModel yy_modelWithJSON:element];
        if(verifyModel.code == 200){
            //成功后先删除对应订单号
            [OrangeFileManager delDic:orderNo];
            if([type isEqualToString:@"1"]){
                [OrangeMBManager show_CustomNativeByte_BriefAlert:@"凭证验证成功"];
                NSLog(@"凭证验证成功");
                NSMutableDictionary *payDic = [NSMutableDictionary dictionary];
                payDic[@"result"] = [NSNumber numberWithBool:YES];
                [[NSNotificationCenter defaultCenter] postNotificationName:payfinish object:payDic];
            }
            else{
                //如果是离线支付成功，删除订单，并且检查是否存在下一条
                NSLog(@"离线订单服务端验证成功");
                [[OrangeGreenFruitIAPManager share_CustomNativeByte_Manager] checkLocalOrder:type];
            }
            
        }else{
            //失败后(服务端通讯成功)，也删除订单号
            [OrangeFileManager delDic:orderNo];
            if([type isEqualToString:@"1"]){
                [OrangeMBManager show_CustomNativeByte_BriefAlert:@"凭证验证失败"];
                NSMutableDictionary *payDic = [NSMutableDictionary dictionary];
                payDic[@"result"] = [NSNumber numberWithBool:NO];;
                [[NSNotificationCenter defaultCenter] postNotificationName:payfinish object:payDic];
            }
            else{
                //如果是离线支付服务器验证失败，(那么将订单移到另外一个plist文件保存，以防止订单丢失,待确定)
                NSLog(@"离线订单服务端验证失败,可能回调游戏服务器失败");
                [[OrangeGreenFruitIAPManager share_CustomNativeByte_Manager] checkLocalOrder:type];
//              [OrangeFileManager saveReceiptValidation:receiptData orderNum:orderNo file:@"order_error.plist"];
            }
        }
    } failedblock:^(NSError *error) {
        if([[OrangeGreenFruitIAPManager share_CustomNativeByte_Manager] isRetryMax]){
            NSLog(@"达到最大重试次数,支付类型:%@",type);
            if([type isEqualToString:@"1"]){
                //在线支付达到最大重试次数后，将订单写入plist缓存
                //[OrangeFileManager saveReceiptValidation:receiptData orderNum:orderNo file:@"order.plist"];
//                [self saveOrder:orderNo data:receiptData];
                NSLog(@"在线订单发送超过重试次数");
                NSMutableDictionary *payDic = [NSMutableDictionary dictionary];
                payDic[@"result"] = [NSNumber numberWithBool:NO];
                [[NSNotificationCenter defaultCenter] postNotificationName:payfinish object:payDic];
                [OrangeMBManager show_CustomNativeByte_BriefAlert:@"网络异常" time:1];
            }
            //离线支付达到最大重试次数后，不需要做任何处理，也不需要发起下一条
            return;
        }
        NSLog(@"未达到最大重试次数，发起支付重试");
        NSMutableDictionary *payDic = [NSMutableDictionary dictionary];
        payDic[@"orderNo"] = orderNo;
        payDic[@"data"] = receiptData;
        payDic[@"type"] = type;
        //再次发起支付，主线程通知
        [[NSNotificationCenter defaultCenter] postNotificationName:payverify_notification object:payDic];
    }];
}

-(void)postRequestMethod{
    
    NSLog(@"请求自定义post接口");
    [OrangeAPIParams postRequestMethodPakagedwithSuccessBlock:^(id response) {
        NSDictionary * infoDic = (NSDictionary *)response;
        NSLog(@"自定义post请求的数据为:%@",infoDic);
        
    } faildBlock:^(NSError *error) {
        NSLog(@"请求失败原因:%@",error);
        
    }];
}


- (void)startPay{
    self.isPaying = YES;
}

- (void)canclePay{
    self.isPaying = NO;
}

- (BOOL)isPay{
    return self.isPaying;
}

-(void)disAllowLogin{
    self.disAllowLoginType = YES;
}
-(void)allowLogin{
    self.disAllowLoginType = NO;
}



@end
