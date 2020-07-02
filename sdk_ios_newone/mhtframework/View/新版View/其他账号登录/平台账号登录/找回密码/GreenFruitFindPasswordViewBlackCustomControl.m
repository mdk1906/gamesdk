//
//  GreenFruitFindPasswordViewBlackCustomControl.m
//  GreenFruitframework
//
//  Created by 张 on 2018/11/30.
//  Copyright © 2018年 Hu. All rights reserved.
//

#import "GreenFruitFindPasswordViewBlackCustomControl.h"
#import "OrangeGreenFruitBundle.h"
#import "OrangeNSString+Utils.h"
#import "OrangeMBManager.h"
#import "OrangeAPIParams.h"
#import "GreenFruitConnectionWithServiceViewBlackCustomControl.h"
#import "GreenFruitConfirmCodeInputViewBlackCustomControl.h"
#import "OrangeGreenFruitConfig.h"
#import "OrangeUIImageView+MHImageWebCache.h"


@interface GreenFruitFindPasswordViewBlackCustomControl()<UITextFieldDelegate>
{
    CGPoint historyPoint;
}
@property (nonatomic,strong)GreenFruitConnectionWithServiceViewBlackCustomControl * connectionView;
@property (nonatomic,strong)GreenFruitConfirmCodeInputViewBlackCustomControl * ConfirCodeView;
@property (nonatomic,retain)NSString * phoneNumber;
@property (nonatomic,retain)NSString * showPhoneStr;
@property (nonatomic,retain)NSString * textfieldName;
@end

@implementation GreenFruitFindPasswordViewBlackCustomControl

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    [self configView];

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeRotate:) name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
    self.backgroundColor = [UIColor whiteColor];
    
    //注册观察键盘的变化
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
}


-(void)configView{
    self.nextStepButton.layer.cornerRadius = 20.0f;
    self.phoneTextfield.delegate = self;
    self.phoneTextfield.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];

    NSString * publicPath = User_Defaults_Get(@"publicImgPath");
    UIImage * getImage = [UIImage imageWithContentsOfFile:publicPath];
    self.loginImageView.image = getImage;
    
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


#pragma mark -- UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    self.phoneNumber = [NSString stringWithFormat:@"%@",textField.text];
    
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
    
    historyPoint = CGPointMake(self.center.x, self.center.y);
    
    //获取键盘高度，在不同设备上，以及中英文下是不同的
    CGFloat kbHeight = [[note.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    
    //计算出键盘顶端到inputTextView panel底端的距离(加上自定义的缓冲距离INTERVAL_KEYBOARD)
    CGFloat offset;
    offset = (self.phoneTextfield.frame.origin.y+self.phoneTextfield.frame.size.height+20) - (kScreenHeight - kbHeight);
   
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
    self.center = historyPoint;
    
    // 键盘动画时间
    double duration = [[note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    //视图下沉恢复原状
    [UIView animateWithDuration:duration animations:^{
        self.center = CGPointMake(kScreenWidth/2, kScreenHeight/2);
    }];
    
}


//返回
- (IBAction)returnBackMethod:(id)sender {
    if (self.closeViewBlock) {
        self.closeViewBlock();
    }
}

//找回密码账号验证
- (IBAction)nextStepMethod:(id)sender {
    
    [self endEditing:YES];
    
    if (self.phoneNumber.length == 0) {
        [OrangeMBManager show_CustomNativeByte_BriefAlert:@"账号信息不能为空" time:1.0f];
        return;
    }

    [OrangeAPIParams requestCheckPhoneCondition:self.phoneNumber SuccessBlock:^(id response) {
        NSDictionary * infoDic = (NSDictionary *)response;
        
        NSString * status = [NSString stringWithFormat:@"%@",infoDic[@"code"]];
        if ([status isEqualToString:@"200"]) {
            
            NSDictionary * tempDic = infoDic[@"content"];
            self.showPhoneStr = [NSString stringWithFormat:@"%@",tempDic[@"phone"]];
            [self jumpToConfirmCodeView];
            
            
        }
        else if ([status isEqualToString:@"514"]){
            
            [OrangeAPIParams requestSettingQQSuccessblock:^(id response) {
                NSDictionary * infoDic = (NSDictionary*)response;
                NSString * statuCode = [NSString stringWithFormat:@"%@",infoDic[@"code"]];
                if ([statuCode isEqualToString:@"200"]) {
                    NSMutableArray * qListArr = [[NSMutableArray alloc]initWithCapacity:0];
                    qListArr = infoDic[@"content"][@"qList"];
                    
                    NSDictionary * tempDic = [[NSDictionary alloc]init];
                    tempDic = qListArr[0];
                    [self jumpToChartView:tempDic];
                    
                }else{
                    [OrangeMBManager show_CustomNativeByte_BriefAlert:@"客服信息获取失败" time:1.0f];
                }
                
            } failedblock:^(NSError *error) {
                if(error.code == 4){
                    [OrangeMBManager show_CustomNativeByte_BriefAlert:@"网络异常" time:1];
                }else{
                    [OrangeMBManager show_CustomNativeByte_BriefAlert:@"异常错误" time:1];
                }
            }];
        }
        else{//code 516
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

//返回
- (IBAction)returnMethod:(id)sender {
    if (self.goBackBlock) {
        self.goBackBlock();
    }
}

-(void)jumpToChartView:(NSDictionary *)serviceInfoDic{
    
    if (self.goToQQServiceBlock) {
        self.goToQQServiceBlock(self.phoneNumber, serviceInfoDic);
    }
}

-(void)jumpToConfirmCodeView{
    
    if (self.checkSuccessBlock) {
        self.checkSuccessBlock(self.showPhoneStr, self.phoneNumber);
    }
}

#pragma mark --- SDK页面跳转封装方法
- (void)handleCustom_CustomNativeByte_ActionEnvent:(OrangeZJAnimationPopView *)popView customerView:(UIView*)customerView{
    
    if ([customerView isKindOfClass:[GreenFruitConnectionWithServiceViewBlackCustomControl class]]) {
        GreenFruitConnectionWithServiceViewBlackCustomControl * connectionView = (GreenFruitConnectionWithServiceViewBlackCustomControl *)customerView;
        connectionView.goBackClickedBlock = ^{
            [popView dismiss];
        };
    }
    else if ([customerView isKindOfClass:[GreenFruitConfirmCodeInputViewBlackCustomControl class]]){
        GreenFruitConfirmCodeInputViewBlackCustomControl * confirmCodeView = (GreenFruitConfirmCodeInputViewBlackCustomControl *)customerView;
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
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

@end
