//
//  GreenFruitNewAotuLoginViewBlackCustomControl.m
//  GreenFruitframework
//
//  Created by 张 on 2018/12/19.
//  Copyright © 2018年 Hu. All rights reserved.
//

#import "GreenFruitNewAotuLoginViewBlackCustomControl.h"
#import "OrangeRespondModel.h"
#import "OrangeInfoArchive.h"
#import "OrangeAPIParams.h"
#import "OrangeGreenFruitConfig.h"
#import "OrangeMBManager.h"
#import "OrangeYYModel.h"
#import "OrangeUIView+FrameMethods.h"
#import "OrangeGreenFruit_CustomNativeByte_SDKCreate.h"
#import <TTTracker/TTTracker.h>
#import <TTTracker/TTTracker+Game.h>
#import <TTTracker/TTInstallIDManager.h>

@interface GreenFruitNewAotuLoginViewBlackCustomControl()
@property (nonatomic,retain)NSString * account;
@property (nonatomic,retain)NSString * password;
@property (nonatomic,retain)NSString * loginType;

@end

@implementation GreenFruitNewAotuLoginViewBlackCustomControl

- (void)awakeFromNib{
    [super awakeFromNib];
    
    [self initData];
    
    [self createBorder];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeRotate:) name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
    
}

-(void)initData{
    NSMutableArray * loginCacheArr = User_Defaults_Get(@"firstLoginCacheArr");
    NSDictionary * defaultLoginDic = loginCacheArr[loginCacheArr.count-1];
    
    self.account = [NSString stringWithFormat:@"%@",defaultLoginDic[@"LoginAccount"]];
    self.password = [NSString stringWithFormat:@"%@",defaultLoginDic[@"LoginPassword"]];
    self.loginType = [NSString stringWithFormat:@"%@",defaultLoginDic[@"LoginType"]];
    
    self.accountLabel.text = [NSString stringWithFormat:@"%@",self.account];
}

-(void)createBorder{
    self.changeLoginBtn.layer.cornerRadius = 20.0f;
    self.layer.cornerRadius = 5.f;
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];

}

- (void)layoutSubviews{
    
    
    if(([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait) || ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown)){
        //竖屏
        [self setNeedsLayout];
        [self setWidth:300];
        [self setHeight:220];
        self.center = CGPointMake(self.superview.bounds.size.width/2, self.superview.bounds.size.height/2);
    }else{
        //横屏
        if(IS_IPHONE){
            [self setNeedsLayout];
            [self setWidth:340];
            [self setHeight:220];
            self.center = CGPointMake(self.superview.bounds.size.width/2, self.superview.bounds.size.height/2);
        }else{
            //竖屏
            [self setNeedsLayout];
            [self setWidth:340];
            [self setHeight:220];
            self.center = CGPointMake(self.superview.bounds.size.width/2, self.superview.bounds.size.height/2);
        }
        
    }
}

#pragma mark -- 适配横屏竖屏
- (void)changeRotate:(NSNotification*)notification{
    [self changeOrientation];
    
}

- (void)changeOrientation{
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (orientation == UIInterfaceOrientationPortrait
        || orientation == UIInterfaceOrientationPortraitUpsideDown) {
        //竖屏
        [self verticalUI];
        [self setWidth:300];
        [self setHeight:220];
        
        self.center = CGPointMake(self.superview.bounds.size.width/2, self.superview.bounds.size.height/2);
        
    } else {
        //横屏
        if(IS_IPHONE){
            [self horizontalUI];
            [self setWidth:340];
            [self setHeight:220];
            self.center = CGPointMake(self.superview.bounds.size.width/2, self.superview.bounds.size.height/2);
        }else{
            [self verticalUI];
            [self setWidth:340];
            [self setHeight:220];
            self.center = CGPointMake(self.superview.bounds.size.width/2, self.superview.bounds.size.height/2);
        }
    }
}

-(void)verticalUI{
}

-(void)horizontalUI{
}


-(void)autoLoginReuest:(GreenFruit_CustomNativeByte_SDKLoginCompletionBlock)completionBlock{
    self.completionBlock = completionBlock;
    
    [self performSelector:@selector(loginReuest:) withObject:completionBlock afterDelay:3.0f];
    
    
}

- (UIViewController *)findSuperViewController:(UIView *)view
{
    UIResponder *responder = view;
    // 循环获取下一个响应者,直到响应者是一个UIViewController类的一个对象为止,然后返回该对象.
    while ((responder = [responder nextResponder])) {
        if ([responder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)responder;
        }
    }
    return nil;
}

- (void)loginReuest:(GreenFruit_CustomNativeByte_SDKLoginCompletionBlock)completionBlock{    
    
    //正在登录状态
//    NSString * loginingType = [[NSUserDefaults standardUserDefaults]objectForKey:@"loginingType"];
    
    
//    if([loginingType isEqualToString:@"1"] ){
//
//        NSLog(@"自动登录中：已登录或者正在登录");
////        self.loginCompletionBlock(nil, @"-999");
//
//        return;
//
//    }else{
//        NSLog(@"自动登录中：可以执行自动登录接口");
//    }
    
    //*****
    if ([self.loginType isEqualToString:@"Phone"]) {//如果以手机号登录，则调用手机号登录接口
        [OrangeAPIParams requestPhoneLogin:self.account password:self.password SuccessBlock:^(id response) {
            
            //判断正在登陆的状态  ，若点击过切换，则不进行自动登录的请求
            NSString * typeString = [[NSUserDefaults standardUserDefaults]objectForKey:@"AllowLoginType"];
            if ([typeString isEqualToString:@"1"]) {
                return ;
            }
            NSDictionary *element = (NSDictionary*)response;
            OrangeRespondModel *model = [OrangeRespondModel yy_modelWithJSON:element];
            
            if(model.code == 200){
                GreenFruit_CustomNativeByte_SDKUser *user = [GreenFruit_CustomNativeByte_SDKUser new];
                user.appId = Appid;
                user.channellevel1 = Channelleve1;
                user.channellevel2 = Channellevel2;
                user.userId = model.content.userid;
                user.accountname = [OrangeInfoArchive getAccountName];
                user.ssid = model.content.sid ? model.content.sid : @"";
                [OrangeInfoArchive putLoginStatus:[NSNumber numberWithBool:TRUE]];
                [OrangeInfoArchive putUserid:user.userId];
                [OrangeInfoArchive putSid:user.ssid];
                
                User_Defaules_Set(user.userId, @"USERID");
                
                //可以进行登录信息的回调，CP那边可以看到根据回调信息进行登录操作
                if(completionBlock){
                    NSString * codeStr = [NSString stringWithFormat:@"%ld",(long)model.code];
                    completionBlock(user,codeStr);
                }
                
                //处理悬浮球相关数据
                NSDictionary * contentDic = element[@"content"];
                NSString * highlight = [NSString stringWithFormat:@"%@",contentDic[@"highlight"]];
                NSString * normal = [NSString stringWithFormat:@"%@",contentDic[@"normal"]];
                NSString * refresh = [NSString stringWithFormat:@"%@",contentDic[@"refresh"]];
                if ([refresh isEqualToString:@"1"]) {//此时需要缓存图片信息
                    User_Defaules_Set(highlight, @"HighlightPicture");
                    User_Defaules_Set(normal, @"NormalPicture");
                    
                }else{
                    NSLog(@"不需要缓存悬浮球图片");
                }
                
                if(self.autoLoginBlock){
                    self.autoLoginBlock(self);
                }
                
                NSMutableDictionary *loginDic = [NSMutableDictionary dictionary];
                loginDic[@"login"] = @"1";
                loginDic[@"floatModel"] =  model.content.floatmodel;
                [[NSNotificationCenter defaultCenter] postNotificationName:login_notification object:loginDic];
                [OrangeMBManager show_CustomNativeByte_BriefAlert:@"登录成功" time:1];
                
                [[NSUserDefaults standardUserDefaults]setObject:@"3" forKey:@"loginingType"];
                
                /**头条登录埋点**/
                NSString * TAppid = [[NSUserDefaults standardUserDefaults]objectForKey:@"toutiaoAPPID"];
                NSString * TAppName = [[NSUserDefaults standardUserDefaults]objectForKey:@"toutiaoAPPNAME"];
                if (TAppid.length !=0 && TAppName.length != 0) {
                    NSLog(@"userID%@",USERID);
                    [[TTInstallIDManager sharedInstance] setCurrentUserUniqueID:USERID];
                    [TTTracker loginEventByMethod:@"mobile" isSuccess:YES];
                }
                
            }else{
                if(self.autoLoginFailure){
                    self.autoLoginFailure();
                }
                [OrangeMBManager show_CustomNativeByte_BriefAlert:model.message ? model.message : @"获取帐号失败" time:1];
            }
            
        } failedblock:^(NSError *error) {
            if(self.autoLoginFailure){
                self.autoLoginFailure();
            }
            if(error.code == 4){
                [OrangeMBManager show_CustomNativeByte_BriefAlert:@"网络异常" time:1];
            }else{
                [OrangeMBManager show_CustomNativeByte_BriefAlert:@"异常错误" time:1];
            }
        }];
    
    }else{
        
        [OrangeAPIParams requestLogin:self.account password:self.password SuccessBlock:^(id response) {
            //登录状态为1，则点击过切换按钮。此时不进行自动登录的登录请求
            NSString * typeString = [[NSUserDefaults standardUserDefaults]objectForKey:@"AllowLoginType"];
            if ([typeString isEqualToString:@"1"]) {
                return ;
            }
            NSDictionary *element = (NSDictionary*)response;
            OrangeRespondModel *model = [OrangeRespondModel yy_modelWithJSON:element];
            
            if(model.code == 200){
                GreenFruit_CustomNativeByte_SDKUser *user = [GreenFruit_CustomNativeByte_SDKUser new];
                user.appId = Appid;
                user.channellevel1 = Channelleve1;
                user.channellevel2 = Channellevel2;
                user.userId = model.content.userid;
                user.accountname = [OrangeInfoArchive getAccountName];
                user.ssid = model.content.sid ? model.content.sid : @"";
                [OrangeInfoArchive putLoginStatus:[NSNumber numberWithBool:TRUE]];
                [OrangeInfoArchive putUserid:user.userId];
                [OrangeInfoArchive putSid:user.ssid];
                
                User_Defaules_Set(user.userId, @"USERID");

                
                //可以进行登录信息的回调，CP那边可以看到根据回调信息进行登录操作
                if(completionBlock){
                    NSString * codeStr = [NSString stringWithFormat:@"%ld",(long)model.code];
                    completionBlock(user,codeStr);
                }
                
                
                //处理悬浮球相关数据
                NSDictionary * contentDic = element[@"content"];
                NSString * highlight = [NSString stringWithFormat:@"%@",contentDic[@"highlight"]];
                NSString * normal = [NSString stringWithFormat:@"%@",contentDic[@"normal"]];
                NSString * refresh = [NSString stringWithFormat:@"%@",contentDic[@"refresh"]];
                if ([refresh isEqualToString:@"1"]) {//此时需要缓存图片信息
                    User_Defaules_Set(highlight, @"HighlightPicture");
                    User_Defaules_Set(normal, @"NormalPicture");
                    
                }else{
                    NSLog(@"不需要缓存悬浮球图片");
                }
                
                if(self.autoLoginBlock){
                    self.autoLoginBlock(self);
                }
                
                NSMutableDictionary *loginDic = [NSMutableDictionary dictionary];
                loginDic[@"login"] = @"1";
                loginDic[@"floatModel"] =  model.content.floatmodel;
                [[NSNotificationCenter defaultCenter] postNotificationName:login_notification object:loginDic];
                [OrangeMBManager show_CustomNativeByte_BriefAlert:@"登录成功" time:1];
                
                [[NSUserDefaults standardUserDefaults]setObject:@"3" forKey:@"loginingType"];
                
                /**头条登录埋点**/
                NSString * TAppid = [[NSUserDefaults standardUserDefaults]objectForKey:@"toutiaoAPPID"];
                NSString * TAppName = [[NSUserDefaults standardUserDefaults]objectForKey:@"toutiaoAPPNAME"];
                if (TAppid.length !=0 && TAppName.length != 0) {
                    NSLog(@"userID%@",USERID);
                    [[TTInstallIDManager sharedInstance] setCurrentUserUniqueID:USERID];
                    [TTTracker loginEventByMethod:@"mobile" isSuccess:YES];
                }

            }else{
                if(self.autoLoginFailure){
                    self.autoLoginFailure();
                }
                [OrangeMBManager show_CustomNativeByte_BriefAlert:model.message ? model.message : @"获取帐号失败" time:1];
            }
            
        } failedblock:^(NSError *error) {
            if(self.autoLoginFailure){
                self.autoLoginFailure();
            }
            if(error.code == 4){
                [OrangeMBManager show_CustomNativeByte_BriefAlert:@"网络异常" time:1];
            }else{
                [OrangeMBManager show_CustomNativeByte_BriefAlert:@"异常错误" time:1];
            }
        }];
    }
    
 
}



- (IBAction)changeLoginBtnClick:(UIButton *)sender {
    //一旦拿到登录成功的block，则取消切换账号功能
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(loginReuest:) object:self.completionBlock];
    if (self.changeLoginBlock) {
        self.changeLoginBlock(self, sender);
    }
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
}


@end
