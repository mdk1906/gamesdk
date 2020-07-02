//
//  OrangeUIButton+CountDown.h
//  GreenFruit_CustomNativeByte_SDK
//
//  Created by shuangfei on 2018/2/12.
//  Copyright © 2018年 Hu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CountDoneBlock)(UIButton *button);
@interface UIButton (CountDown)

@property(nonatomic, copy)CountDoneBlock countDoneBlock;
- (void)countDownWithTime:(NSInteger)timeLine withTitle:(NSString *)title andCountDownTitle:(NSString *)subTitle countDoneBlock:(CountDoneBlock)countDoneBlock isInteraction:(BOOL)isInteraction;

@end
