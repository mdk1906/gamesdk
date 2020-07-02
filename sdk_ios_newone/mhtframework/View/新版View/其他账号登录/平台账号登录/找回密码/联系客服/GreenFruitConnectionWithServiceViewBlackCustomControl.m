//
//  GreenFruitConnectionWithServiceViewBlackCustomControl.m
//  GreenFruitframework
//
//  Created by 张 on 2018/12/5.
//  Copyright © 2018年 Hu. All rights reserved.
//

#import "GreenFruitConnectionWithServiceViewBlackCustomControl.h"
#import "OrangeMBManager.h"
#import "OrangeGreenFruitConfig.h"
#import "OrangeUIImageView+MHImageWebCache.h"
#import "OrangeGreenFruitBundle.h"

@interface GreenFruitConnectionWithServiceViewBlackCustomControl ()
@property (nonatomic,retain)NSString * value;
@property (nonatomic,retain)NSString * name;
@end
@implementation GreenFruitConnectionWithServiceViewBlackCustomControl

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    [self initData];
    
    [self configView];
        
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeRotate:) name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
  
}

-(void)initData{
    self.name = [NSString stringWithFormat:@"%@",self.serverceDic[@"name"]];
    self.value = [NSString stringWithFormat:@"%@",self.serverceDic[@"value"]];
}

-(void)configView{
    self.contentLabel.text = [NSString stringWithFormat:@"账号%@未绑定手机，您可以联系人工客服找回密码",self.userName];
    NSString * titleString = [NSString stringWithFormat:@"%@:%@",self.name,self.value];
    [self.contactBtn setTitle:titleString forState:UIControlStateNormal];
    
    self.contactBtn.layer.cornerRadius = 20.0f;
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



//返回
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

//联系方法
- (IBAction)getInTouchMethod:(id)sender {
    NSString * urlString = [NSString stringWithFormat:@"mqq://im/chat?chat_type=wpa&uin=%@&version=1&src_type=web",self.value];
    NSURL *qqURL = [NSURL URLWithString:urlString];

    [[UIApplication sharedApplication] openURL:qqURL];
    
    
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
}


@end
