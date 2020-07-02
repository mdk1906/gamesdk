//
//  GreenFruitNewAotuLoginViewBlackCustomControl.h
//  GreenFruitframework
//
//  Created by 张 on 2018/12/19.
//  Copyright © 2018年 Hu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrangeGreenFruit_CustomNativeByte_SDKHelper.h"

typedef void(^GreenFruit_CustomNativeByte_SDKLoginCompletionBlock)(GreenFruit_CustomNativeByte_SDKUser *user,NSString *code);
@interface GreenFruitNewAotuLoginViewBlackCustomControl : UIView

@property (weak, nonatomic) IBOutlet UIButton *changeLoginBtn;
@property (weak, nonatomic) IBOutlet UILabel *accountLabel;


@property (nonatomic, copy) void (^autoLoginBlock)(GreenFruitNewAotuLoginViewBlackCustomControl *signView);
@property (nonatomic, copy) void (^changeLoginBlock)(GreenFruitNewAotuLoginViewBlackCustomControl *signView,UIButton *button);
@property (nonatomic, copy) GreenFruit_CustomNativeByte_SDKLoginCompletionBlock completionBlock;
@property (nonatomic, copy) void (^autoLoginFailure)(void);

-(void)createBorder;
- (void)autoLoginReuest:(GreenFruit_CustomNativeByte_SDKLoginCompletionBlock)completionBlock;


- (IBAction)changeLoginBtnClick:(UIButton *)sender;

@end
