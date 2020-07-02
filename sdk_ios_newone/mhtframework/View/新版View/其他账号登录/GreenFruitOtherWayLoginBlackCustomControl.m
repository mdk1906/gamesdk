//
//  GreenFruitOtherWayLoginBlackCustomControl.m
//  GreenFruitframework
//
//  Created by 张 on 2018/11/29.
//  Copyright © 2018年 Hu. All rights reserved.
//

#import "GreenFruitOtherWayLoginBlackCustomControl.h"
#import "GreenFruitOtherWayLoginBlackCustomControl.h"
#import "GreenFruitTouristUserLoginViewBlackCustomControl.h"
#import "OrangeGreenFruitBundle.h"
#import "GreenFruitSystemAccountLoginBlackCustomControl.h"
#import "GreenFruitFastFeelViewBlackCustomControl.h"
//就在此页面集中做跳转处理
#import "GreenFruitBoundPhoneViewBlackCustomControl.h"
#import "GreenFruitPhoneLoginGetCodeViewBlackCustomControl.h"
#import "GreenFruitFindPasswordViewBlackCustomControl.h"
#import "GreenFruitRegistionViewBlackCustomControl.h"
#import "GreenFruitRealIdentityCheckViewBlackCustomControl.h"
#import "GreenFruitConfirmCodeInputViewBlackCustomControl.h"
#import "GreenFruitSetPasswordViewBlackCustomControl.h"
#import "GreenFruitConnectionWithServiceViewBlackCustomControl.h"
#import "GreenFruitFloatSpreadViewBlackCustomControl.h"
#import "OrangeGreenFruitConfig.h"
#import "OrangeUIImageView+MHImageWebCache.h"

@interface GreenFruitOtherWayLoginBlackCustomControl()

@property (nonatomic,retain)GreenFruitOtherWayLoginBlackCustomControl * otherwayLoginView;
@property (nonatomic,retain)GreenFruitTouristUserLoginViewBlackCustomControl * touristLoginView;
@property (nonatomic,retain)GreenFruitSystemAccountLoginBlackCustomControl * systemLoginView;
@property (nonatomic,retain)GreenFruitFastFeelViewBlackCustomControl * fastFeelView;
@property (nonatomic,retain)GreenFruitBoundPhoneViewBlackCustomControl * boundPhoneView;
@property (nonatomic,retain)GreenFruitPhoneLoginGetCodeViewBlackCustomControl * getPhoneCodeView;
@property (nonatomic,retain)GreenFruitFindPasswordViewBlackCustomControl * findPasswordView;
@property (nonatomic,retain)GreenFruitRegistionViewBlackCustomControl * registionView;
@property (nonatomic,retain)GreenFruitRealIdentityCheckViewBlackCustomControl * realIdentityView;
@property (nonatomic,retain)GreenFruitConfirmCodeInputViewBlackCustomControl * ConfirCodeView;
@property (nonatomic,retain)GreenFruitSetPasswordViewBlackCustomControl * setPasswordView;
@property (nonatomic,retain)GreenFruitConnectionWithServiceViewBlackCustomControl * connectionView;
@property (nonatomic,retain)GreenFruitFloatSpreadViewBlackCustomControl * fisrtLoginView;
@end

@implementation GreenFruitOtherWayLoginBlackCustomControl

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    [self configView];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeRotate:) name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
}

-(void)configView{
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];

    NSString * publicPath = User_Defaults_Get(@"publicImgPath");
    UIImage * getImage = [UIImage imageWithContentsOfFile:publicPath];
    self.logoImageView.image = getImage;
    
    NSString * logoPath = User_Defaults_Get(@"logoImgPath");
    UIImage * logoImage = [UIImage imageWithContentsOfFile:logoPath];
    [self.systemLoginBtn setImage:logoImage forState:UIControlStateNormal];
    self.systemLoginBtn.highlighted = NO;
    
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (orientation == UIInterfaceOrientationPortrait
        || orientation == UIInterfaceOrientationPortraitUpsideDown){
        [self setWidth:300];
        [self setHeight:330];
//        [self verticalUI];
        self.center = CGPointMake(self.superview.bounds.size.width/2, self.superview.bounds.size.height/2);
    }
    else{
        if(IS_IPHONE){
            //    [self horizontalUI];
            [self setWidth:400];
            [self setHeight:320];
            self.center = CGPointMake(self.superview.bounds.size.width/2, self.superview.bounds.size.height/2);
        }else{
            //     [self verticalUI];
            [self setWidth:400];
            [self setHeight:340];
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
//        [self verticalUI];
        [self setWidth:300];
        [self setHeight:330];
        
        self.center = CGPointMake(self.superview.bounds.size.width/2, self.superview.bounds.size.height/2);
        
        NSLog(@"竖屏了");
        
    } else {
        
        NSLog(@"横屏了");
        
        //横屏
        if(IS_IPHONE){
//            [self horizontalUI];
            [self setWidth:400];
            [self setHeight:320];
            self.center = CGPointMake(self.superview.bounds.size.width/2, self.superview.bounds.size.height/2);
        }else{
//            [self verticalUI];
            [self setWidth:400];
            [self setHeight:340];
            self.center = CGPointMake(self.superview.bounds.size.width/2, self.superview.bounds.size.height/2);
        }
    }
}

-(void)verticalUI{
    self.fastFellBtn.frame = CGRectMake(35, 159, 60, 60);
    self.fasrFeelLabel.frame = CGRectMake(35, 227, 60, 15);
    self.systemLoginBtn.frame = CGRectMake(205, 159, 60, 60);
    self.systemLoginLabel.frame = CGRectMake(204, 227, 62, 15);
    
}

-(void)horizontalUI{
    
    self.fastFellBtn.frame = CGRectMake(20, 159, 60, 60);
    self.fasrFeelLabel.frame = CGRectMake(20, 227, 60, 15);
    self.systemLoginBtn.frame = CGRectMake(self.bounds.size.width-82, 159, 60, 60);
    self.systemLoginLabel.frame = CGRectMake(self.bounds.size.width-82, 227, 62, 15);
}

- (void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}


- (IBAction)returnBackMethod:(id)sender {
   
    if (self.goBackClickedBlock) {
        self.goBackClickedBlock();
    }
}

- (IBAction)fastLoginMethod:(UIButton *)sender {
   
    self.fastFeelView = [[[OrangeGreenFruitBundle mainBundle]loadNibNamed:@"GreenFruitFastFeelViewBlackCustomControl" owner:self options:nil] lastObject];
    [self.fastFeelView getAccountInfo];
    self.fastFeelView.completionBlock = self.completionBlock;
    [self pop_CustomNativeByte_SDKView:self.fastFeelView];
    
}

- (IBAction)phoneLoginMethod:(id)sender {
    self.touristLoginView = [[[OrangeGreenFruitBundle mainBundle]loadNibNamed:@"GreenFruitTouristUserLoginViewBlackCustomControl" owner:self options:nil] lastObject];
    [self pop_CustomNativeByte_SDKView:self.touristLoginView];
}

- (IBAction)systemLoginMethod:(id)sender {
    
    self.systemLoginView = [[[OrangeGreenFruitBundle mainBundle]loadNibNamed:@"GreenFruitSystemAccountLoginBlackCustomControl" owner:self options:nil] lastObject];
    self.systemLoginView.completionBlock = self.completionBlock;
    [self pop_CustomNativeByte_SDKView:self.systemLoginView];
    
}


#pragma mark --- SDK页面跳转封装方法
- (void)handleCustom_CustomNativeByte_ActionEnvent:(OrangeZJAnimationPopView *)popView customerView:(UIView*)customerView{

    if([customerView isKindOfClass:[GreenFruitTouristUserLoginViewBlackCustomControl class]]){//手机号登录页面
        GreenFruitTouristUserLoginViewBlackCustomControl *phoneLoginView = (GreenFruitTouristUserLoginViewBlackCustomControl *)customerView;
        phoneLoginView.goBackClickedBlock = ^{
            [popView dismiss];
        };
        phoneLoginView.closeCurrentViewBlock = ^{
            [popView dismiss];
            if (self.goBackClickedBlock) {
                self.goBackClickedBlock();
            }
        };
        phoneLoginView.nextStepBlock = ^(GreenFruitTouristUserLoginViewBlackCustomControl *signView, NSString *phoneNumber) {
            self.getPhoneCodeView = [[[OrangeGreenFruitBundle mainBundle]loadNibNamed:@"GreenFruitPhoneLoginGetCodeViewBlackCustomControl" owner:self options:nil] lastObject];
            self.getPhoneCodeView.phone = phoneNumber;
            self.getPhoneCodeView.completionBlock = self.completionBlock;
            [self pop_CustomNativeByte_SDKView:self.getPhoneCodeView popView:popView];
        };
    }
    else if ([customerView isKindOfClass:[GreenFruitSystemAccountLoginBlackCustomControl class]]){//系统账号登录页面
        GreenFruitSystemAccountLoginBlackCustomControl * systemLoginView = (GreenFruitSystemAccountLoginBlackCustomControl *)customerView;
        systemLoginView.goBackClickedBlock = ^{
            [popView dismiss];
        };
        systemLoginView.secondGobackClickedBlock = ^{
            [self pop_CustomNativeByte_SDKView:self.setPasswordView popView:popView];
        };
        systemLoginView.closeViewBlock = ^{
            [popView dismiss];
            if (self.goBackClickedBlock) {
                self.goBackClickedBlock();
            }
        };
        systemLoginView.forgetPasswordBlock = ^(GreenFruitSystemAccountLoginBlackCustomControl *signView) {
            self.findPasswordView = [[[OrangeGreenFruitBundle mainBundle]loadNibNamed:@"GreenFruitFindPasswordViewBlackCustomControl" owner:self options:nil]lastObject];
            [self pop_CustomNativeByte_SDKView:self.findPasswordView popView:popView];
        };
        systemLoginView.regisAccountBlock = ^(GreenFruitSystemAccountLoginBlackCustomControl *signView) {
          
            self.registionView = [[[OrangeGreenFruitBundle mainBundle]loadNibNamed:@"GreenFruitRegistionViewBlackCustomControl" owner:self options:nil] lastObject];
            self.registionView.completionBlock = self.completionBlock;//声明回调
            [self pop_CustomNativeByte_SDKView:self.registionView popView:popView];
        };
       
        systemLoginView.loginSuccessBlock = ^(GreenFruit_CustomNativeByte_SDKLoginCompletionBlock completionBlock) {
            self.completionBlock = completionBlock;
            [popView dismiss];
            if (self.goBackClickedBlock) {
                self.goBackClickedBlock();
            }
        };
        
    }
    else if ([customerView isKindOfClass:[GreenFruitFastFeelViewBlackCustomControl class]]){//快速注册
        GreenFruitFastFeelViewBlackCustomControl * fastfeelView = (GreenFruitFastFeelViewBlackCustomControl *)customerView;
//        fastfeelView.completionBlock = self.completionBlock;
        fastfeelView.goBackClickedBlock = ^{
            [popView dismiss];
        };
        fastfeelView.returnTheCompletionBlock = ^(GreenFruit_CustomNativeByte_SDKLoginCompletionBlock completionBlock) {
            self.completionBlock = completionBlock;

            //直接从快速注册页面退出
            [popView dismiss];
            if (self.goBackClickedBlock) {
                self.goBackClickedBlock();
            }
        };
        
        fastfeelView.JumptoBoundPhoneBlock = ^(GreenFruitFastFeelViewBlackCustomControl *signView, NSMutableDictionary *dic, OrangeRespondModel *model, GreenFruit_CustomNativeByte_SDKUser *user, NSString *componentType) {
            self.boundPhoneView = [[[OrangeGreenFruitBundle mainBundle]loadNibNamed:@"GreenFruitBoundPhoneViewBlackCustomControl" owner:self options:nil]lastObject];
            self.boundPhoneView.loginDics = dic;
            self.boundPhoneView.userInfo = user;
            self.boundPhoneView.infoModel = model;
            self.boundPhoneView.jumpViewType = @"fastfeel";
            self.boundPhoneView.componentType = componentType;
            [self pop_CustomNativeByte_SDKView:self.boundPhoneView popView:popView];
        };
    }
    else if ([customerView isKindOfClass:[GreenFruitBoundPhoneViewBlackCustomControl class]]){//绑定手机
        GreenFruitBoundPhoneViewBlackCustomControl * boundPhoneView = (GreenFruitBoundPhoneViewBlackCustomControl *)customerView;
        boundPhoneView.goBackClickBlock = ^{
            [self pop_CustomNativeByte_SDKView:self.fastFeelView popView:popView];
        };
        boundPhoneView.closeViewBlock = ^{
            [popView dismiss];
            if (self.goBackClickedBlock) {
                self.goBackClickedBlock();
            }
        };
        boundPhoneView.boundSuccessBlock = ^{
            [popView dismiss];
            if (self.goBackClickedBlock) {
                self.goBackClickedBlock();
            }
        };
        boundPhoneView.jumpToIdentifyCheckViewBlock = ^{
            self.realIdentityView = [[[OrangeGreenFruitBundle mainBundle]loadNibNamed:@"GreenFruitRealIdentityCheckViewBlackCustomControl" owner:self options:nil]lastObject];
            [self pop_CustomNativeByte_SDKView:self.realIdentityView popView:popView];
            
        };
    }
    else if ([customerView isKindOfClass:[GreenFruitPhoneLoginGetCodeViewBlackCustomControl class]]){//获取验证码页面
        GreenFruitPhoneLoginGetCodeViewBlackCustomControl * phoneGetCodeView = (GreenFruitPhoneLoginGetCodeViewBlackCustomControl *)customerView;
        phoneGetCodeView.goBackClickedBlock = ^{
            [self goBackSDKView:self.touristLoginView popView:popView];
        };
        phoneGetCodeView.closeViewBlock = ^{
            [popView dismiss];
            if (self.goBackClickedBlock) {
                self.goBackClickedBlock();
            }
        };
        phoneGetCodeView.skipViewBlock = ^{
            [popView dismiss];
            if (self.goBackClickedBlock) {
                self.goBackClickedBlock();
            }
        };
        phoneGetCodeView.successCheckCodeBlock = ^(GreenFruit_CustomNativeByte_SDKLoginCompletionBlock completionBlock) {
            self.completionBlock = completionBlock;
            [popView dismiss];
            if (self.goBackClickedBlock) {
                self.goBackClickedBlock();
            }
        };
        phoneGetCodeView.realIdentifyCheckBlock = ^{
          //跳转实名验证
            self.realIdentityView = [[[OrangeGreenFruitBundle mainBundle]loadNibNamed:@"GreenFruitRealIdentityCheckViewBlackCustomControl" owner:self options:nil]lastObject];
            [self pop_CustomNativeByte_SDKView:self.realIdentityView popView:popView];
        };
        phoneGetCodeView.boundPhoneBlock = ^{
          //跳转绑定手机
            self.boundPhoneView = [[[OrangeGreenFruitBundle mainBundle]loadNibNamed:@"GreenFruitBoundPhoneViewBlackCustomControl" owner:self options:nil]lastObject];
            [self pop_CustomNativeByte_SDKView:self.boundPhoneView popView:popView];
        };
        
    }
    else if ([customerView isKindOfClass:[GreenFruitFindPasswordViewBlackCustomControl class]]){//找回密码页面
        GreenFruitFindPasswordViewBlackCustomControl * findPasswordView = (GreenFruitFindPasswordViewBlackCustomControl *)customerView;
        findPasswordView.goBackBlock = ^{
//            [popView dismiss];
            [self pop_CustomNativeByte_SDKView:self.systemLoginView popView:popView];
        };
        findPasswordView.closeViewBlock = ^{
            [popView dismiss];
            if (self.goBackClickedBlock) {
                self.goBackClickedBlock();
            }
        };
        findPasswordView.checkSuccessBlock = ^(NSString *showPhoneStr, NSString *phone) {
            self.ConfirCodeView = [[[OrangeGreenFruitBundle mainBundle]loadNibNamed:@"GreenFruitConfirmCodeInputViewBlackCustomControl" owner:self options:nil]lastObject];
            self.ConfirCodeView.phone = phone;//这里传的值为手机号或者账号
            self.ConfirCodeView.showPhoneStr = showPhoneStr;//展示的手机号
            [self pop_CustomNativeByte_SDKView:self.ConfirCodeView popView:popView];
        };
        findPasswordView.goToQQServiceBlock = ^(NSString *phone, NSDictionary *dic) {
            self.connectionView = [[[OrangeGreenFruitBundle mainBundle]loadNibNamed:@"GreenFruitConnectionWithServiceViewBlackCustomControl" owner:self options:nil] lastObject];
            self.connectionView.userName = phone;
            self.connectionView.serverceDic = dic;
            [self pop_CustomNativeByte_SDKView:self.connectionView popView:popView];
        };
    }
    else if ([customerView isKindOfClass:[GreenFruitRegistionViewBlackCustomControl class]]){//注册账号页面
        GreenFruitRegistionViewBlackCustomControl * registAccountView = (GreenFruitRegistionViewBlackCustomControl *)customerView;
        registAccountView.goBackClickedBlock = ^{
        
            [self pop_CustomNativeByte_SDKView:self.systemLoginView popView:popView];
        };
        
        registAccountView.closeViewBlock = ^{
            [popView dismiss];
            if (self.goBackClickedBlock) {
                self.goBackClickedBlock();
            }
        };
        
        registAccountView.registSuccessBlock = ^(GreenFruitRegistionViewBlackCustomControl *registionView, GreenFruit_CustomNativeByte_SDKLoginCompletionBlock completionBlock, NSString *component) {
            self.completionBlock = completionBlock;
            [popView dismiss];
            if (self.goBackClickedBlock) {
                self.goBackClickedBlock();
            }
            if ([component isEqualToString:@"identity"]) {//跳转实名认证
                self.realIdentityView = [[[OrangeGreenFruitBundle mainBundle]loadNibNamed:@"GreenFruitRealIdentityCheckViewBlackCustomControl" owner:self options:nil] lastObject];
                [self pop_CustomNativeByte_SDKView:self.realIdentityView popView:popView];
            }
            else if ([component isEqualToString:@"phone"]){//跳转绑定手机
                NSLog(@"绑定手机");
            }
            else if ([component isEqualToString:@"skip"]){
                NSLog(@"跳过");
            }
            else{
                NSLog(@"执行其他操作");
            }
        };
        
    }else if ([customerView isKindOfClass:[GreenFruitRealIdentityCheckViewBlackCustomControl class]]){//实名认证
        GreenFruitRealIdentityCheckViewBlackCustomControl * realIdentityCheckView = (GreenFruitRealIdentityCheckViewBlackCustomControl *)customerView;
        realIdentityCheckView.gobackClickBlock = ^{
//            [popView dismiss];
            [self pop_CustomNativeByte_SDKView:self.registionView popView:popView];
        };
        realIdentityCheckView.closeViewBlock = ^{
            [popView dismiss];
            if (self.goBackClickedBlock) {
                self.goBackClickedBlock();
            }
        };
        realIdentityCheckView.checkSuccessBlock = ^{
            [popView dismiss];
            if (self.goBackClickedBlock) {
                self.goBackClickedBlock();
            }
        };
        realIdentityCheckView.changeAccountBlock = ^{
            [popView dismiss];
        };
        
    }else if ([customerView isKindOfClass:[GreenFruitConfirmCodeInputViewBlackCustomControl class]]){//输入验证码
        GreenFruitConfirmCodeInputViewBlackCustomControl * confirmCodeView = (GreenFruitConfirmCodeInputViewBlackCustomControl *)customerView;
        confirmCodeView.goBackClickedBlock = ^{
            [popView dismiss];
        };
        confirmCodeView.closeViewBlock = ^{
            [popView dismiss];
            if (self.goBackClickedBlock) {
                self.goBackClickedBlock();
            }
        };
        confirmCodeView.checkSuccessBlock = ^(NSString *phone) {
            self.setPasswordView = [[[OrangeGreenFruitBundle mainBundle]loadNibNamed:@"GreenFruitSetPasswordViewBlackCustomControl" owner:self options:nil]lastObject];
            self.setPasswordView.phoneNumber = phone;
            [self pop_CustomNativeByte_SDKView:self.setPasswordView popView:popView];
        };
    }else if ([customerView isKindOfClass:[GreenFruitSetPasswordViewBlackCustomControl class]]){//设置密码
        GreenFruitSetPasswordViewBlackCustomControl * setPasswordView = (GreenFruitSetPasswordViewBlackCustomControl *)customerView;
        
        setPasswordView.goBackClickedBlock = ^{
            [self pop_CustomNativeByte_SDKView:self.ConfirCodeView popView:popView];
        };
        setPasswordView.closeViewBlock = ^{
            [popView dismiss];
            if (self.goBackClickedBlock) {
                self.goBackClickedBlock();
            }
        };
        //修改密码成功后，跳回账号密码登录界面
        setPasswordView.modifySuccessBlock = ^(NSString *account, NSString *password) {
            self.systemLoginView = [[[OrangeGreenFruitBundle mainBundle]loadNibNamed:@"GreenFruitSystemAccountLoginBlackCustomControl" owner:self options:nil]lastObject];
            self.systemLoginView.jumpViewType = @"setPasswordView";
            self.systemLoginView.accountStr = account;
            self.systemLoginView.passwordStr = password;
            self.systemLoginView.completionBlock = self.completionBlock;
            [self pop_CustomNativeByte_SDKView:self.systemLoginView popView:popView];
        };
        
    }else if ([customerView isKindOfClass:[GreenFruitConnectionWithServiceViewBlackCustomControl class]]){//客服页面
        GreenFruitConnectionWithServiceViewBlackCustomControl * serviceView = (GreenFruitConnectionWithServiceViewBlackCustomControl *)customerView;
        serviceView.goBackClickedBlock = ^{
            [self pop_CustomNativeByte_SDKView:self.findPasswordView popView:popView];
        };
        serviceView.closeViewBlock = ^{
            [popView dismiss];
            if (self.goBackClickedBlock) {
                self.goBackClickedBlock();
            }
        };
    }
}

- (void)pop_CustomNativeByte_SDKView:(UIView*)view{
    if(self.popView.isPop){
        [self.popView dismiss];
    }
    self.popView = [[OrangeZJAnimationPopView alloc] initWith_CustomNativeByte_CustomView:view popStyle:ZJAnimationPopStyleNO dismissStyle:ZJAnimationDismissStyleNO];
    self.popView.popBGAlpha = 0;
    self.popView.isObserver_CustomNativeByte_OrientationChange = YES;
    [self handleCustom_CustomNativeByte_ActionEnvent:self.popView customerView:view];
    [self.popView pop];
    
}

- (void)pop_CustomNativeByte_SDKView:(UIView*)view popView:(OrangeZJAnimationPopView*)backPopView{
    [backPopView dismiss];
    OrangeZJAnimationPopView *popView = [[OrangeZJAnimationPopView alloc] initWith_CustomNativeByte_CustomView:view popStyle:ZJAnimationPopStyleNO dismissStyle:ZJAnimationDismissStyleNO];
    popView.popBGAlpha = 0;
    popView.isObserver_CustomNativeByte_OrientationChange = YES;
    [self handleCustom_CustomNativeByte_ActionEnvent:popView customerView:view];
    [popView pop];
    NSLog(@"进入下一页");
    
}

- (void)goBackSDKView:(UIView*)view popView:(OrangeZJAnimationPopView*)backPopView{
    [backPopView dismiss];
    OrangeZJAnimationPopView *popView = [[OrangeZJAnimationPopView alloc] initWith_CustomNativeByte_CustomView:view popStyle:ZJAnimationPopStyleNO dismissStyle:ZJAnimationDismissStyleNO];
    popView.popBGAlpha = 0;
    popView.isObserver_CustomNativeByte_OrientationChange = YES;
    [self handleCustom_CustomNativeByte_ActionEnvent:popView customerView:view];
    [popView pop];
    NSLog(@"返回上一页   是否返回");
}


- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
}



@end
