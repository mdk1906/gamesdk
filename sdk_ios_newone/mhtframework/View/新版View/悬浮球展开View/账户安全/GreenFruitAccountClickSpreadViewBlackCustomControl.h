//
//  GreenFruitAccountClickSpreadViewBlackCustomControl.h
//  GreenFruitframework
//
//  Created by 张 on 2018/12/10.
//  Copyright © 2018年 Hu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrangeZJAnimationPopView.h"
#import "OrangeGreenFruit_CustomNativeByte_SDKHelper.h"

typedef void(^GreenFruit_CustomNativeByte_SDKLoginCompletionBlock)(GreenFruit_CustomNativeByte_SDKUser *user,NSString *code);

@interface GreenFruitAccountClickSpreadViewBlackCustomControl : UIView

@property (nonatomic, copy) GreenFruit_CustomNativeByte_SDKLoginCompletionBlock completionBlock;
@property (nonatomic, strong) OrangeZJAnimationPopView *popView;

@property (nonatomic, copy) void (^goBackClickedBlock)(void);
@property (nonatomic, copy) void (^dismissPopViewBlock)(void);

@property (weak, nonatomic) IBOutlet UIButton *returnBackBtn;
@property (weak, nonatomic) IBOutlet UIButton *identifyNameBtn;
@property (weak, nonatomic) IBOutlet UIButton *bindingPhoneBtn;
@property (weak, nonatomic) IBOutlet UIButton *modifyPsdBtn;
@property (weak, nonatomic) IBOutlet UIImageView *loginImageView;


- (IBAction)returnBackMethod:(id)sender;
- (IBAction)realNameCheckMethod:(id)sender;
- (IBAction)bindingPhoneMethod:(id)sender;
- (IBAction)modifyPsdMethod:(id)sender;

@end
