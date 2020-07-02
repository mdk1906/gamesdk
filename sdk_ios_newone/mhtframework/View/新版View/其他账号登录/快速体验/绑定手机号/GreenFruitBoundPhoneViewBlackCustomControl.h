//
//  GreenFruitBoundPhoneViewBlackCustomControl.h
//  GreenFruitframework
//
//  Created by 张 on 2018/12/3.
//  Copyright © 2018年 Hu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrangeGreenFruit_CustomNativeByte_SDKHelper.h"
#import "OrangeRespondModel.h"

typedef void(^GreenFruit_CustomNativeByte_SDKLoginCompletionBlock)(GreenFruit_CustomNativeByte_SDKUser *user,NSString *code);

@interface GreenFruitBoundPhoneViewBlackCustomControl : UIView

@property (weak, nonatomic) IBOutlet UIButton *returnBackBtn;

@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;

@property (weak, nonatomic) IBOutlet UIImageView *phoneBackImageView;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextfield;
@property (weak, nonatomic) IBOutlet UIImageView *confirmBackImageView;
@property (weak, nonatomic) IBOutlet UITextField *confirmCodeTextfield;
@property (weak, nonatomic) IBOutlet UIButton *getCodeBtn;
@property (weak, nonatomic) IBOutlet UIButton *ensureBtn;
@property (weak, nonatomic) IBOutlet UIButton *jumpViewBtn;
@property (nonatomic, retain) NSString * jumpViewType;


@property (nonatomic,strong)GreenFruit_CustomNativeByte_SDKUser * userInfo;//存储接口返回的用户信息
@property (nonatomic,strong)OrangeRespondModel * infoModel;//存储接口返回的数据模型
@property (nonatomic,copy)NSMutableDictionary *loginDics;
@property (nonatomic,retain)NSString * componentType;//是否跳转实名验证的状态


@property (nonatomic, copy) void (^joinGameBtnBlock)(GreenFruitBoundPhoneViewBlackCustomControl *signView, UIButton *button);
@property (nonatomic, copy) GreenFruit_CustomNativeByte_SDKLoginCompletionBlock completionBlock;
@property (nonatomic, copy) void (^goBackClickBlock)(void);
@property (nonatomic, copy) void (^comebackToSDKBlock)(void);
@property (nonatomic, copy) void (^closeViewBlock)(void);
@property (nonatomic, copy) void (^boundSuccessBlock)(void);
@property (nonatomic, copy) void (^jumpToIdentifyCheckViewBlock)(void);
@property (nonatomic, copy) void (^accountSecureDismissBlock)(void);
@property (nonatomic, copy) void (^AccountViewGobackBlock)(void);

- (IBAction)returnBackMethod:(id)sender;
- (IBAction)getcodeMethod:(UIButton *)sender;
- (IBAction)ensureSubmitMethod:(id)sender;
- (IBAction)jumpViewMethod:(UIButton *)sender;

@end
