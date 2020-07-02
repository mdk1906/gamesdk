//
//  GreenFruitUserProtochlViewBlackCustomControl.m
//  GreenFruitframework
//
//  Created by 张 on 2018/12/5.
//  Copyright © 2018年 Hu. All rights reserved.
//

#import "GreenFruitUserProtochlViewBlackCustomControl.h"
#import "OrangeGreenFruitConfig.h"

@implementation GreenFruitUserProtochlViewBlackCustomControl


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    [self configView];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeRotate:) name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
    self.backgroundColor = [UIColor whiteColor];
}

-(void)configView{
    
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (orientation == UIInterfaceOrientationPortrait
        || orientation == UIInterfaceOrientationPortraitUpsideDown){
        [self setWidth:kScreenWidth];
        [self setHeight:kScreenHeight];
        self.center = CGPointMake(self.superview.bounds.size.width/2, self.superview.bounds.size.height/2);
    }
    else{
        if(IS_IPHONE){
            [self setWidth:kScreenWidth];
            [self setHeight:kScreenHeight];
            self.center = CGPointMake(self.superview.bounds.size.width/2, self.superview.bounds.size.height/2);
        }else{
            [self setWidth:kScreenWidth];
            [self setHeight:kScreenHeight];
            self.center = CGPointMake(self.superview.bounds.size.width/2, self.superview.bounds.size.height/2);
        }
    }
    
    self.protochlWebView.scalesPageToFit = YES;
    
    NSString * urlString = @"http://api.17173g.cn/sdk-center/protocol/index.html";
    
    NSURL* url = [NSURL URLWithString:urlString];//创建URL
    NSURLRequest* request = [NSURLRequest requestWithURL:url];//创建NSURLRequest  
    [self.protochlWebView loadRequest:request];//加
    
    [self addSubview:self.protochlWebView];
    
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
        [self setWidth:kScreenWidth];
        [self setHeight:kScreenHeight];
        self.center = CGPointMake(self.superview.bounds.size.width/2, self.superview.bounds.size.height/2);
        [self verticalUI];
        
    } else {
        //横屏
        if(IS_IPHONE){
            [self setWidth:kScreenWidth];
            [self setHeight:kScreenHeight];
            self.center = CGPointMake(self.superview.bounds.size.width/2, self.superview.bounds.size.height/2);
            [self horizontalUI];
            
        }else{
            [self setWidth:kScreenWidth];
            [self setHeight:kScreenHeight];
            
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
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
  
}


@end
