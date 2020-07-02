//
//  GreenFruitTouristUserLoginViewBlackCustomControl.h
//  GreenFruitframework
//
//  Created by 张 on 2018/11/27.
//  Copyright © 2018年 Hu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrangeGreenFruit_CustomNativeByte_SDKHelper.h"
#import "OrangeZJAnimationPopView.h"

typedef void(^GreenFruit_CustomNativeByte_SDKLoginCompletionBlock)(GreenFruit_CustomNativeByte_SDKUser *user,NSString *code);
@interface GreenFruitTouristUserLoginViewBlackCustomControl : UIView

@property (nonatomic, strong) OrangeZJAnimationPopView *popView;

@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UIImageView *textBottomView;
@property (weak, nonatomic) IBOutlet UIButton *nextStepMethod;
@property (weak, nonatomic) IBOutlet UITextField *accountTextfield;
@property (weak, nonatomic) IBOutlet UIButton *returnBtn;

@property (nonatomic, copy) void (^goBackClickedBlock)(void);
@property (nonatomic, copy) void (^closeCurrentViewBlock)(void);

@property (nonatomic, copy) void (^nextStepBlock)(GreenFruitTouristUserLoginViewBlackCustomControl *signView, NSString *phoneNumber);


@property (nonatomic, copy) GreenFruit_CustomNativeByte_SDKLoginCompletionBlock completionBlock;

- (IBAction)returnBackMethod:(UIButton *)sender;
- (IBAction)nextStepMethod:(UIButton *)sender;
- (IBAction)returnBtnMethod:(id)sender;

@end
