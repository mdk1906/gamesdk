//
//  GreenFruitModitynewPasswordViewBlackCustomControl.m
//  GreenFruitframework
//
//  Created by 张 on 2018/12/19.
//  Copyright © 2018年 Hu. All rights reserved.
//

#import "GreenFruitModitynewPasswordViewBlackCustomControl.h"
#import "OrangeGreenFruitConfig.h"
#import "OrangeNSString+Utils.h"
#import "OrangeMBManager.h"
#import "OrangeAPIParams.h"
#import "OrangeInfoArchive.h"
#import "OrangeUIImageView+MHImageWebCache.h"
#import "OrangeGreenFruitBundle.h"

@interface  GreenFruitModitynewPasswordViewBlackCustomControl ()<UITextFieldDelegate>
{
    NSInteger timeNumber;
    NSTimer * timer;
}
@property (nonatomic,copy) NSString * codeNumber;
@property (nonatomic,copy) NSString * password;
@property (nonatomic,copy) NSString * confirmPassword;
@property (nonatomic,copy) NSString * userName;
@property (nonatomic,copy) NSString * textfieldName;
@end

@implementation GreenFruitModitynewPasswordViewBlackCustomControl

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    NSLog(@"进入新的修改密码的重绘界面");
    
    self.userName = [OrangeInfoArchive getAccountName];
    
    [self configView];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeRotate:) name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
    
    //注册观察键盘的变化
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
}

-(void)configView{
    self.codeTextfield.keyboardType = UIKeyboardTypeNumberPad;
    self.codeTextfield.delegate = self;
    self.codeTextfield.tag = 100;
    self.ensureBtn.layer.cornerRadius = 20.0f;
    
    self.passwordtextfield.keyboardType = UIKeyboardTypeNumberPad;
    self.passwordtextfield.delegate = self;
    self.passwordtextfield.tag = 200;
    self.confirmTextfield.keyboardType = UIKeyboardTypeNumberPad;
    self.confirmTextfield.delegate = self;
    self.confirmTextfield.tag = 300;
    
    self.infoLabel.text = [NSString stringWithFormat:@"%@",self.phoneNum];
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];

    self.textfieldName = @"1";
    
    NSString * publicPath = User_Defaults_Get(@"publicImgPath");
    UIImage * getImage = [UIImage imageWithContentsOfFile:publicPath];
    self.loginImageView.image = getImage;
    
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (orientation == UIInterfaceOrientationPortrait
        || orientation == UIInterfaceOrientationPortraitUpsideDown){
        NSLog(@"进来时是竖屏");
        [self setWidth:300];
        [self setHeight:330];
        //        [self verticalUI];
        self.center = CGPointMake(self.superview.bounds.size.width/2, self.superview.bounds.size.height/2);
    }
    else{
        if(IS_IPHONE){
            NSLog(@"设备为手机");
            //    [self horizontalUI];
            [self setWidth:400];
            [self setHeight:320];
            self.center = CGPointMake(self.superview.bounds.size.width/2, self.superview.bounds.size.height/2);
        }else{
            NSLog(@"设备为ipad");
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
    //    CGFloat offset = (self.identityNumbertextfield.frame.origin.y+self.identityNumbertextfield.frame.size.height+10) - (self.frame.size.height - kbHeight);
    CGFloat offset;
    if ([self.textfieldName isEqualToString:@"1"]) {
        offset = (self.codeTextfield.frame.origin.y+self.codeTextfield.frame.size.height+10) - (kScreenHeight - kbHeight);
    }
    else if ([self.textfieldName isEqualToString:@"2"]){
        offset = (self.passwordtextfield.frame.origin.y+self.passwordtextfield.frame.size.height+10) - (kScreenHeight - kbHeight);
    }
    else if ([self.textfieldName isEqualToString:@"3"]){
        offset = (self.confirmTextfield.frame.origin.y+self.confirmTextfield.frame.size.height+10) - (kScreenHeight - kbHeight);
    }
    else{
        offset = (self.codeTextfield.frame.origin.y+self.codeTextfield.frame.size.height+10) - (kScreenHeight - kbHeight);
        
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
    if (textField == self.codeTextfield) {
        self.textfieldName = @"1";
    }else if (textField == self.passwordtextfield){
        self.textfieldName = @"2";
    }else if (textField == self.confirmTextfield){
        self.textfieldName = @"3";
    }else{
        
    }
}

#pragma mark --- UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField{
    NSInteger tag = textField.tag;
    switch (tag) {
            
        case 100:
        {
            self.codeNumber = [NSString stringWithFormat:@"%@",textField.text];
        }
            break;
        case 200:
        {
            
            self.password = [NSString stringWithFormat:@"%@",textField.text];
        }
            break;
        case 300:
        {
            
            self.confirmPassword = [NSString stringWithFormat:@"%@",textField.text];
        }
            break;
        default:
            break;
    }
}



- (IBAction)returnBtnMethod:(id)sender {
    if (self.goBackClickBlock) {
        self.goBackClickBlock();
    }
}

- (IBAction)closeViewMethod:(id)sender {
    if (self.closeviewBlock) {
        self.closeviewBlock();
    }
}

- (IBAction)getCodeMethod:(UIButton *)sender {
    [self endEditing:YES];
    
    [OrangeAPIParams requestUsername:self.userName successblock:^(id response) {
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



- (IBAction)ensureMethod:(id)sender {
    
    [self endEditing:YES];
    
    if (self.codeNumber.length == 0) {
        [OrangeMBManager show_CustomNativeByte_BriefAlert:@"请输入验证码" time:1.0f];
        return;
    }
    if (self.password.length == 0) {
        [OrangeMBManager show_CustomNativeByte_BriefAlert:@"请输入新密码" time:1.0f];
        return;
    }
    if (self.confirmPassword.length == 0) {
        [OrangeMBManager show_CustomNativeByte_BriefAlert:@"请输入确认密码" time:1.0f];
        return;
    }
    if (![self.password isEqualToString:self.confirmPassword]) {
        [OrangeMBManager show_CustomNativeByte_BriefAlert:@"两次密码输入不一致" time:1.0f];
        return;
    }
    
    [OrangeAPIParams requestUpdatePasswordUsername:self.userName password:self.password vcode:self.codeNumber successBlock:^(id response) {
        
        NSDictionary * infoDic = (NSDictionary *)response;
        NSString * status = [NSString stringWithFormat:@"%@",infoDic[@"code"]];
        if ([status isEqualToString:@"200"]) {
            
            [OrangeMBManager show_CustomNativeByte_BriefAlert:@"修改成功" time:1.0f];
            if (self.modifySuccessBlock) {
                self.modifySuccessBlock();
            }
            
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

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}



@end
