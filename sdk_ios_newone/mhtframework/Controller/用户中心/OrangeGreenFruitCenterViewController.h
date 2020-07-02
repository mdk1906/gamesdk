//
//  OrangeGreenFruitCenterViewController.h
//  GreenFruit_CustomNativeByte_SDK
//
//  Created by shuangfei on 2018/2/21.
//  Copyright © 2018年 Hu. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <WebKit/WebKit.h>

@interface OrangeGreenFruitCenterViewController : UIViewController

@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *userid;
@property (nonatomic, copy) NSString *cancel;
@property (nonatomic, copy) NSString *name;//实名认证的姓名
@property (nonatomic, copy) NSString *identifyno;//实名认证的身份证号
@property (nonatomic, copy) NSString *giftListModel;
@property (nonatomic, copy) NSString *qqModel;
@property (nonatomic, copy) NSString *kefuModel;
@property (nonatomic, copy) NSString *bindPhoneNumber;
@property (nonatomic, assign) BOOL webviewHaveLoad;
@property (nonatomic, copy) void (^bindPhoneViewBlock)(void);
@property (nonatomic, copy) void (^safetyViewBlock)(void);
@end
