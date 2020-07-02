//
//  GreenFruitRegistionViewBlackCustomControl.m
//  GreenFruitframework
//
//  Created by 张 on 2018/11/30.
//  Copyright © 2018年 Hu. All rights reserved.
//

#import "GreenFruitRegistionViewBlackCustomControl.h"
#import "OrangeGreenFruitBundle.h"
#import "OrangeAPIParams.h"
#import "OrangeMBManager.h"
#import "GreenFruitRealIdentityCheckViewBlackCustomControl.h"
#import "GreenFruitUserProtochlViewBlackCustomControl.h"
#import "OrangeRespondModel.h"
#import "OrangeYYModel.h"
#import "OrangeInfoArchive.h"
#import "OrangeGreenFruitConfig.h"
#import "OrangeUIImageView+MHImageWebCache.h"

//今日头条
#import <TTTracker/TTTracker.h>
#import <TTTracker/TTTracker+Game.h>
#import <TTTracker/TTInstallIDManager.h>

@interface GreenFruitRegistionViewBlackCustomControl()<UITextFieldDelegate>

@property (nonatomic,retain)NSString * accountString;
@property (nonatomic,retain)NSString * passwordString;
@property (nonatomic,strong)GreenFruitRealIdentityCheckViewBlackCustomControl * realIdentityView;
@property (nonatomic,strong)GreenFruitUserProtochlViewBlackCustomControl * userProtocolView;
@property (nonatomic,retain)NSString * textfieldName;
@end

@implementation GreenFruitRegistionViewBlackCustomControl

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    [self configView];

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeRotate:) name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
    //注册观察键盘的变化
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
}

-(void)configView{
    self.registionBtn.layer.cornerRadius = 20.0f;
    self.setAccountTextfield.delegate = self;
    self.setAccountTextfield.tag = 100;
    self.setPasswordTextfield.delegate = self;
    self.setPasswordTextfield.tag = 200;
    self.setPasswordTextfield.secureTextEntry = YES;
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    self.textfieldName = @"1";
    
    NSString * publicPath = User_Defaults_Get(@"publicImgPath");
    UIImage * getImage = [UIImage imageWithContentsOfFile:publicPath];
    self.logoImageView.image = getImage;
    
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (orientation == UIInterfaceOrientationPortrait
        || orientation == UIInterfaceOrientationPortraitUpsideDown){
        [self setWidth:300];
        [self setHeight:330];
        self.center = CGPointMake(self.superview.bounds.size.width/2, self.superview.bounds.size.height/2);
    }
    else{
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

#pragma mark -- 适配横屏竖屏
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
        [self verticalUI];
        
    } else {
        //横屏
        if(IS_IPHONE){
            [self setWidth:400];
            [self setHeight:320];
            self.center = CGPointMake(self.superview.bounds.size.width/2, self.superview.bounds.size.height/2);
            [self horizontalUI];
            
        }else{
            [self setWidth:400];
            [self setHeight:340];
            
            self.center = CGPointMake(self.superview.bounds.size.width/2, self.superview.bounds.size.height/2);
            [self horizontalUI];
            
        }
    }
}

-(void)verticalUI{
    
}

-(void)horizontalUI{
    
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

#pragma mark -- 键盘弹出，视图动态上移
//键盘回收
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    for(UIView *view in self.subviews)
    {
        [view resignFirstResponder];
    }
}

//移动UIView
-(void)keyboardWillShow:(NSNotification *)note
{
    
    //获取键盘高度，在不同设备上，以及中英文下是不同的
    CGFloat kbHeight = [[note.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    
    //计算出键盘顶端到inputTextView panel底端的距离(加上自定义的缓冲距离INTERVAL_KEYBOARD)
    CGFloat offset;
    if ([self.textfieldName isEqualToString:@"1"]) {
        offset = (self.setAccountTextfield.frame.origin.y+self.setAccountTextfield.frame.size.height+20) - (kScreenHeight - kbHeight);
    }
    else if ([self.textfieldName isEqualToString:@"2"]){
        offset = (self.setPasswordTextfield.frame.origin.y+self.setPasswordTextfield.frame.size.height+20) - (kScreenHeight - kbHeight);
    }
    else{
        offset = (self.setAccountTextfield.frame.origin.y+self.setAccountTextfield.frame.size.height+20) - (kScreenHeight - kbHeight);
        
    }
    // 取得键盘的动画时间，这样可以在视图上移的时候更连贯
    double duration = [[note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    //将视图上移计算好的偏移
    if(offset > 0) {
        [UIView animateWithDuration:duration animations:^{
            self.frame = CGRectMake(self.frame.origin.x, -offset, self.frame.size.width, self.frame.size.height);
        }];
    }
    
}

-(void)keyboardWillHide:(NSNotification *)note
{
    
    // 键盘动画时间
    double duration = [[note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    //视图下沉恢复原状
    [UIView animateWithDuration:duration animations:^{
        self.center = CGPointMake(kScreenWidth/2, kScreenHeight/2);
    }];
    
}

#pragma mark ---- 键盘代理

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if (textField == self.setAccountTextfield) {
        self.textfieldName = @"1";
    }else if (textField == self.setPasswordTextfield){
        self.textfieldName = @"2";
    }else{
        
    }
}

#pragma mark --  UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    NSInteger tag = textField.tag;
    switch (tag) {
        case 100:
        {
            self.accountString = [NSString stringWithFormat:@"%@",textField.text];
        }
            break;
        case 200:
        {
            self.passwordString = [NSString stringWithFormat:@"%@",textField.text];
        }
            break;
        default:
            break;
    }
}

//返回
- (IBAction)returnMethod:(id)sender {
    if (self.goBackClickedBlock) {
        self.goBackClickedBlock();
    }
}

- (IBAction)selectBtnMethod:(UIButton*)sender {
    if (sender.selected == NO) {
        NSString * imaPath = [[OrangeGreenFruitBundle mainBundle]pathForResource:@"Orange椭圆_2" ofType:@"png" inDirectory:nil forLocalization:nil];
        [sender setBackgroundImage:[UIImage imageWithData:[NSData dataWithContentsOfFile:imaPath]] forState:UIControlStateNormal];
        sender.selected = YES;
    }
    else{
        NSString * imaPath = [[OrangeGreenFruitBundle mainBundle]pathForResource:@"Orange已勾选_2" ofType:@"png" inDirectory:nil forLocalization:nil];
        [sender setBackgroundImage:[UIImage imageWithData:[NSData dataWithContentsOfFile:imaPath]] forState:UIControlStateNormal];
        sender.selected = NO;
    }
}

//关闭页面
- (IBAction)returnBackMethod:(id)sender {
    
    if (self.closeViewBlock) {
        self.closeViewBlock();
    }
}

//注册按钮
- (IBAction)registionMethod:(id)sender {
    [self endEditing:YES];

    if (self.accountString.length == 0) {
        [OrangeMBManager show_CustomNativeByte_BriefAlert:@"请设置账号内容" time:1.0f];
        return;
    }
    if (self.accountString.length<6) {
        [OrangeMBManager show_CustomNativeByte_BriefAlert:@"账号设置不得少于六位字符" time:1.0f];
        return;
    }
    if (self.accountString.length>12) {
        [OrangeMBManager show_CustomNativeByte_BriefAlert:@"账号设置不得超过十二位字符" time:1.0f];
        return;
    }
    if (self.passwordString.length == 0) {
        [OrangeMBManager show_CustomNativeByte_BriefAlert:@"请设置密码信息" time:1.0f];
        return;
    }
    if (self.passwordString.length<6) {
        [OrangeMBManager show_CustomNativeByte_BriefAlert:@"密码设置不得少于六位字符" time:1.0f];
        return;
    }
    if (self.passwordString.length>20) {
        [OrangeMBManager show_CustomNativeByte_BriefAlert:@"密码设置不得超过二十位字符" time:1.0f];
        return;
    }
    if (self.selectBtn.selected == YES) {
        [OrangeMBManager show_CustomNativeByte_BriefAlert:@"请勾选猕猴桃用户服务协议" time:1.0f];
        return;
    }
    
    [OrangeAPIParams requestFastRegisterStep2Username:self.accountString password:self.passwordString SuccessBlock:^(id response) {
        
        //这里的接口，如果直接注册，可以直接调用style为1的接口；如果为快速注册，则需要先调用一次style为2的接口后，在调用style为1的接口方可
        NSDictionary * infoDic = (NSDictionary *)response;
        NSString * status = [NSString stringWithFormat:@"%@",infoDic[@"code"]];
        if ([status isEqualToString:@"200"]) {
            
            NSString * TAppid = [[NSUserDefaults standardUserDefaults]objectForKey:@"toutiaoAPPID"];
            NSString * TAppName = [[NSUserDefaults standardUserDefaults]objectForKey:@"toutiaoAPPNAME"];
            if (TAppid.length !=0 && TAppName.length != 0) {
                [TTTracker registerEventByMethod:@"mobile" isSuccess:YES];
                /** Method:注册⽅方式 isSuccess: 是否成功 */
            }
            
            [OrangeMBManager show_CustomNativeByte_BriefAlert:@"注册成功" time:1.0f];

            //注册成功直接调用登录接口，并弹出悬浮球，并关闭之前页面，只加载实名验证界面
            [self requestForLoginMethod];
           
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

-(void)requestForLoginMethod{
    [OrangeAPIParams requestLogin:self.accountString password:self.passwordString SuccessBlock:^(id response) {
        NSDictionary *element = (NSDictionary*)response;
        
        OrangeRespondModel * models = [OrangeRespondModel yy_modelWithJSON:element];
        if(models.code == 200){
            [OrangeMBManager show_CustomNativeByte_BriefAlert:@"登录成功" time:1];
            GreenFruit_CustomNativeByte_SDKUser * users = [GreenFruit_CustomNativeByte_SDKUser new];
            users.appId = Appid;
            users.channellevel1 = Channelleve1;
            users.channellevel2 = Channellevel2;
            users.userId = models.content.userid;
            users.accountname = [OrangeInfoArchive getAccountName];
            users.ssid = models.content.sid ? models.content.sid : @"";
            [OrangeInfoArchive putLoginStatus:[NSNumber numberWithBool:TRUE]];
            [OrangeInfoArchive putUserid:users.userId];
            [OrangeInfoArchive putSid:users.ssid];

            User_Defaules_Set(users.userId, @"USERID");

            
            //处理悬浮球相关数据
            NSDictionary * contentDic = element[@"content"];
            NSString * highlight = [NSString stringWithFormat:@"%@",contentDic[@"highlight"]];
            NSString * normal = [NSString stringWithFormat:@"%@",contentDic[@"normal"]];
            NSString * refresh = [NSString stringWithFormat:@"%@",contentDic[@"refresh"]];
            NSString * compotent = [NSString stringWithFormat:@"%@",contentDic[@"component"]];
            if ([refresh isEqualToString:@"1"]) {//此时需要缓存图片信息
                User_Defaules_Set(highlight, @"HighlightPicture");
                User_Defaules_Set(normal, @"NormalPicture");
                
            }else{
                NSLog(@"不需要缓存悬浮球图片");
            }
            
            //缓存登录信息，首页登录下拉数据时调用
            NSMutableDictionary * loginCacheDic = [[NSMutableDictionary alloc]initWithCapacity:0];
            [loginCacheDic setObject:@"System" forKey:@"LoginType"];
            [loginCacheDic setObject:self.accountString forKey:@"LoginAccount"];
            [loginCacheDic setObject:self.passwordString forKey:@"LoginPassword"];
            
            NSMutableArray * loginCacheArr = [[NSMutableArray alloc]initWithCapacity:0];
            NSMutableArray * TempArr = User_Defaults_Get(@"firstLoginCacheArr");
            if (TempArr!=nil) {
                loginCacheArr = [TempArr mutableCopy];
                
            }else{
                NSLog(@"缓存中暂无登录信息数组");
            }
            [loginCacheArr addObject:loginCacheDic];
            
            User_Defaules_Set(loginCacheArr,@"firstLoginCacheArr");
            
            //设置正在登录状态
            [[NSUserDefaults standardUserDefaults]setObject:@"3" forKey:@"loginingType"];
            
//            NSMutableArray * infoArr = User_Defaults_Get(@"firstLoginCacheArr");
//            NSLog(@"-重新封装好的登录缓存数组:--%@",infoArr);
            
            //回传信息，并跳转实名认证
            if (self.registSuccessBlock) {
                if (self.completionBlock) {
                    NSString * codeStr = [NSString stringWithFormat:@"%ld",(long)models.code];
                    self.completionBlock(users, codeStr);
                    self.registSuccessBlock(self, self.completionBlock, compotent);

                }
            }
            
            NSMutableDictionary * loginDic = [NSMutableDictionary dictionary];
            loginDic[@"login"] = @"1";
            loginDic[@"floatModel"] = models.content.floatmodel;
            [[NSNotificationCenter defaultCenter] postNotificationName:login_notification object:loginDic];
            
            /**头条登录埋点**/
            NSString * TAppid = [[NSUserDefaults standardUserDefaults]objectForKey:@"toutiaoAPPID"];
            NSString * TAppName = [[NSUserDefaults standardUserDefaults]objectForKey:@"toutiaoAPPNAME"];
            if (TAppid.length !=0 && TAppName.length != 0) {
                NSLog(@"userid%@",USERID);

                [[TTInstallIDManager sharedInstance] setCurrentUserUniqueID:USERID];
                [TTTracker loginEventByMethod:@"mobile" isSuccess:YES];
            }
            
        }else{
            NSString * message = [NSString stringWithFormat:@"%@",element[@"message"]];
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




//协议按钮
- (IBAction)protocolMethod:(id)sender {
    
    self.userProtocolView = [[[OrangeGreenFruitBundle mainBundle]loadNibNamed:@"GreenFruitUserProtochlViewBlackCustomControl" owner:self options:nil] lastObject];
    [self pop_CustomNativeByte_SDKView:self.userProtocolView];
    
}

//是否明码输入
- (IBAction)weatherSeePsdMethod:(UIButton *)sender {
    
    if (sender.selected == NO) {
        NSString * imgPath = [[OrangeGreenFruitBundle mainBundle]pathForResource:@"Orange闭眼睛_2" ofType:@"png"];
        [sender setBackgroundImage:[UIImage imageWithData:[NSData dataWithContentsOfFile:imgPath]] forState:UIControlStateNormal];
        sender.selected = YES;
        self.setPasswordTextfield.secureTextEntry = NO;
    }else{
        NSString * imgPath = [[OrangeGreenFruitBundle mainBundle]pathForResource:@"Orange闭眼睛_2.0" ofType:@"png"];
        [sender setBackgroundImage:[UIImage imageWithData:[NSData dataWithContentsOfFile:imgPath]] forState:UIControlStateNormal];
        sender.selected = NO;
        self.setPasswordTextfield.secureTextEntry = YES;
    }
}

#pragma mark --- SDK页面跳转封装方法
- (void)handleCustom_CustomNativeByte_ActionEnvent:(OrangeZJAnimationPopView *)popView customerView:(UIView*)customerView{
    if ([customerView isKindOfClass:[GreenFruitRealIdentityCheckViewBlackCustomControl class]]) {
        GreenFruitRealIdentityCheckViewBlackCustomControl * realCheckView = (GreenFruitRealIdentityCheckViewBlackCustomControl *)customerView;
        realCheckView.gobackClickBlock = ^{
            [popView dismiss];
        };
    }
    else if ([customerView isKindOfClass:[GreenFruitUserProtochlViewBlackCustomControl class]]){
        GreenFruitUserProtochlViewBlackCustomControl * userProtocolView = (GreenFruitUserProtochlViewBlackCustomControl *)customerView;
        userProtocolView.goBackClickedBlock = ^{
            [popView dismiss];
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

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

@end
