//
//  XMPayCodeViewBlackCustomControl.m
//  XMScreenLockDemo
//
//  Created by sfk-ios on 2018/5/9.
//  Copyright © 2018年 sfk-JasonSu. All rights reserved.
//

#import "XMPayCodeViewBlackCustomControl.h"
#import "XMTextFieldBlackCustomControl.h"
#import "OrangeUIImageView+MHImageWebCache.h"
#import "OrangeGreenFruitBundle.h"
#import "OrangeGreenFruitConfig.h"

@interface XMPayCodeViewBlackCustomControl()<XMTextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *bgContentView;
@property (weak, nonatomic) IBOutlet XMTextFieldBlackCustomControl *num1F;
@property (weak, nonatomic) IBOutlet XMTextFieldBlackCustomControl *num2F;
@property (weak, nonatomic) IBOutlet XMTextFieldBlackCustomControl *num3F;
@property (weak, nonatomic) IBOutlet XMTextFieldBlackCustomControl *num4F;
@property (weak, nonatomic) IBOutlet XMTextFieldBlackCustomControl *num5F;
@property (weak, nonatomic) IBOutlet XMTextFieldBlackCustomControl *num6F;
/// 用于保持键盘不退下的textField
@property (weak, nonatomic) XMTextFieldBlackCustomControl *holdOnF;

@end

@implementation XMPayCodeViewBlackCustomControl

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil]lastObject];
        self.frame = CGRectMake(0, frame.origin.y, [UIScreen mainScreen].bounds.size.width, frame.size.height);
        _bgContentView.layer.cornerRadius = 4;
        _bgContentView.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
        _bgContentView.layer.borderWidth = 1;
        
        XMTextFieldBlackCustomControl *holdOnF = [[XMTextFieldBlackCustomControl alloc]initWithFrame:CGRectZero];
        holdOnF.keyboardType = UIKeyboardTypeNumberPad;
        holdOnF.xmDelegate = self;
        [self addSubview:holdOnF];
        _holdOnF = holdOnF;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
    NSLog(@"进入验证码界面的重绘方法");
    
    _bgContentView.layer.cornerRadius = 4;
    _bgContentView.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    _bgContentView.layer.borderWidth = 1;
    
    XMTextFieldBlackCustomControl *holdOnF = [[XMTextFieldBlackCustomControl alloc]initWithFrame:CGRectZero];
    holdOnF.keyboardType = UIKeyboardTypeNumberPad;
    holdOnF.xmDelegate = self;
    [self addSubview:holdOnF];
    _holdOnF = holdOnF;
    
    self.reactionBtn.userInteractionEnabled = YES;
    
    NSString * publicPath = User_Defaults_Get(@"publicImgPath");
    UIImage * getImage = [UIImage imageWithContentsOfFile:publicPath];
    self.logoImageView.image = getImage;
    
    // 1秒后，让密码输入成为第一响应
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self becomeKeyBoardFirstResponder];
    });
    
}

+ (instancetype)payCodeView
{
    XMPayCodeViewBlackCustomControl *payCodeView = [[XMPayCodeViewBlackCustomControl alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 65)];
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
    _num5F.xmDelegate = self;
    [_num5F addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    _num6F.xmDelegate = self;
    [_num6F addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
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
        case 4:
            [_num5F becomeFirstResponder];break;
        case 5:
            [_num6F becomeFirstResponder];break;
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
        }else if ([textField isEqual:_num5F] ) {
            [self setFirstResponderForIndex:3];
            _num4F.text = nil;
        }else if ([textField isEqual:_num6F]){
//            ***
            [self setFirstResponderForIndex:4];
            _num5F.text = nil;
           
            
        }else if ([textField isEqual:_holdOnF]){
            _holdOnF.text = nil;
            _num6F.text = nil;
            [self setFirstResponderForIndex:5];
            NSLog(@"333");

        }
    }
    
    if (self.endEditingOnFinished) return;
    // 收集支付密码
    [self collectPayCode];
    
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
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
    }else if ([textField isEqual:_num4F] ) {
        [self setFirstResponderForIndex:4];
    }else if ([textField isEqual:_num5F] ) {
        [self setFirstResponderForIndex:5];
    }else if ([textField isEqual:_num6F]){
        
        if (self.endEditingOnFinished) { // 是否退下键盘
            [_num6F resignFirstResponder];
        }else{
            [_holdOnF becomeFirstResponder];
        }
        
        if (_payBlock) {
            _payBlock(_payCode);
        }
    }
}

/// 收集支付密码
- (void)collectPayCode
{
    NSString *payCode = _num1F.text;
    payCode = [payCode stringByAppendingString:_num2F.text];
    payCode = [payCode stringByAppendingString:_num3F.text];
    payCode = [payCode stringByAppendingString:_num4F.text];
    payCode = [payCode stringByAppendingString:_num5F.text];
    payCode = [payCode stringByAppendingString:_num6F.text];
    
//    NSLog(@"收集支付密码payCode==%@",payCode);
    _payCode = payCode;
    
    if (self.endEditingOnFinished) return;
    if (_payBlock) {
        _payBlock(_payCode);
    }
}

- (IBAction)reactionBtnMethod:(UIButton *)sender {
    
    NSLog(@"是否执行");
//    if ([_holdOnF isEqual:_num1F]) {
//        [self setFirstResponderForIndex:1];
//    }else if ([_holdOnF isEqual:_num2F] ) {
//        [self setFirstResponderForIndex:2];
//    }else if ([_holdOnF isEqual:_num3F] ) {
//        [self setFirstResponderForIndex:3];
//    }else if ([_holdOnF isEqual:_num4F] ) {
//        [self setFirstResponderForIndex:4];
//    }else if ([_holdOnF isEqual:_num5F] ) {
//        [self setFirstResponderForIndex:5];
//    }else if ([_holdOnF isEqual:_num6F]){
//
//    }
    
    if (_num1F.text.length==0) {
        [self setFirstResponderForIndex:0];
    }else if (_num2F.text.length == 0){
        [self setFirstResponderForIndex:1];
    }else if (_num3F.text.length == 0){
        [self setFirstResponderForIndex:2];
    }else if (_num4F.text.length == 0){
        [self setFirstResponderForIndex:3];
    }else if (_num5F.text.length == 0){
        [self setFirstResponderForIndex:4];
    }else if (_num6F.text.length == 0){
        [self setFirstResponderForIndex:5];
    }
    else{
        NSLog(@"不弹出键盘了，此时应该执行跳转了");
    }
}

- (IBAction)returnBackMethod:(id)sender {
    if (self.goBackClickedBlock) {
        self.goBackClickedBlock();
    }
}

- (IBAction)closeMethod:(id)sender {
    if (self.goBackClickedBlock) {
        self.goBackClickedBlock();
    }
}
@end
