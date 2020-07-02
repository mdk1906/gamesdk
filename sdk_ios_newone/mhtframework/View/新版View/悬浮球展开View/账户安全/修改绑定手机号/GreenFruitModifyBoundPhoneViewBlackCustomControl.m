//
//  GreenFruitModifyBoundPhoneViewBlackCustomControl.m
//  GreenFruitframework
//
//  Created by 张 on 2018/12/19.
//  Copyright © 2018年 Hu. All rights reserved.
//

#import "GreenFruitModifyBoundPhoneViewBlackCustomControl.h"
#import "OrangeGreenFruitConfig.h"
#import "OrangeUIImageView+MHImageWebCache.h"
#import "OrangeGreenFruitBundle.h"


@interface GreenFruitModifyBoundPhoneViewBlackCustomControl()
@end

@implementation GreenFruitModifyBoundPhoneViewBlackCustomControl


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    [self configView];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeRotate:) name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
}

-(void)configView{
    self.modifyBtn.layer.cornerRadius = 20.0f;
    self.infoLabel.text = [NSString stringWithFormat:@"您绑定的手机号码为:%@",self.phoneStr];
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];

    NSString * publicPath = User_Defaults_Get(@"publicImgPath");
    UIImage * getImage = [UIImage imageWithContentsOfFile:publicPath];
    self.loginImageView.image = getImage;
    
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
        
    } else {
        //横屏
        if(IS_IPHONE){
            NSLog(@"设备为手机");
            [self setWidth:400];
            [self setHeight:320];
            self.center = CGPointMake(self.superview.bounds.size.width/2, self.superview.bounds.size.height/2);
        }else{
            NSLog(@"设备为ipad");
            [self setWidth:400];
            [self setHeight:340];
            self.center = CGPointMake(self.superview.bounds.size.width/2, self.superview.bounds.size.height/2);
        }
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



- (IBAction)closeViewMethod:(id)sender {
    if (self.closeViewBlock){
        self.closeViewBlock();
    }
}

- (IBAction)ensureMethod:(id)sender {
    
    if (self.modifyPhoneBlock) {
        self.modifyPhoneBlock();
    }
}

- (IBAction)returnBtnMethod:(id)sender {
    if (self.gobackClickBlock) {
        self.gobackClickBlock();
    }
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
}


@end
