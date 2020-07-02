//
//  GreenFruitSystemAccountLoginBlackCustomControl.h
//  GreenFruitframework
//
//  Created by 张 on 2018/11/30.
//  Copyright © 2018年 Hu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrangeZJAnimationPopView.h"
#import "OrangeGreenFruit_CustomNativeByte_SDKHelper.h"

typedef void(^GreenFruit_CustomNativeByte_SDKLoginCompletionBlock)(GreenFruit_CustomNativeByte_SDKUser *user,NSString *code);

@interface GreenFruitSystemAccountLoginBlackCustomControl : UIView

@property (nonatomic, copy) GreenFruit_CustomNativeByte_SDKLoginCompletionBlock completionBlock;

@property (nonatomic, strong) OrangeZJAnimationPopView *popView;
@property (weak, nonatomic) IBOutlet UIView *backLayerView;
@property (weak, nonatomic) IBOutlet UIButton *returnBtn;
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
@property (weak, nonatomic) IBOutlet UITextField *systemAccounyTextfield;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextfield;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *weatherSeePsdBtn;

@property (nonatomic,retain)NSString * jumpViewType;//跳转过来的页面
@property (nonatomic,retain)NSString * accountStr;//传递过来的账号
@property (nonatomic,retain)NSString * passwordStr;//传递过来的密码

@property (nonatomic, copy) void (^goBackClickedBlock)(void);
@property (nonatomic, copy) void (^secondGobackClickedBlock)(void);

@property (nonatomic, copy) void (^closeViewBlock)(void);
@property (nonatomic, copy) void (^loginSuccessBlock)(GreenFruit_CustomNativeByte_SDKLoginCompletionBlock completionBlock);

@property (nonatomic, copy) void (^forgetPasswordBlock)(GreenFruitSystemAccountLoginBlackCustomControl *signView);
@property (nonatomic, copy) void (^regisAccountBlock)(GreenFruitSystemAccountLoginBlackCustomControl *signView);


- (IBAction)loginMethod:(id)sender;
- (IBAction)returnBackMethod:(id)sender;
- (IBAction)closeViewMethod:(id)sender;
- (IBAction)forgetPasswordMethod:(id)sender;
- (IBAction)registAccountMethod:(id)sender;
- (IBAction)weatherSeePsdMethod:(UIButton *)sender;

@end
