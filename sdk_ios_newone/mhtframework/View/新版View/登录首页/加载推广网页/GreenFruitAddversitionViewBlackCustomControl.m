//
//  GreenFruitAddversitionViewBlackCustomControl.m
//  GreenFruitframework
//
//  Created by 张 on 2018/11/29.
//  Copyright © 2018年 Hu. All rights reserved.
//

#import "GreenFruitAddversitionViewBlackCustomControl.h"
#import "OrangeGreenFruitConfig.h"

@interface GreenFruitAddversitionViewBlackCustomControl ()
@property (nonatomic,assign)BOOL isCreated;
@end

@implementation GreenFruitAddversitionViewBlackCustomControl

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)drawRect:(CGRect)rect {
    
    [self configView];
    
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeRotate:) name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
}

- (void)changeRotate:(NSNotification*)notification{

    [self configView];
    
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
        self.returnBackBtn.frame = CGRectMake(16, 25, 40, 25);
        self.webView.frame = CGRectMake(0, 64, kScreenWidth, kScreenHeight-64);
        
    } else {
        //横屏
        if(IS_IPHONE){
            [self setWidth:kScreenWidth];
            [self setHeight:kScreenHeight];
            self.center = CGPointMake(self.superview.bounds.size.width/2, self.superview.bounds.size.height/2);
            self.returnBackBtn.frame = CGRectMake(16, 25, 40, 25);
            self.webView.frame = CGRectMake(0, 64, kScreenWidth, kScreenHeight-64);

        }else{
            [self setWidth:kScreenWidth];
            [self setHeight:kScreenHeight];
            self.center = CGPointMake(self.superview.bounds.size.width/2, self.superview.bounds.size.height/2);
            self.returnBackBtn.frame = CGRectMake(16, 25, 40, 25);
            self.webView.frame = CGRectMake(0, 64, kScreenWidth, kScreenHeight-64);
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


-(void)configView{
    
    if (self.isCreated == NO) {
        
        self.isCreated = YES;
        
        self.webView.scalesPageToFit = YES;
        
        NSURL* url = [NSURL URLWithString:self.webUrlString];//创建URL
        NSURLRequest* request = [NSURLRequest requestWithURL:url];//创建NSURLRequest  

        [self.webView loadRequest:request];//加
        [self addSubview:self.webView];
        
        UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
        if (orientation == UIInterfaceOrientationPortrait
            || orientation == UIInterfaceOrientationPortraitUpsideDown){
            [self setWidth:kScreenWidth];
            [self setHeight:kScreenHeight];
            
            self.center = CGPointMake(self.superview.bounds.size.width/2, self.superview.bounds.size.height/2);
            self.returnBackBtn.frame = CGRectMake(16, 25, 40, 25);
            self.webView.frame = CGRectMake(0, 64, kScreenWidth, kScreenHeight-64);
        }
        else{

            [self setWidth:kScreenWidth];
            [self setHeight:kScreenHeight];
            self.center = CGPointMake(self.superview.bounds.size.width/2, self.superview.bounds.size.height/2);
            self.returnBackBtn.frame = CGRectMake(16, 25, 40, 25);
            self.webView.frame = CGRectMake(0, 64, kScreenWidth, kScreenHeight-64);
        }
      
    }
  
}

- (IBAction)returnBackMethod:(UIButton *)sender {
    
    if (self.goBackClickedBlock) {
        self.goBackClickedBlock();
    }
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
}


@end
