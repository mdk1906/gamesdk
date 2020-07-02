//
//  GreenFruitSetNewBoundPhoneViewBlackCustomControl.m
//  GreenFruitframework
//
//  Created by 张 on 2018/12/19.
//  Copyright © 2018年 Hu. All rights reserved.
//

#import "GreenFruitSetNewBoundPhoneViewBlackCustomControl.h"
#import "OrangeGreenFruitConfig.h"
#import "OrangeNSString+Utils.h"
#import "OrangeMBManager.h"
#import "OrangeAPIParams.h"
#import "OrangeUIImageView+MHImageWebCache.h"
#import "OrangeGreenFruitBundle.h"

@interface GreenFruitSetNewBoundPhoneViewBlackCustomControl()<UITextFieldDelegate>
{
    NSInteger timeNumber;
    NSTimer * timer;
}
@property (nonatomic,copy) NSString * phoneNumber;
@property (nonatomic,copy) NSString * codeNumber;
@property (nonatomic,copy) NSString * textfieldName;

@end

@implementation GreenFruitSetNewBoundPhoneViewBlackCustomControl

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
    self.ensureBtn.layer.cornerRadius = 20.0f;
    self.phoneTextfield.keyboardType = UIKeyboardTypeNumberPad;
    self.phoneTextfield.delegate = self;
    self.phoneTextfield.tag = 100;
    self.codeTextfield.keyboardType = UIKeyboardTypeNumberPad;
    self.codeTextfield.delegate = self;
    self.codeTextfield.tag = 200;
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];

    NSString * publicPath = User_Defaults_Get(@"publicImgPath");
    UIImage * getImage = [UIImage imageWithContentsOfFile:publicPath];
    self.logoImageView.image = getImage;
    
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
        offset = (self.phoneTextfield.frame.origin.y+self.phoneTextfield.frame.size.height+20) - (kScreenHeight - kbHeight);
    }
    else if ([self.textfieldName isEqualToString:@"2"]){
        offset = (self.codeTextfield.frame.origin.y+self.codeTextfield.frame.size.height+20) - (kScreenHeight - kbHeight);
    }
    else{
        offset = (self.phoneTextfield.frame.origin.y+self.phoneTextfield.frame.size.height+20) - (kScreenHeight - kbHeight);
        
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
    if (textField == self.phoneTextfield) {
        self.textfieldName = @"1";
    }else if (textField == self.codeTextfield){
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
            self.phoneNumber = [NSString stringWithFormat:@"%@",textField.text];
        }
            break;
        case 200:
        {
            self.codeNumber = [NSString stringWithFormat:@"%@",textField.text];
        }
            break;
        default:
            break;
    }
}



- (IBAction)returnMethod:(id)sender {
    if (self.goBackClickBlock) {
        self.goBackClickBlock();
    }
}

- (IBAction)closeMethod:(id)sender {
    if (self.closeviewBlock) {
        self.closeviewBlock();
    }
}

- (IBAction)getcodeMethod:(UIButton *)sender {
    [self endEditing:YES];
    
    if (self.phoneNumber.length==0) {
        [OrangeMBManager show_CustomNativeByte_BriefAlert:@"请输入手机号码" time:1.0f];
        return;
    }
    BOOL isRight = [NSString isValidPhoneNumber:self.phoneNumber];
    if (isRight == NO) {
        [OrangeMBManager show_CustomNativeByte_BriefAlert:@"手机号码格式不正确" time:1.0f];
        return;
    }
    
    //获取验证码接口
    [OrangeAPIParams requestPhone:self.phoneNumber successblock:^(id response) {
        
        NSDictionary *infoDic = (NSDictionary*)response;
        
        NSLog(@"拿到短信接口返回的信息：%@",infoDic);
        
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
    [self.getcodeBtn setTitle:titleStr forState:UIControlStateNormal];
    if (timeNumber == 0) {
        [timer invalidate];
        timer = nil;
        self.getcodeBtn.enabled = YES;
        [self.getcodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [self.getcodeBtn setTitleColor:[UIColor colorWithRed:0.427 green:0.796 blue:0.965 alpha:1.0f] forState:UIControlStateNormal];
    }
}


- (IBAction)ensureMethod:(id)sender {
    
    [self endEditing:YES];
    
    if (self.phoneNumber.length == 0) {
        [OrangeMBManager show_CustomNativeByte_BriefAlert:@"请输入手机号码" time:1.0f];
        return;
    }
    if (self.codeNumber.length == 0) {
        [OrangeMBManager show_CustomNativeByte_BriefAlert:@"请输入验证码" time:1.0f];
        return;
    }
    
    [OrangeAPIParams requestChangePhone:self.phoneNumber vcode:self.codeNumber Successblock:^(id response) {
        NSDictionary * infoDic = (NSDictionary *)response;
        NSString * status = [NSString stringWithFormat:@"%@",infoDic[@"code"]];
        if ([status isEqualToString:@"200"]) {
            
            [OrangeMBManager show_CustomNativeByte_BriefAlert:@"修改成功" time:1.0f];
            if (self.modifyNewPhoneBlock) {
                self.modifyNewPhoneBlock();
            }
            
        }else{
            NSString * message = [NSString stringWithFormat:@"%@",infoDic[@"message"]];
            [OrangeMBManager show_CustomNativeByte_BriefAlert:message time:1.0f];
            if (self.modifyNewPhoneBlock) {
                self.modifyNewPhoneBlock();
            }
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
