//
//  GreenFruitPhoneLoginGetCodeViewBlackCustomControl.m
//  GreenFruitframework
//
//  Created by 张 on 2018/12/8.
//  Copyright © 2018年 Hu. All rights reserved.
//

#import "GreenFruitPhoneLoginGetCodeViewBlackCustomControl.h"
#import "XMTextFieldBlackCustomControl.h"
#import "OrangeAPIParams.h"
#import "OrangeMBManager.h"
#import "GreenFruitSetPasswordViewBlackCustomControl.h"
#import "OrangeGreenFruitBundle.h"
#import "OrangeGreenFruitConfig.h"
#import "OrangeInfoArchive.h"
#import "OrangeRespondModel.h"
#import "OrangeYYModel.h"
#import "OrangeUIImageView+MHImageWebCache.h"

//今日头条
#import <TTTracker/TTTracker.h>
#import <TTTracker/TTTracker+Game.h>
#import <TTTracker/TTInstallIDManager.h>

@interface GreenFruitPhoneLoginGetCodeViewBlackCustomControl()<XMTextFieldDelegate>
{
    NSInteger timeNumber;
    
    NSTimer * timer;
}
@property (weak, nonatomic) IBOutlet UIView *bgContentView;
@property (weak, nonatomic) IBOutlet XMTextFieldBlackCustomControl *num1F;
@property (weak, nonatomic) IBOutlet XMTextFieldBlackCustomControl *num2F;
@property (weak, nonatomic) IBOutlet XMTextFieldBlackCustomControl *num3F;
@property (weak, nonatomic) IBOutlet XMTextFieldBlackCustomControl *num4F;
/// 用于保持键盘不退下的textField
@property (weak, nonatomic) XMTextFieldBlackCustomControl *holdOnF;
@property (nonatomic, copy) NSString * confirmCode;
@property (nonatomic, strong) GreenFruitSetPasswordViewBlackCustomControl * setPasswordView;
@property (nonatomic, retain) NSString * userName;
@property (nonatomic, retain) NSString * password;

@end

@implementation GreenFruitPhoneLoginGetCodeViewBlackCustomControl

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    [self configView];
    
    [self initData];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeRotate:) name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
    
}


-(void)configView{
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];

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
    
    XMTextFieldBlackCustomControl *holdOnF = [[XMTextFieldBlackCustomControl alloc]initWithFrame:CGRectZero];
    holdOnF.keyboardType = UIKeyboardTypeNumberPad;
    holdOnF.xmDelegate = self;
    [self addSubview:holdOnF];
    _holdOnF = holdOnF;
    
    self.reactionBtn.userInteractionEnabled = YES;
    
    // 1秒后，让密码输入成为第一响应
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self becomeKeyBoardFirstResponder];
    });
}

-(void)initData{
    
    self.confirmCode = @"";
    
    //密文输入
    [self setSecureTextEntry:NO];
    
    [self setPayBlock:^(NSString *payCode) {

        __weak typeof(self) myself = self;
        myself.confirmCode = payCode;
    }];
    
    self.phoneNumberLabel.text = [NSString stringWithFormat:@"%@",self.phone];
    
}


#pragma mark -- 适配横屏竖屏
- (void)changeRotate:(NSNotification*)notification{
    //    [self createBorder];
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


+ (instancetype)payCodeView
{
    GreenFruitPhoneLoginGetCodeViewBlackCustomControl *payCodeView = [[GreenFruitPhoneLoginGetCodeViewBlackCustomControl alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 65)];
    return payCodeView;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    _num1F.xmDelegate = self;
    [_num1F addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    _num2F.xmDelegate = self;
    [_num2F addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    _num3F.xmDelegate = self;
    [_num3F addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    _num4F.xmDelegate = self;
    [_num4F addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
}

/// 设置第一响应者
- (void)setFirstResponderForIndex:(NSInteger)index
{
    //    NSLog(@"setFirstResponderForIndex==%ld",index);
    switch (index) {
        case 0:
            [_num1F becomeFirstResponder];break;
        case 1:
            [_num2F becomeFirstResponder];break;
        case 2:
            [_num3F becomeFirstResponder];break;
        case 3:
            [_num4F becomeFirstResponder];break;
            
        default:break;
    }
}

/// 让第一格输入成为键盘响应者
- (void)becomeKeyBoardFirstResponder
{
    [self setFirstResponderForIndex:0];
}

/// 设置是否暗文显示
- (void)setSecureTextEntry:(BOOL)secureTextEntry
{
    [self.bgContentView.subviews enumerateObjectsUsingBlock:^(__kindof XMTextFieldBlackCustomControl * _Nonnull textF, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([textF isKindOfClass:[XMTextFieldBlackCustomControl class]]) {
            textF.secureTextEntry = secureTextEntry;
        }
    }];
}

#pragma mark - XMTextFieldDelegate
/// 删除键监听
- (void)xmTextFeildDeleteBackward:(UITextField *)textField{
    

    if (textField.text.length==0) {
        
        if ([textField isEqual:_num1F]) {
        }
        else if ([textField isEqual:_num2F] ) {

            [self setFirstResponderForIndex:0];
            _num1F.text = nil;
        }
        else if ([textField isEqual:_num3F] ) {
            [self setFirstResponderForIndex:1];
            _num2F.text = nil;
        }
        else if ([textField isEqual:_num4F] ) {
            [self setFirstResponderForIndex:2];
            _num3F.text = nil;
        }
        else if ([textField isEqual:_holdOnF]){
            _holdOnF.text = nil;
            _num4F.text = nil;
            [self setFirstResponderForIndex:3];
        }
    }
    
    if (self.endEditingOnFinished) return;
    // 收集支付密码
    [self collectPayCode];
    
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
   
    NSString * tempString = [NSString stringWithFormat:@"%@%@",textField.text,string];
    
    if (tempString.length>1) {
        NSLog(@"不允许输入两个字符");
        return NO;
    }
    
    if ([textField isEqual:_holdOnF]) {
        return NO;
    }
    return YES;
}


#pragma mark - 其他处理
// 有文字输入会触发
- (void)textFieldDidChange:(UITextField *)textField{
    
    // 收集支付密码
    [self collectPayCode];
    
    if ([textField isEqual:_num1F]) {
        [self setFirstResponderForIndex:1];
    }else if ([textField isEqual:_num2F] ) {
        [self setFirstResponderForIndex:2];
    }else if ([textField isEqual:_num3F] ) {
        [self setFirstResponderForIndex:3];
    }else if ([textField isEqual:_num4F]){
        
        if (self.endEditingOnFinished) { // 是否退下键盘
            [_num4F resignFirstResponder];
        }else{
            [_holdOnF becomeFirstResponder];
        }
        
        if (_payBlock) {
            _payBlock(_payCode);
        }
        
        [self endEditing:YES];
        
        [self phoneRegistion];
        
    }
}

//检查验证码和手机号
-(void)phoneRegistion{
    
    
    [OrangeAPIParams requestCheckComfirmPhone:self.phone withConfirmCode:self.confirmCode withStyle:@"1" SuccessBlock:^(id response) {
        NSDictionary * infoDic = (NSDictionary *)response;
        NSString * status = [NSString stringWithFormat:@"%@",infoDic[@"code"]];
        if ([status isEqualToString:@"200"]) {
            
            [OrangeMBManager show_CustomNativeByte_BriefAlert:@"验证成功" time:1.0f];
            NSLog(@"验证成功，进行登录操作，并缓存账号和密码");
            
            [self requestForRegistionMethod];//调用注册接口
            
        }else{
            NSString * message = [NSString stringWithFormat:@"%@",infoDic[@"message"]];
            [OrangeMBManager show_CustomNativeByte_BriefAlert:message time:1.0f];
            
        }
    } failedBlock:^(NSError *error) {
        NSLog(@"错误信息:%@",error);
        if(error.code == 4){
            [OrangeMBManager show_CustomNativeByte_BriefAlert:@"网络异常" time:1];
        }else{
            [OrangeMBManager show_CustomNativeByte_BriefAlert:@"异常错误" time:1];
        }
    }];
}

//调用注册接口
-(void)requestForRegistionMethod{
    
    [OrangeAPIParams requestForPhoneRegistionMethod:self.phone withVcode:self.confirmCode SuccessBlock:^(id response) {
        
        
        
        NSDictionary * element = (NSDictionary *)response;
        
        NSDictionary * contentDic = element[@"content"];
        
        NSLog(@"返回信息  %@",element);
        NSString * code = [NSString stringWithFormat:@"%@",element[@"code"]];
        if ([code isEqualToString:@"200"]) {
            
            self.userName = [NSString stringWithFormat:@"%@",contentDic[@"username"]];
            self.password = [NSString stringWithFormat:@"%@",contentDic[@"password"]];
            
            NSString * TAppid = [[NSUserDefaults standardUserDefaults]objectForKey:@"toutiaoAPPID"];
            NSString * TAppName = [[NSUserDefaults standardUserDefaults]objectForKey:@"toutiaoAPPNAME"];
            if (TAppid.length !=0 && TAppName.length != 0) {
                [TTTracker registerEventByMethod:@"mobile" isSuccess:YES];
                /** Method:注册⽅方式 isSuccess: 是否成功 */
            }
            
            [self requestPhoneLoginMethod];
            
        }else{
            
            [OrangeMBManager show_CustomNativeByte_BriefAlert:@"请求失败" time:1];

        }
       
    } failedBlock:^(NSError *error) {
        if(error.code == 4){
            [OrangeMBManager show_CustomNativeByte_BriefAlert:@"网络异常" time:1];
        }else{
            [OrangeMBManager show_CustomNativeByte_BriefAlert:@"异常错误" time:1];
        }
    }];

}

-(void)requestPhoneLoginMethod{
    
    [OrangeAPIParams requestPhoneLogin:self.userName password:self.password SuccessBlock:^(id response) {
        NSDictionary * element = (NSDictionary *)response;
        
        OrangeRespondModel *model = [OrangeRespondModel yy_modelWithJSON:element];
        if(model.code == 200){
            GreenFruit_CustomNativeByte_SDKUser *user = [GreenFruit_CustomNativeByte_SDKUser new];
            user.appId = Appid;
            user.channellevel1 = Channelleve1;
            user.channellevel2 = Channellevel2;
            user.userId = model.content.userid;
            user.accountname = self.userName;
            user.ssid = model.content.sid ? model.content.sid : @"";
            [OrangeInfoArchive putLoginStatus:[NSNumber numberWithBool:TRUE]];
            [OrangeInfoArchive putUserid:user.userId];
            [OrangeInfoArchive putSid:user.ssid];
            [OrangeInfoArchive putAccountName:self.userName];
            [OrangeInfoArchive putLoginPwd:self.password];
          
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
            
            [self doCacheMethod];//缓存登录信息
            
            
            NSString * componentType = [NSString stringWithFormat:@"%@",contentDic[@"component"]];
            if ([componentType isEqualToString:@"identity"]) {
                NSLog(@"需要跳转实名验证");
                if (self.realIdentifyCheckBlock) {
                    self.realIdentifyCheckBlock();
                }
            }
            else if ([componentType isEqualToString:@"skip"]){

                if (self.skipViewBlock) {
                    self.skipViewBlock();
                }
                
            }
            else if ([componentType isEqualToString:@"phone"]){
                NSLog(@"调转绑定手机界面");
                if (self.boundPhoneBlock) {
                    self.boundPhoneBlock();
                }
            }
            else{
                if (self.skipViewBlock) {
                    self.skipViewBlock();
                }
            }
            
            //登录信息回调
            if (self.successCheckCodeBlock) {
                if (self.completionBlock) {
                    NSString * codeStr = [NSString stringWithFormat:@"%ld",(long)model.code];
                    self.completionBlock(user, codeStr);
                    self.successCheckCodeBlock(self.completionBlock);
                    
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
        }
        else{
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


//登录后进行信息缓存
-(void)doCacheMethod{
    //dadada  这里只储存手机号注册成功后返回的密码，不需要经过二次加密。其他密码不变
    NSString * loginType = [NSString stringWithFormat:@"Phone"];
    NSMutableDictionary * loginCacheDic = [[NSMutableDictionary alloc]init];
    [loginCacheDic setValue:loginType forKey:@"LoginType"];
    [loginCacheDic setValue:self.userName forKey:@"LoginAccount"];
    [loginCacheDic setValue:self.password forKey:@"LoginPassword"];
    
    NSMutableArray * loginCacheArr = [[NSMutableArray alloc]initWithCapacity:0];
    NSMutableArray * localArr = User_Defaults_Get(@"firstLoginCacheArr");
    if (localArr!=nil) {
        loginCacheArr = [localArr mutableCopy];
    }else{
        NSLog(@"缓存中的登录信息数组是空的，需要新建");
    }
    //遍历一遍缓存的信息，如果有账号相同的，就把原位置信息删除，新账号添加进缓存数组
    
    BOOL isSame;//是否有同样的账号在缓存中
    isSame = NO;
    if (loginCacheArr.count!=0) {
        NSInteger countNumber = loginCacheArr.count;
        for (int i = 0; i<countNumber; i++) {
            NSDictionary * cacheDic = loginCacheArr[i];
            NSString * accountName = [NSString stringWithFormat:@"%@",cacheDic[@"LoginAccount"]];
            if ([self.userName isEqualToString:accountName]) {
                [loginCacheArr removeObjectAtIndex:i];//删除原位置数据
                [loginCacheArr addObject:loginCacheDic];//加上新数据
                isSame = YES;
            }else{
//                NSLog(@"缓存中该位置账号和新增账号不一致");
            }
        }
    }
    if (isSame == NO) {//如果遍历所有账号都没有相同账号，则将新账号加入缓存
        [loginCacheArr addObject:loginCacheDic];
    }
    
    User_Defaules_Set(loginCacheArr, @"firstLoginCacheArr");
    //设置正在登录状态
    [[NSUserDefaults standardUserDefaults]setObject:@"3" forKey:@"loginingType"];
    
//    NSMutableArray * infoArr = User_Defaults_Get(@"firstLoginCacheArr");
//    NSLog(@"-重新封装好的登录缓存数组:--%@",infoArr);
    
}


/// 收集支付密码
- (void)collectPayCode
{
    NSString *payCode = _num1F.text;
    payCode = [payCode stringByAppendingString:_num2F.text];
    payCode = [payCode stringByAppendingString:_num3F.text];
    payCode = [payCode stringByAppendingString:_num4F.text];
    
    //    NSLog(@"收集支付密码payCode==%@",payCode);
    _payCode = payCode;
    
    if (self.endEditingOnFinished) return;
    if (_payBlock) {
        _payBlock(_payCode);
    }
}

//定时器
-(void)codeTimerMethod{

    timeNumber = timeNumber-1;
    NSString * titleStr = [NSString stringWithFormat:@"%ld(s)",(long)timeNumber];
    [self.getCodeBtn setTitle:titleStr forState:UIControlStateNormal];
    if (timeNumber == 0) {
        [timer invalidate];
        timer = nil;
        self.getCodeBtn.enabled = YES;
        [self.getCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [self.getCodeBtn setTitleColor:[UIColor colorWithRed:0.427 green:0.796 blue:0.965 alpha:1.0f] forState:UIControlStateNormal];
    }
}

#pragma mark --- SDK页面跳转封装方法
- (void)handleCustom_CustomNativeByte_ActionEnvent:(OrangeZJAnimationPopView *)popView customerView:(UIView*)customerView{
    
    if ([customerView isKindOfClass:[GreenFruitSetPasswordViewBlackCustomControl class]]){
        GreenFruitSetPasswordViewBlackCustomControl * confirmCodeView = (GreenFruitSetPasswordViewBlackCustomControl *)customerView;
        confirmCodeView.goBackClickedBlock = ^{
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

- (IBAction)returnBackBtn:(UIButton *)sender {
    if (self.goBackClickedBlock) {
        self.goBackClickedBlock();
    }
}

- (IBAction)closeView:(UIButton *)sender {
    if (self.closeViewBlock) {
        self.closeViewBlock();
    }
}

- (IBAction)getCodemethod:(UIButton *)sender {
    
    //获取验证码接口
    [OrangeAPIParams requestPhone:self.phone successblock:^(id response) {
        
        NSDictionary *infoDic = (NSDictionary*)response;
        
        NSString * status = [NSString stringWithFormat:@"%@",infoDic[@"code"]];
        if ([status isEqualToString:@"200"]) {
            
            timeNumber = 60;
            sender.enabled = NO;
            NSString * titleStr = [NSString stringWithFormat:@"%ld(s)",(long)timeNumber];
            [sender setTitle:titleStr forState:UIControlStateNormal];
            timer =  [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(codeTimerMethod) userInfo:nil repeats:YES];
            
        }else{
            [OrangeMBManager show_CustomNativeByte_BriefAlert:@"短信获取失败" time:1.0f];
        }
        
    } failedblock:^(NSError *error) {
        if(error.code == 4){
            [OrangeMBManager show_CustomNativeByte_BriefAlert:@"网络异常" time:1];
        }else{
            [OrangeMBManager show_CustomNativeByte_BriefAlert:@"异常错误" time:1];
        }
    }];
}

- (IBAction)reactionBtn:(id)sender {
    
    if (_num1F.text.length==0) {
        [self setFirstResponderForIndex:0];
    }else if (_num2F.text.length == 0){
        [self setFirstResponderForIndex:1];
    }else if (_num3F.text.length == 0){
        [self setFirstResponderForIndex:2];
    }else if (_num4F.text.length == 0){
        [self setFirstResponderForIndex:3];
    }
    else{
        [_holdOnF becomeFirstResponder];
    }
}

- (IBAction)doSomethingMethod:(id)sender {
    NSLog(@"do something");
    
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
}

@end
