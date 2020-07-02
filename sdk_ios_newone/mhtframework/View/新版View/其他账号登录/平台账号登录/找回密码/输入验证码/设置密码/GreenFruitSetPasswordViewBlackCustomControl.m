//
//  GreenFruitSetPasswordViewBlackCustomControl.m
//  GreenFruitframework
//
//  Created by 张 on 2018/12/6.
//  Copyright © 2018年 Hu. All rights reserved.
//

#import "GreenFruitSetPasswordViewBlackCustomControl.h"
#import "OrangeMBManager.h"
#import "OrangeGreenFruitBundle.h"
#import "OrangeAPIParams.h"
#import "OrangeGreenFruitConfig.h"
#import "OrangeUIImageView+MHImageWebCache.h"


@interface GreenFruitSetPasswordViewBlackCustomControl()<UITextFieldDelegate>
@property (nonatomic,retain)NSString * passwordString;
@end

@implementation GreenFruitSetPasswordViewBlackCustomControl

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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textfieldContentChangedMethod:) name:UITextFieldTextDidChangeNotification object:self.setPasswordTextfield];
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
    
    self.setPasswordTextfield.delegate = self;
    self.weatherseePsdBtn.backgroundColor = [UIColor whiteColor];
    self.ensureModifyBtn.layer.cornerRadius = 20.0f;
    self.phoneNumberLabel.text = [NSString stringWithFormat:@"%@",self.phoneNumber];
    self.setPasswordTextfield.secureTextEntry = YES;
    self.setPasswordTextfield.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self firstDrawViewLayout];
   
    
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
        NSLog(@"横屏");
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
    if (self.setPasswordTextfield.text.length==0) {
        self.infoLabel.alpha = 1;
        self.infoLabel.frame = CGRectMake(16, 160, self.bounds.size.width-36, 14);
    }
    else{
        self.infoLabel.alpha = 0;
    }

}

-(void)horizontalUI{
    if (self.setPasswordTextfield.text.length==0) {

        self.infoLabel.alpha = 1;
        self.infoLabel.frame = CGRectMake(16, 160, self.bounds.size.width-36, 14);
    }
    else{

        self.infoLabel.alpha = 0;
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

-(void)firstDrawViewLayout{
    //初始布局
    self.firstLabel.alpha = 0;
    self.typeLabel.alpha = 0;
    self.rightLabel.alpha = 0;
    self.view1.alpha = 0;
    self.view2.alpha = 0;
    self.view3.alpha = 0;
    self.view4.alpha = 0;
    self.view5.alpha = 0;
    self.view6.alpha = 0;
    self.infoLabel.alpha = 1;
    self.infoLabel.frame = CGRectMake(16, 160, self.bounds.size.width-36, 14);
}

-(void)secondDrawViewLayout{
    self.firstLabel.alpha = 1;
    self.typeLabel.alpha = 1;
    self.rightLabel.alpha = 1;
    self.view1.alpha = 1;
    self.view2.alpha = 1;
    self.view3.alpha = 1;
    self.view4.alpha = 1;
    self.view5.alpha = 1;
    self.view6.alpha = 1;
    self.infoLabel.alpha = 0;
    
    self.typeLabel.text = @"弱";
    self.view1.backgroundColor = [UIColor colorWithRed:0.604 green:0.663 blue:0.702 alpha:7.0];
    self.view2.backgroundColor = [UIColor colorWithRed:0.604 green:0.663 blue:0.702 alpha:7.0];
    self.view3.backgroundColor = [UIColor colorWithRed:0.604 green:0.663 blue:0.702 alpha:7.0];
    self.view4.backgroundColor = [UIColor colorWithRed:0.604 green:0.663 blue:0.702 alpha:7.0];
    self.view5.backgroundColor = [UIColor colorWithRed:0.604 green:0.663 blue:0.702 alpha:7.0];
    self.view6.backgroundColor = [UIColor colorWithRed:0.604 green:0.663 blue:0.702 alpha:7.0];

}

//返回按钮
- (IBAction)returnBackMethod:(id)sender {
    if (self.goBackClickedBlock) {
        self.goBackClickedBlock();
    }
}

//关闭页面
- (IBAction)closeViewMethod:(id)sender {
    if (self.closeViewBlock) {
        self.closeViewBlock();
    }
}

//是否看到密码
- (IBAction)weatherSeeMethod:(UIButton *)sender {
    
    if (sender.selected == NO) {
        self.setPasswordTextfield.secureTextEntry = NO;
        NSString * imgPath = [[OrangeGreenFruitBundle mainBundle]pathForResource:@"Orange闭眼睛_2" ofType:@"png"];
        [sender setBackgroundImage:[UIImage imageWithData:[NSData dataWithContentsOfFile:imgPath]] forState:UIControlStateNormal];
        sender.selected = YES;
    }
    else{
        self.setPasswordTextfield.secureTextEntry = YES;
        NSString * imgPath = [[OrangeGreenFruitBundle mainBundle]pathForResource:@"Orange闭眼睛_2.0" ofType:@"png"];
        [sender setBackgroundImage:[UIImage imageWithData:[NSData dataWithContentsOfFile:imgPath]] forState:UIControlStateNormal];
        sender.selected = NO;
    }
}

- (IBAction)ensureModifyMethod:(id)sender {
    
    [self endEditing:YES];
    
    if (self.passwordString.length == 0) {
        [OrangeMBManager show_CustomNativeByte_BriefAlert:@"密码不能为空" time:1.0f];
        return;
    }
    if (self.passwordString.length<6) {
        [OrangeMBManager show_CustomNativeByte_BriefAlert:@"密码长度不能少于6位" time:1.0f];
        return;
    }
    if (self.passwordString.length>22) {
        [OrangeMBManager show_CustomNativeByte_BriefAlert:@"密码长度不能超过22位" time:1.0f];
        return;
    }
    
    [OrangeAPIParams requestForModifyPassword:self.passwordString andUserName:self.phoneNumber SuccessBlock:^(id response) {
        NSDictionary * infoDic = (NSDictionary *)response;
        
        NSString * status = [NSString stringWithFormat:@"%@",infoDic[@"code"]];
        if ([status isEqualToString:@"200"]) {
            [OrangeMBManager show_CustomNativeByte_BriefAlert:@"修改成功" time:1.0f];
            
            //修改成功后，跳入登录页面，将信息带过去
            if (self.modifySuccessBlock) {
                self.modifySuccessBlock(self.phoneNumber, self.passwordString);
            }
            
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
    offset = (self.setPasswordTextfield.frame.origin.y+self.setPasswordTextfield.frame.size.height+20) - (kScreenHeight - kbHeight);
    
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

-(void)textfieldContentChangedMethod:(NSNotification *)info{
    NSLog(@"通知方法中的-输入框内容改变了:%@",info.userInfo);
    
    
    UITextField *textfield=[info object];
    
    NSString * contentString;
    contentString = [NSString stringWithFormat:@"%@",textfield.text];
    
    NSLog(@"dadada最新的信息:%@",contentString);
    
    if (contentString.length!=0) {
        //一有文字，则变换UI布局
        self.infoLabel.alpha = 0;
        self.ensureModifyBtn.frame = CGRectMake(16, 230, self.bounds.size.width-36, 40) ;
        [self secondDrawViewLayout];
    }
    else{
        self.infoLabel.alpha = 1;
        self.ensureModifyBtn.frame = CGRectMake(16, 200, self.bounds.size.width-36, 40) ;
        [self firstDrawViewLayout];
    }
    
    if (contentString.length<6) {//密码不到6位，不展示变化
        return;
    }
    
    BOOL weatherNum = NO;
    BOOL weatherSmallLetter = NO;
    BOOL weatherSymbol = NO;
    weatherNum = [self checkStringWeatherContainsNumber:contentString];
    weatherSmallLetter = [self checkStringWeatherContainsSmallLetter:contentString];
    weatherSymbol = [self checkStringWeatherContainsSymbol:contentString];
    
    //弱
    if (weatherNum == YES && weatherSmallLetter == NO && weatherSymbol == NO) {
        self.typeLabel.text = @"弱";
        self.view1.backgroundColor = [UIColor colorWithRed:0.988 green:0.208 blue:0.267 alpha:1.0];
        self.view2.backgroundColor = [UIColor colorWithRed:0.988 green:0.208 blue:0.267 alpha:1.0];
        
    }else if (weatherNum == NO && weatherSmallLetter == YES && weatherSymbol == NO){
        self.typeLabel.text = @"弱";
        
        self.view1.backgroundColor = [UIColor colorWithRed:0.988 green:0.208 blue:0.267 alpha:1.0];
        self.view2.backgroundColor = [UIColor colorWithRed:0.988 green:0.208 blue:0.267 alpha:1.0];
        
    }else if (weatherNum == NO && weatherSmallLetter == NO && weatherSymbol == YES){
        self.typeLabel.text = @"弱";
        
        self.view1.backgroundColor = [UIColor colorWithRed:0.988 green:0.208 blue:0.267 alpha:1.0];
        self.view2.backgroundColor = [UIColor colorWithRed:0.988 green:0.208 blue:0.267 alpha:1.0];
    }
    //中
    else if (weatherNum == YES && weatherSmallLetter == YES && weatherSymbol == NO){
        self.typeLabel.text = @"中";
        self.view1.backgroundColor = [UIColor colorWithRed:1.0 green:0.667 blue:0.204 alpha:1.0];
        self.view2.backgroundColor = [UIColor colorWithRed:1.0 green:0.667 blue:0.204 alpha:1.0];
        self.view3.backgroundColor = [UIColor colorWithRed:1.0 green:0.667 blue:0.204 alpha:1.0];
        self.view4.backgroundColor = [UIColor colorWithRed:1.0 green:0.667 blue:0.204 alpha:1.0];
    }
    else if (weatherNum == YES && weatherSmallLetter == NO && weatherSymbol == YES){
        self.typeLabel.text = @"中";
        self.view1.backgroundColor = [UIColor colorWithRed:1.0 green:0.667 blue:0.204 alpha:1.0];
        self.view2.backgroundColor = [UIColor colorWithRed:1.0 green:0.667 blue:0.204 alpha:1.0];
        self.view3.backgroundColor = [UIColor colorWithRed:1.0 green:0.667 blue:0.204 alpha:1.0];
        self.view4.backgroundColor = [UIColor colorWithRed:1.0 green:0.667 blue:0.204 alpha:1.0];
    }
    else if (weatherNum == NO && weatherSmallLetter == YES && weatherSymbol == YES){
        self.typeLabel.text = @"中";
        self.view1.backgroundColor = [UIColor colorWithRed:1.0 green:0.667 blue:0.204 alpha:1.0];
        self.view2.backgroundColor = [UIColor colorWithRed:1.0 green:0.667 blue:0.204 alpha:1.0];
        self.view3.backgroundColor = [UIColor colorWithRed:1.0 green:0.667 blue:0.204 alpha:1.0];
        self.view4.backgroundColor = [UIColor colorWithRed:1.0 green:0.667 blue:0.204 alpha:1.0];
    }
    //强
    else if (weatherNum == YES && weatherSmallLetter == YES && weatherSymbol == YES){
        self.typeLabel.text = @"强";
        self.view1.backgroundColor = [UIColor colorWithRed:0.537 green:0.741 blue:0.341 alpha:1.0];
        self.view2.backgroundColor = [UIColor colorWithRed:0.537 green:0.741 blue:0.341 alpha:1.0];
        self.view3.backgroundColor = [UIColor colorWithRed:0.537 green:0.741 blue:0.341 alpha:1.0];
        self.view4.backgroundColor = [UIColor colorWithRed:0.537 green:0.741 blue:0.341 alpha:1.0];
        self.view5.backgroundColor = [UIColor colorWithRed:0.537 green:0.741 blue:0.341 alpha:1.0];
        self.view6.backgroundColor = [UIColor colorWithRed:0.537 green:0.741 blue:0.341 alpha:1.0];
    }

}

#pragma mark -- UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField{
    self.passwordString = [NSString stringWithFormat:@"%@",textField.text];
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSLog(@"1输入框的字符改变了 %@",string);
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self endEditing:YES];
    return YES;
}

#pragma mark --- 判断字符串包含信息类型
//1 是否包含数字
- (BOOL)checkStringWeatherContainsNumber:(NSString *)password
{
    //数字条件
    
    NSRegularExpression *NumExpression = [NSRegularExpression regularExpressionWithPattern:@"[0-9]"options:NSRegularExpressionCaseInsensitive error:nil];
    
    
    //符合数字条件的有几个字节
    
    NSUInteger Count = [NumExpression numberOfMatchesInString:password  options:NSMatchingReportProgress range:NSMakeRange(0, password.length)];
    if (Count>0) {
        return YES;
    }else{
        return NO;
    }
}

//是否包含字母
-(BOOL)checkStringWeatherContainsSmallLetter:(NSString*)password{
    
    //英文字条件
    NSRegularExpression *LetterExpression = [NSRegularExpression regularExpressionWithPattern:@"[A-Za-z]" options:NSRegularExpressionCaseInsensitive error:nil];

    //符合英文字条件的有几个字节
    NSUInteger Count = [LetterExpression numberOfMatchesInString:password options:NSMatchingReportProgress range:NSMakeRange(0, password.length)];
    
    if (Count>0) {
        return YES;
    }else{
        return NO;
    }

}


//是否包含字符串
-(BOOL)checkStringWeatherContainsCaracter:(NSString *)password{
    
    //提示标签不能输入特殊字符
    
    NSString *str =@"^[\\u4e00-\u9fa5]+$";
    
    NSPredicate* emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", str];
    
    if ([emailTest evaluateWithObject:password]) {
        
        return YES;
        
    }
    
    return NO;
}

//特殊符号
- (BOOL)checkStringWeatherContainsSymbol:(NSString *)password{

    if([password rangeOfString:@"@"].location !=NSNotFound){
        return YES;
    }else if ([password rangeOfString:@"."].location !=NSNotFound){
        return YES;
    }else if ([password rangeOfString:@"_"].location !=NSNotFound){
        return YES;
    }else if ([password rangeOfString:@"*"].location !=NSNotFound){
        return YES;
    }else if ([password rangeOfString:@"-"].location !=NSNotFound){
        return YES;
    }else if ([password rangeOfString:@"!"].location !=NSNotFound){
        return YES;
    }else if ([password rangeOfString:@"#"].location !=NSNotFound){
        return YES;
    }else if ([password rangeOfString:@"%"].location !=NSNotFound){
        return YES;
    }else if ([password rangeOfString:@"$"].location !=NSNotFound){
        return YES;
    }else if ([password rangeOfString:@"*"].location !=NSNotFound){
        return YES;
    }else
    {
        NSLog(@"不包含特殊字符");
    }
        
    return NO;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:self.setPasswordTextfield];
}


@end
