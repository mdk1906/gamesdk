//
//  OrangeGreenFruitUserCenterNewViewController.h
//  GreenFruitframework
//
//  Created by 张 on 2018/12/10.
//  Copyright © 2018年 Hu. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <WebKit/WebKit.h>


@interface OrangeGreenFruitUserCenterNewViewController : UIViewController
@property (nonatomic,retain)NSString * webViewUrl;
@property (nonatomic,copy) void (^notificationBlock)(void);
@end
