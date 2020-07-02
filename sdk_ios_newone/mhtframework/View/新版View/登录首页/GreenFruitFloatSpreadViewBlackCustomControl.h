//
//  GreenFruitFloatSpreadViewBlackCustomControl.h
//  GreenFruitframework
//
//  Created by 张 on 2018/11/22.
//  Copyright © 2018年 Hu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrangeZJAnimationPopView.h"
#import "OrangeGreenFruit_CustomNativeByte_SDKHelper.h"

typedef void(^GreenFruit_CustomNativeByte_SDKLoginCompletionBlock)(GreenFruit_CustomNativeByte_SDKUser *user,NSString *code);

@interface GreenFruitFloatSpreadViewBlackCustomControl : UIView

@property (nonatomic, copy) GreenFruit_CustomNativeByte_SDKLoginCompletionBlock completionBlock;
@property (nonatomic, strong) OrangeZJAnimationPopView *popView;

@property (nonatomic, copy) void (^goBackClickedBlock)(void);
@property (nonatomic, copy) void (^touristLoginBlock)(GreenFruitFloatSpreadViewBlackCustomControl *signView,UIButton *button);
@property (nonatomic, copy) void (^loginSuccessBlock)(void);
@property (nonatomic, copy) void (^otherWayLoginBlock)(GreenFruitFloatSpreadViewBlackCustomControl *signView,UIButton *button);
@property (nonatomic, copy) void (^cacheCleanSuccessBlock)(void);

@property (weak, nonatomic) IBOutlet UIImageView *backImageView;
@property (weak, nonatomic) IBOutlet UIButton *returnBtn;
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UIImageView *textBottomImageView;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextfield;
@property (weak, nonatomic) IBOutlet UIButton *pullDownBtn;
@property (weak, nonatomic) IBOutlet UIImageView *loginTypeImageview;

@property (weak, nonatomic) IBOutlet UIButton *nextStepButton;
@property (weak, nonatomic) IBOutlet UIButton *otherWayLoginBtn;


- (IBAction)returnBackMethod:(UIButton *)sender;
- (IBAction)nextStepMethod:(UIButton *)sender;
- (IBAction)otherWayLoginMethod:(UIButton *)sender;


+(GreenFruitFloatSpreadViewBlackCustomControl *)getSpreadView;

@end
