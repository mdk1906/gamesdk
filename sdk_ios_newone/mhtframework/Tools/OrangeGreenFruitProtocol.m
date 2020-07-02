//
//  OrangeGreenFruitProtocol.m
//  GreenFruitframework
//
//  Created by 张 on 2018/8/13.
//  Copyright © 2018年 Hu. All rights reserved.
//

#import "OrangeGreenFruitProtocol.h"
#import "OrangeUIView+FrameMethods.h"
#import "OrangeGreenFruitConfig.h"
@implementation OrangeGreenFruitProtocol

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */
- (void)layoutSubviews{
    if(([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait) || ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown)){
        //竖屏
        //        self.frame = CGRectMake(self.originX, self.originY, 300, 400);
        [self setWidth:kScreenWidth];
        [self setHeight:kScreenHeight];
        self.center = CGPointMake(self.superview.bounds.size.width/2, self.superview.bounds.size.height/2);
        [self setNeedsLayout];
    }else{
        //横屏
//        if(IS_IPHONE){
            [self setNeedsLayout];
            //        self.frame = CGRectMake(self.originX, self.originY, 400, 300);
            [self setWidth:kScreenWidth];
            [self setHeight:kScreenHeight];
            self.center = CGPointMake(self.superview.bounds.size.width/2, self.superview.bounds.size.height/2);
//        }else{
//            //        self.frame = CGRectMake(self.originX, self.originY, 300, 400);
//            [self setWidth:300];
//            [self setHeight:440];
//            self.center = CGPointMake(self.superview.bounds.size.width/2, self.superview.bounds.size.height/2);
//            [self setNeedsLayout];
//        }
    }
}

- (IBAction)goBack:(id)sender {
    NSLog(@"GreenFruit Protocol goBack");
    if(self.goBackClickedBlock){
        self.goBackClickedBlock();
    }
}

@end
