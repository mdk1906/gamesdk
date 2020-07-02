//
//  GreenFruitAccountClickSpreadViewBlackCustomControl.m
//  GreenFruitframework
//
//  Created by 张 on 2018/12/10.
//  Copyright © 2018年 Hu. All rights reserved.
//

#import "GreenFruitAccountClickSpreadViewBlackCustomControl.h"
#import "OrangeAPIParams.h"
#import "OrangeMBManager.h"
#import "OrangeInfoArchive.h"
#import "OrangeGreenFruitBundle.h"
#import "GreenFruitRealIdentityCheckViewBlackCustomControl.h"
#import "GreenFruitAlreadyRealNameCheckViewBlackCustomControl.h"
#import "GreenFruitBoundPhoneViewBlackCustomControl.h"
#import "OrangeGreenFruitConfig.h"
#import "GreenFruitModifyBoundPhoneViewBlackCustomControl.h"
#import "GreenFruitSetNewBoundPhoneViewBlackCustomControl.h"
#import "GreenFruitModitynewPasswordViewBlackCustomControl.h"
#import "GreenFruitPrimaryPhoneCodeCheckViewBlackCustomControl.h"
#import "OrangeUIImageView+MHImageWebCache.h"

@interface GreenFruitAccountClickSpreadViewBlackCustomControl ()

@property (nonatomic, strong)GreenFruitRealIdentityCheckViewBlackCustomControl * realNameCheckView;
@property (nonatomic, strong)GreenFruitAlreadyRealNameCheckViewBlackCustomControl * alreadyCheckedView;
@property (nonatomic, strong)GreenFruitBoundPhoneViewBlackCustomControl * boundPhoneView;
@property (nonatomic, strong)GreenFruitModifyBoundPhoneViewBlackCustomControl * modifyBoundPhoneView;
@property (nonatomic, strong)GreenFruitSetNewBoundPhoneViewBlackCustomControl * setNewBoundPhoneView;
@property (nonatomic, strong)GreenFruitModitynewPasswordViewBlackCustomControl * changePasswordView;
@property (nonatomic, strong)GreenFruitPrimaryPhoneCodeCheckViewBlackCustomControl * modifyPhoneCheckCodeView;

@property (nonatomic, retain)NSString * showPhoneStr;
@property (nonatomic, retain)NSString * showPhone;
@end

@implementation GreenFruitAccountClickSpreadViewBlackCustomControl

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    [self configView];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeRotate:) name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
}

-(void)configView{
    self.identifyNameBtn.layer.cornerRadius = 20.0f;
    self.bindingPhoneBtn.layer.cornerRadius = 20.0f;
    self.modifyPsdBtn.layer.cornerRadius = 20.0f;
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];

    NSString * publicPath = User_Defaults_Get(@"publicImgPath");
    UIImage * getImage = [UIImage imageWithContentsOfFile:publicPath];
    self.loginImageView.image = getImage;
    
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

- (void)changeRotate:(NSNotification*)notification{
    
    
    [self changeOrientation];
    
}

- (void)changeOrientation{
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (orientation == UIInterfaceOrientationPortrait
        || orientation == UIInterfaceOrientationPortraitUpsideDown) {
        //竖屏
        [self setWidth:300];
        [self setHeight:330];
        
        self.center = CGPointMake(self.superview.bounds.size.width/2, self.superview.bounds.size.height/2);
        
    } else {
        //横屏
        if(IS_IPHONE){
            [self setWidth:400];
            [self setHeight:320];
            self.center = CGPointMake(self.superview.bounds.size.width/2, self.superview.bounds.size.height/2);
        }else{
            [self setWidth:400];
            [self setHeight:340];
            self.center = CGPointMake(self.superview.bounds.size.width/2, self.superview.bounds.size.height/2);
        }
    }
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


//返回
- (IBAction)returnBackMethod:(id)sender {
    if (self.goBackClickedBlock) {
        self.goBackClickedBlock();
    }
}

//实名认证
- (IBAction)realNameCheckMethod:(id)sender {
    NSLog(@"实名认证");
    //先进行实名认证的判断，如果未实名认证，则跳转实名认证界面，如果认证过，则跳转信息展示界面
    
    NSString * userID = [OrangeInfoArchive getUserId];
    
    [OrangeAPIParams requestCheckIdentifyUserid:userID successblock:^(id response) {
        NSDictionary * infoDic = (NSDictionary *)response;
        NSLog(@"实名验证接口返回的信息:%@",infoDic);
        NSString * status = [NSString stringWithFormat:@"%@",infoDic[@"code"]];
        if ([status isEqualToString:@"200"]) {
            
            [OrangeMBManager show_CustomNativeByte_BriefAlert:@"实名验证过" time:1.0f];
            
            NSDictionary * checkInfo = infoDic[@"content"];
            NSString * nameStr = [NSString stringWithFormat:@"%@",checkInfo[@"realName"]];
            NSString * identityNo = [NSString stringWithFormat:@"%@",checkInfo[@"identityNo"]];
            
            self.alreadyCheckedView = [[[OrangeGreenFruitBundle mainBundle]loadNibNamed:@"GreenFruitAlreadyRealNameCheckViewBlackCustomControl" owner:self options:nil]lastObject];
            self.alreadyCheckedView.realName = nameStr;
            self.alreadyCheckedView.identitysId = identityNo;
            [self pop_CustomNativeByte_SDKView:self.alreadyCheckedView];
            
        }else{

            NSString * message = [NSString stringWithFormat:@"%@",infoDic[@"message"]];
            [OrangeMBManager show_CustomNativeByte_BriefAlert:message time:1.0f];
            
            self.realNameCheckView = [[[OrangeGreenFruitBundle mainBundle]loadNibNamed:@"GreenFruitRealIdentityCheckViewBlackCustomControl" owner:self options:nil]lastObject];
            self.realNameCheckView.JumpviewType = @"accountSecurityView";
            [self pop_CustomNativeByte_SDKView:self.realNameCheckView];
            
        }
        
    } failedblock:^(NSError *error) {
        if(error.code == 4){
            [OrangeMBManager show_CustomNativeByte_BriefAlert:@"网络异常" time:1];
        }else{
            [OrangeMBManager show_CustomNativeByte_BriefAlert:@"异常错误" time:1];
        }
    }];
}

//绑定手机
- (IBAction)bindingPhoneMethod:(id)sender {
    //先进行手机号是否绑定判断，若未绑定手机，则跳转绑定手机号，若绑定过，则跳转修改手机号页面-参考之前版本账号安全页面
    //style 为1时，用userID去查，style为2是，用userName查
    NSString * userName = [OrangeInfoArchive getAccountName];
    //拿账号去判断是否绑定过手机
    [OrangeAPIParams requestCheckPhoneCondition:userName SuccessBlock:^(id response) {
        NSDictionary * infoDic = (NSDictionary *)response;
        NSLog(@"是否绑定手机号返回信息：%@",infoDic);
        
        NSString * status = [NSString stringWithFormat:@"%@",infoDic[@"code"]];
        if ([status isEqualToString:@"200"]) {
            [OrangeMBManager show_CustomNativeByte_BriefAlert:@"已经绑定" time:1.0f];
            NSDictionary * contentDic = infoDic[@"content"];
            self.showPhoneStr = [NSString stringWithFormat:@"%@",contentDic[@"phone"]];
            
            self.modifyBoundPhoneView = [[[OrangeGreenFruitBundle mainBundle]loadNibNamed:@"GreenFruitModifyBoundPhoneViewBlackCustomControl" owner:self options:nil]lastObject];
            self.modifyBoundPhoneView.phoneStr = self.showPhoneStr;
            [self pop_CustomNativeByte_SDKView:self.modifyBoundPhoneView];
            
        }else{
            NSString * message = [NSString stringWithFormat:@"%@",infoDic[@"message"]];
            [OrangeMBManager show_CustomNativeByte_BriefAlert:message time:1.0f];
            
            //前往绑定手机号码界面
            self.boundPhoneView = [[[OrangeGreenFruitBundle mainBundle]loadNibNamed:@"GreenFruitBoundPhoneViewBlackCustomControl" owner:self options:nil]lastObject];
            self.boundPhoneView.jumpViewType = @"AccoutSecurity";
            [self pop_CustomNativeByte_SDKView:self.boundPhoneView];
        }
        
    } failedblock:^(NSError *error) {
        if(error.code == 4){
            [OrangeMBManager show_CustomNativeByte_BriefAlert:@"网络异常" time:1];
        }else{
            [OrangeMBManager show_CustomNativeByte_BriefAlert:@"异常错误" time:1];
        }
    }];
}

//修改密码
- (IBAction)modifyPsdMethod:(id)sender {
    NSLog(@"修改密码");
    //先检查账号下是否绑定手机，绑定再跳转

    NSString * userId = [OrangeInfoArchive getUserId];
    [OrangeAPIParams requestCenterCheckPhoneCondition:userId SuccessBlock:^(id response) {
        NSDictionary * infoDic = (NSDictionary *)response;
        NSLog(@"修改密码前检查是否有手机的接口:%@",infoDic);
        NSString * status = [NSString stringWithFormat:@"%@",infoDic[@"code"]];
        if ([status isEqualToString:@"200"]) {
            
            NSDictionary * contentDic = infoDic[@"content"];
            self.showPhone = [NSString stringWithFormat:@"%@",contentDic[@"phone"]];
            self.changePasswordView = [[[OrangeGreenFruitBundle mainBundle]loadNibNamed:@"GreenFruitModitynewPasswordViewBlackCustomControl" owner:self options:nil]lastObject];
            self.changePasswordView.phoneNum = self.showPhone;
            [self pop_CustomNativeByte_SDKView:self.changePasswordView];
            
        }else{
            
            NSString * message = [NSString stringWithFormat:@"%@",infoDic[@"message"]];
            [OrangeMBManager show_CustomNativeByte_BriefAlert:message time:1.0f];
            
        }
        
    } failedblock:^(NSError *error) {
        if(error.code == 4){
            [OrangeMBManager show_CustomNativeByte_BriefAlert:@"网络异常" time:1];
        }else{
            [OrangeMBManager show_CustomNativeByte_BriefAlert:@"异常错误" time:1];
        }
    }];
    
}

#pragma mark --- SDK页面跳转封装方法
- (void)handleCustom_CustomNativeByte_ActionEnvent:(OrangeZJAnimationPopView *)popView customerView:(UIView*)customerView{
    
    if ([customerView isKindOfClass:[GreenFruitRealIdentityCheckViewBlackCustomControl class]]) {//实名验证
        GreenFruitRealIdentityCheckViewBlackCustomControl * realNameCheckName = (GreenFruitRealIdentityCheckViewBlackCustomControl *)customerView;
        realNameCheckName.closeViewBlock = ^{
            [popView dismiss];
            if (self.dismissPopViewBlock) {
                self.dismissPopViewBlock();
            }
        };
        realNameCheckName.gobackClickBlock = ^{
            [popView dismiss];
        };
        realNameCheckName.accountSecuretyCloseBlcok = ^{
            [popView dismiss];
            if (self.dismissPopViewBlock) {
                self.dismissPopViewBlock();
            }
        };
    }
    else if ([customerView isKindOfClass:[GreenFruitAlreadyRealNameCheckViewBlackCustomControl class]]){//已实名验证页面
        GreenFruitAlreadyRealNameCheckViewBlackCustomControl * alreadyCheckView = (GreenFruitAlreadyRealNameCheckViewBlackCustomControl *)customerView;
        alreadyCheckView.goBackClickedBlock = ^{
            [popView dismiss];
        };
    }
    else if ([customerView isKindOfClass:[GreenFruitBoundPhoneViewBlackCustomControl class]]){//绑定手机
        GreenFruitBoundPhoneViewBlackCustomControl * boundPhoneView = (GreenFruitBoundPhoneViewBlackCustomControl *)customerView;
        boundPhoneView.accountSecureDismissBlock = ^{
            [popView dismiss];
            if (self.dismissPopViewBlock) {
                self.dismissPopViewBlock();
            }
        };
        boundPhoneView.AccountViewGobackBlock = ^{
            [popView dismiss];
        };
        boundPhoneView.closeViewBlock = ^{
            [popView dismiss];
            if (self.dismissPopViewBlock) {
                self.dismissPopViewBlock();
            }
        };
    }

    else if ([customerView isKindOfClass:[GreenFruitModifyBoundPhoneViewBlackCustomControl class]]){//修改绑定手机号
        GreenFruitModifyBoundPhoneViewBlackCustomControl * modifyBoundView = (GreenFruitModifyBoundPhoneViewBlackCustomControl *)customerView;
        modifyBoundView.closeViewBlock = ^{
            [popView dismiss];
            if (self.dismissPopViewBlock) {
                self.dismissPopViewBlock();
            }
        };
        modifyBoundView.gobackClickBlock = ^{
            [popView dismiss];
        };
        modifyBoundView.modifyPhoneBlock = ^{
            self.modifyPhoneCheckCodeView = [[[OrangeGreenFruitBundle mainBundle]loadNibNamed:@"GreenFruitPrimaryPhoneCodeCheckViewBlackCustomControl" owner:self options:nil]lastObject];
            NSString * accountStr = [OrangeInfoArchive getAccountName];
            self.modifyPhoneCheckCodeView.phone = accountStr;
            self.modifyPhoneCheckCodeView.showPhoneStr = self.showPhoneStr;
            [self pop_CustomNativeByte_SDKView:self.modifyPhoneCheckCodeView popView:popView];
        };
    }else if ([customerView isKindOfClass:[GreenFruitPrimaryPhoneCodeCheckViewBlackCustomControl class]]){//短信验证
        GreenFruitPrimaryPhoneCodeCheckViewBlackCustomControl * primaryphoneCheckCodeView = (GreenFruitPrimaryPhoneCodeCheckViewBlackCustomControl *)customerView;
       
        primaryphoneCheckCodeView.PhoneCheckBlock = ^{
            self.setNewBoundPhoneView = [[[OrangeGreenFruitBundle mainBundle]loadNibNamed:@"GreenFruitSetNewBoundPhoneViewBlackCustomControl" owner:self options:nil]lastObject];
            [self pop_CustomNativeByte_SDKView:self.setNewBoundPhoneView popView:popView];
        };
        primaryphoneCheckCodeView.phoneGobackBlock = ^{
            [self pop_CustomNativeByte_SDKView:self.modifyBoundPhoneView popView:popView];
        };
        primaryphoneCheckCodeView.phoneCloseviewBlock = ^{
            [popView dismiss];
            if (self.dismissPopViewBlock) {
                self.dismissPopViewBlock();
            }
        };
     
    }
    else if ([customerView isKindOfClass:[GreenFruitSetNewBoundPhoneViewBlackCustomControl class]]){//设置新的绑定手机
        GreenFruitSetNewBoundPhoneViewBlackCustomControl * setNewPhoneView = (GreenFruitSetNewBoundPhoneViewBlackCustomControl *)customerView;
        setNewPhoneView.goBackClickBlock = ^{
          
            [self pop_CustomNativeByte_SDKView:self.modifyPhoneCheckCodeView popView:popView];
        };
        setNewPhoneView.closeviewBlock = ^{
            [popView dismiss];
            if (self.dismissPopViewBlock) {
                self.dismissPopViewBlock();
            }
        };
        setNewPhoneView.modifyNewPhoneBlock = ^{
            [popView dismiss];
            if (self.dismissPopViewBlock) {
                self.dismissPopViewBlock();
            }
        };

    }
    else if ([customerView isKindOfClass:[GreenFruitModitynewPasswordViewBlackCustomControl class]]){//修改新密码
        GreenFruitModitynewPasswordViewBlackCustomControl * modifyPasView = (GreenFruitModitynewPasswordViewBlackCustomControl *)customerView;
        modifyPasView.goBackClickBlock = ^{
            [popView dismiss];
        };
        modifyPasView.closeviewBlock = ^{
            [popView dismiss];
            if (self.dismissPopViewBlock) {
                self.dismissPopViewBlock();
            }
        };
        modifyPasView.modifySuccessBlock = ^{
            [popView dismiss];
            if (self.dismissPopViewBlock) {
                self.dismissPopViewBlock();
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
-(void)pop_CustomNativeByte_SDKView:(UIView*)view popView:(OrangeZJAnimationPopView*)backPopView{
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
