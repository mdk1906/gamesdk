//
//  GreenFruitSystemAccountLoginBlackCustomControl.m
//  GreenFruitframework
//
//  Created by 张 on 2018/11/30.
//  Copyright © 2018年 Hu. All rights reserved.
//

#import "GreenFruitSystemAccountLoginBlackCustomControl.h"
#import "GreenFruitFindPasswordViewBlackCustomControl.h"
#import "OrangeGreenFruitBundle.h"
#import "GreenFruitRegistionViewBlackCustomControl.h"
#import "OrangeMBManager.h"
#import "OrangeAPIParams.h"
#import "OrangeNSString+Utils.h"
#import "OrangeGreenFruitConfig.h"
#import "OrangeRespondModel.h"
#import "OrangeYYModel.h"
#import "OrangeInfoArchive.h"
#import "OrangeUIImageView+MHImageWebCache.h"

#import <TTTracker/TTTracker.h>
#import <TTTracker/TTTracker+Game.h>
#import <TTTracker/TTInstallIDManager.h>

@interface GreenFruitSystemAccountLoginBlackCustomControl ()<UITextFieldDelegate>

@property (nonatomic,strong)GreenFruitFindPasswordViewBlackCustomControl * findPasswordView;
@property (nonatomic,strong)GreenFruitRegistionViewBlackCustomControl * registionView;
@property (nonatomic,retain)NSString * accountString;
@property (nonatomic,retain)NSString * passwordString;
@property (nonatomic,retain)NSString * textfieldName;
@end

@implementation GreenFruitSystemAccountLoginBlackCustomControl

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    [self configView];
    
    if ([self.jumpViewType isEqualToString:@"setPasswordView"]) {
        self.systemAccounyTextfield.text = [NSString stringWithFormat:@"%@",self.accountStr];
        self.passwordTextfield.text = [NSString stringWithFormat:@"%@",self.passwordStr];
        self.accountString = self.accountStr;
        self.passwordString = self.passwordStr;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeRotate:) name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
    //注册观察键盘的变化
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)configView{
    self.loginBtn.layer.cornerRadius = 20.0f;
    self.systemAccounyTextfield.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.passwordTextfield.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.systemAccounyTextfield.delegate = self;
    self.passwordTextfield.delegate = self;
    self.systemAccounyTextfield.tag = 100;
    self.passwordTextfield.tag = 200;
    self.passwordTextfield.secureTextEntry = YES;
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    self.backLayerView.layer.cornerRadius = 10.0f;
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
        [self verticalUI];
        [self setWidth:300];
        [self setHeight:330];
        
        self.center = CGPointMake(self.superview.bounds.size.width/2, self.superview.bounds.size.height/2);
        
    } else {
        //横屏
        if(IS_IPHONE){
            [self horizontalUI];
            [self setWidth:400];
            [self setHeight:320];
            self.center = CGPointMake(self.superview.bounds.size.width/2, self.superview.bounds.size.height/2);
        }else{
            [self verticalUI];
            [self setWidth:400];
            [self setHeight:340];
            self.center = CGPointMake(self.superview.bounds.size.width/2, self.superview.bounds.size.height/2);
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




- (IBAction)loginMethod:(id)sender {
    
    [self endEditing:YES];

    if (self.accountString.length == 0) {
        [OrangeMBManager show_CustomNativeByte_BriefAlert:@"请输入平台账号" time:1.0f];
        return;
    }
    if (self.passwordString.length == 0) {
        [OrangeMBManager show_CustomNativeByte_BriefAlert:@"请输入登录密码" time:1.0f];
        return;
    }
    
    [OrangeAPIParams requestLogin:self.accountString password:self.passwordString SuccessBlock:^(id response) {
        
        NSDictionary * element = (NSDictionary *)response;
        OrangeRespondModel *model = [OrangeRespondModel yy_modelWithJSON:element];
        if(model.code == 200){
            GreenFruit_CustomNativeByte_SDKUser *user = [GreenFruit_CustomNativeByte_SDKUser new];
            user.appId = Appid;
            user.channellevel1 = Channelleve1;
            user.channellevel2 = Channellevel2;
            user.userId = model.content.userid;
            user.accountname = self.accountString;
            user.ssid = model.content.sid ? model.content.sid : @"";
            [OrangeInfoArchive putLoginStatus:[NSNumber numberWithBool:TRUE]];
            [OrangeInfoArchive putUserid:user.userId];
            [OrangeInfoArchive putSid:user.ssid];
            [OrangeInfoArchive putAccountName:self.accountString];
            [OrangeInfoArchive putLoginPwd:self.passwordString];
            
            User_Defaules_Set(user.userId, @"USERID");

            
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
//            NSLog(@"从缓存中拿到的登录信息数组:%@",loginCacheArr);
            //遍历一遍缓存的信息，如果有账号相同的，就把原位置信息删除，新账号添加进缓存数组
            
            BOOL isSame;//是否有同样的账号在缓存中
            isSame = NO;
            if (loginCacheArr.count!=0) {
                NSInteger countNumber = loginCacheArr.count;
                for (int i = 0; i<countNumber; i++) {
                    NSDictionary * cacheDic = loginCacheArr[i];
                    NSString * accountName = [NSString stringWithFormat:@"%@",cacheDic[@"LoginAccount"]];
                    if ([self.accountString isEqualToString:accountName]) {
                        [loginCacheArr removeObjectAtIndex:i];//删除原位置数据
                        [loginCacheArr addObject:loginCacheDic];//加上新数据
                        isSame = YES;
                    }else{
//                        NSLog(@"缓存中该位置账号和新增账号不一致");
                    }
                }
            }
            if (isSame == NO) {//如果遍历所有账号都没有相同账号，则将新账号加入缓存
                [loginCacheArr addObject:loginCacheDic];
            }
            User_Defaules_Set(loginCacheArr,@"firstLoginCacheArr");
            
            //设置正在登录状态
            [[NSUserDefaults standardUserDefaults]setObject:@"3" forKey:@"loginingType"];
            
//            NSMutableArray * infoArr = User_Defaults_Get(@"firstLoginCacheArr");
//            NSLog(@"-重新封装好的登录缓存数组:--%@",infoArr);
            
            if (self.loginSuccessBlock) {
                if (self.completionBlock){
                    NSString * codeStr = [NSString stringWithFormat:@"%ld",(long)model.code];
                    self.completionBlock(user, codeStr);
                    self.loginSuccessBlock(self.completionBlock);
                }
            }
        
            NSMutableDictionary *loginDic = [NSMutableDictionary dictionary];
            loginDic[@"login"] = @"1";
            loginDic[@"floatModel"] = model.content.floatmodel;
            [[NSNotificationCenter defaultCenter] postNotificationName:login_notification object:loginDic];
            [OrangeMBManager show_CustomNativeByte_BriefAlert:@"登录成功" time:1];
            
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

- (IBAction)returnBackMethod:(id)sender {
    NSLog(@"返回上一页");
    if ([self.jumpViewType isEqualToString:@"setPasswordView"]) {
        if (self.secondGobackClickedBlock) {
            self.secondGobackClickedBlock();
        }
    }else{
        if (self.goBackClickedBlock) {
            self.goBackClickedBlock();
        }
    }
    
}

- (IBAction)closeViewMethod:(id)sender {
    if (self.closeViewBlock) {
        self.closeViewBlock();
    }
}

- (IBAction)forgetPasswordMethod:(id)sender {

    if (self.forgetPasswordBlock) {
        self.forgetPasswordBlock(self);
    }
    
}

- (IBAction)registAccountMethod:(id)sender {
    
    if (self.regisAccountBlock) {
        self.regisAccountBlock(self);
    }
}

//是否明码输入
- (IBAction)weatherSeePsdMethod:(UIButton *)sender {
    
    if (sender.selected == NO) {
        NSString * imgPath = [[OrangeGreenFruitBundle mainBundle]pathForResource:@"Orange闭眼睛_2" ofType:@"png"];
        [sender setBackgroundImage:[UIImage imageWithData:[NSData dataWithContentsOfFile:imgPath]] forState:UIControlStateNormal];
        sender.selected = YES;
        self.passwordTextfield.secureTextEntry = NO;
        
    }else{
        NSString * imgPath = [[OrangeGreenFruitBundle mainBundle]pathForResource:@"Orange闭眼睛_2.0" ofType:@"png"];
        [sender setBackgroundImage:[UIImage imageWithData:[NSData dataWithContentsOfFile:imgPath]] forState:UIControlStateNormal];
        sender.selected = NO;
        self.passwordTextfield.secureTextEntry = YES;
    }
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
        offset = (self.systemAccounyTextfield.frame.origin.y+self.systemAccounyTextfield.frame.size.height+20) - (kScreenHeight - kbHeight);
    }
    else if ([self.textfieldName isEqualToString:@"2"]){
        offset = (self.passwordTextfield.frame.origin.y+self.passwordTextfield.frame.size.height+20) - (kScreenHeight - kbHeight);
    }
    else{
        offset = (self.systemAccounyTextfield.frame.origin.y+self.systemAccounyTextfield.frame.size.height+20) - (kScreenHeight - kbHeight);
        
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
    if (textField == self.systemAccounyTextfield) {
        self.textfieldName = @"1";
    }else if (textField == self.passwordTextfield){
        self.textfieldName = @"2";
    }else{
        
    }
}

#pragma mark --- UITextFieldDelegate
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


#pragma mark --- SDK页面跳转封装方法
- (void)handleCustom_CustomNativeByte_ActionEnvent:(OrangeZJAnimationPopView *)popView customerView:(UIView*)customerView{
    
    if ([customerView isKindOfClass:[GreenFruitFindPasswordViewBlackCustomControl class]]) {
        GreenFruitFindPasswordViewBlackCustomControl * findpasswordView = (GreenFruitFindPasswordViewBlackCustomControl *)customerView;
        findpasswordView.goBackBlock = ^{
            [popView dismiss];
        };
    }
    else if ([customerView isKindOfClass:[GreenFruitRegistionViewBlackCustomControl class]]) {
        GreenFruitRegistionViewBlackCustomControl * registionView = (GreenFruitRegistionViewBlackCustomControl *)customerView;
        registionView.goBackClickedBlock = ^{
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
