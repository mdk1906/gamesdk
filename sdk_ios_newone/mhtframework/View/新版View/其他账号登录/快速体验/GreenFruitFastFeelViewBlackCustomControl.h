//
//  GreenFruitFastFeelViewBlackCustomControl.h
//  GreenFruitframework
//
//  Created by 张 on 2018/12/3.
//  Copyright © 2018年 Hu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrangeZJAnimationPopView.h"
#import "OrangeGreenFruit_CustomNativeByte_SDKHelper.h"
#import "OrangeRespondModel.h"

typedef void(^GreenFruit_CustomNativeByte_SDKLoginCompletionBlock)(GreenFruit_CustomNativeByte_SDKUser *user,NSString *code);

@interface GreenFruitFastFeelViewBlackCustomControl : UIView

@property (nonatomic, strong) OrangeZJAnimationPopView *popView;

@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UIButton *returnBackBtn;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;

@property (weak, nonatomic) IBOutlet UITextField *accountTextfield;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextfield;
@property (weak, nonatomic) IBOutlet UIButton *ensureBtn;
@property (weak, nonatomic) IBOutlet UIImageView *accountBackImgView;
@property (weak, nonatomic) IBOutlet UIImageView *passwordBackImgView;

@property (nonatomic, copy) void (^goBackClickedBlock)(void);

@property (nonatomic, copy) void (^joinGameBtnBlock)(GreenFruitFastFeelViewBlackCustomControl *signView, UIButton *button);
@property (nonatomic, copy) void (^JumptoBoundPhoneBlock)(GreenFruitFastFeelViewBlackCustomControl *signView, NSMutableDictionary*dic,OrangeRespondModel *model,GreenFruit_CustomNativeByte_SDKUser * user,NSString * componentType);

@property (nonatomic, copy) void (^returnTheCompletionBlock)(GreenFruit_CustomNativeByte_SDKLoginCompletionBlock completionBlock);

@property (nonatomic, copy) GreenFruit_CustomNativeByte_SDKLoginCompletionBlock completionBlock;


- (IBAction)returnBackMethod:(id)sender;
- (IBAction)ensureMethod:(id)sender;

- (void)getAccountInfo;

@end
