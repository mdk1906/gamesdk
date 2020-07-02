//
//  GreenFruitPrimaryPhoneCodeCheckViewBlackCustomControl.m
//  GreenFruitframework
//
//  Created by 张 on 2018/12/19.
//  Copyright © 2018年 Hu. All rights reserved.
//

#import "GreenFruitPrimaryPhoneCodeCheckViewBlackCustomControl.h"
#import "XMTextFieldBlackCustomControl.h"
#import "OrangeAPIParams.h"
#import "OrangeMBManager.h"
#import "GreenFruitSetPasswordViewBlackCustomControl.h"
#import "OrangeGreenFruitBundle.h"
#import "OrangeGreenFruitConfig.h"
#import "OrangeUIImageView+MHImageWebCache.h"

@interface GreenFruitPrimaryPhoneCodeCheckViewBlackCustomControl()<XMTextFieldDelegate>
{
    NSInteger timeNumber;
    
    NSTimer * timer;
}
/// 用于保持键盘不退下的textField
@property (weak, nonatomic) XMTextFieldBlackCustomControl *holdOnF;
@property (nonatomic, copy) NSString * confirmCode;
@property (nonatomic, strong) GreenFruitSetPasswordViewBlackCustomControl * setPasswordView;

@property (weak, nonatomic) IBOutlet UIView *bgContentView;
@property (weak, nonatomic) IBOutlet XMTextFieldBlackCustomControl *num1F;
@property (weak, nonatomic) IBOutlet XMTextFieldBlackCustomControl *num2F;
@property (weak, nonatomic) IBOutlet XMTextFieldBlackCustomControl *num3F;
@property (weak, nonatomic) IBOutlet XMTextFieldBlackCustomControl *num4F;

@end

@implementation GreenFruitPrimaryPhoneCodeCheckViewBlackCustomControl

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)drawRect:(CGRect)rect {
    // Drawing code
    NSLog(@"进入修改绑定手机的验证码核对界面--重绘方法");
    
    [self configView];
    
    [self initData];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeRotate:) name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
    
}

-(void)configView{
    
    XMTextFieldBlackCustomControl *holdOnF = [[XMTextFieldBlackCustomControl alloc]initWithFrame:CGRectZero];
    holdOnF.keyboardType = UIKeyboardTypeNumberPad;
    holdOnF.xmDelegate = self;
    [self addSubview:holdOnF];
    _holdOnF = holdOnF;
    
    NSString * publicPath = User_Defaults_Get(@"publicImgPath");
    UIImage * getImage = [UIImage imageWithContentsOfFile:publicPath];
    self.logoImageView.image = getImage;
    
    // 1秒后，让密码输入成为第一响应
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self becomeKeyBoardFirstResponder];
    });
  
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    
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



-(void)initData{
    
    self.confirmCode = @"";
    
    //密文输入
    [self setSecureTextEntry:NO];
    
    [self setPayBlock:^(NSString *payCode) {
        __weak typeof(self) myself = self;
        myself.confirmCode = payCode;
    }];
    
    self.phoneLabel.text = [NSString stringWithFormat:@"%@",self.showPhoneStr];
    
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
    
    //    NSLog(@"xmTextFeildDeleteBackward textField.text==%@",textField.text);
    
    if (textField.text.length==0) {
        
        if ([textField isEqual:_num1F]) {
            
        }else if ([textField isEqual:_num2F] ) {
            [self setFirstResponderForIndex:0];
            _num1F.text = nil;
        }else if ([textField isEqual:_num3F] ) {
            [self setFirstResponderForIndex:1];
            _num2F.text = nil;
        }else if ([textField isEqual:_num4F] ) {
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
        
        //进入第四个字符的判断了
        
        [self endEditing:YES];
        
        [self checkPhoneAndCodeMethod:@"2"];//用户名

    }
}


-(void)checkPhoneAndCodeMethod:(NSString *)style{
    [OrangeAPIParams requestCheckComfirmPhone:self.phone withConfirmCode:self.confirmCode withStyle:style SuccessBlock:^(id response) {
        NSDictionary * infoDic = (NSDictionary *)response;
        NSString * status = [NSString stringWithFormat:@"%@",infoDic[@"code"]];
        if ([status isEqualToString:@"200"]) {
            
            [OrangeMBManager show_CustomNativeByte_BriefAlert:@"验证成功" time:1.0f];
            
            if (self.PhoneCheckBlock) {
                self.PhoneCheckBlock();
            }
        }else{
            
            NSString * message = [NSString stringWithFormat:@"%@",infoDic[@"message"]];
            [OrangeMBManager show_CustomNativeByte_BriefAlert:message time:1.0f];
            if (self.PhoneCheckBlock) {
                self.PhoneCheckBlock();
            }
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
    //    NSLog(@"每秒走一下");
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

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
}


- (IBAction)returnBackMethod:(id)sender {
    if (self.phoneGobackBlock) {
        self.phoneGobackBlock();
    }
}

- (IBAction)closeViewMethod:(id)sender {
    if (self.phoneCloseviewBlock) {
        self.phoneCloseviewBlock();
    }
}

- (IBAction)getCodeMethod:(UIButton *)sender {
    
    [self endEditing:YES];
    
    [OrangeAPIParams requestUsername:self.phone successblock:^(id response) {
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

- (IBAction)reactionBtnMethod:(id)sender {
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
        //不弹出键盘了，此时应该执行跳转了
        [_holdOnF becomeFirstResponder];
    }
}
@end
