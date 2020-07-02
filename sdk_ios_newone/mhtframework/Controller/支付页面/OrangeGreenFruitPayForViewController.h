//
//  OrangeGreenFruitPayForViewController.h
//  GreenFruit_CustomNativeByte_SDK
//
//  Created by shuangfei on 2018/2/16.
//  Copyright © 2018年 Hu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "OrangeGreenFruit_CustomNativeByte_SDKHelper.h"
#import <JavaScriptCore/JavaScriptCore.h>

@protocol JSIneract <JSExport>

- (void)goBackGame;

@end


@interface OrangeGreenFruitPayForViewController : UIViewController
@property (strong, nonatomic) GreenFruit_CustomNativeByte_SDKPay *payInfo;

@end
