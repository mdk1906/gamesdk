//
//  GreenFruitRegistionViewBlackCustomControl.h
//  GreenFruitframework
//
//  Created by 张 on 2018/11/30.
//  Copyright © 2018年 Hu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrangeZJAnimationPopView.h"
#import "OrangeGreenFruit_CustomNativeByte_SDKHelper.h"

typedef void(^GreenFruit_CustomNativeByte_SDKLoginCompletionBlock)(GreenFruit_CustomNativeByte_SDKUser *user,NSString *code);

@interface GreenFruitRegistionViewBlackCustomControl : UIView

@property (nonatomic, copy) GreenFruit_CustomNativeByte_SDKLoginCompletionBlock completionBlock;
@property (nonatomic, strong) OrangeZJAnimationPopView *popView;
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UIButton *returnBackBtn;
@property (weak, nonatomic) IBOutlet UITextField *setAccountTextfield;
@property (weak, nonatomic) IBOutlet UITextField *setPasswordTextfield;
@property (weak, nonatomic) IBOutlet UIButton *weatherSeePsdBtn;

@property (weak, nonatomic) IBOutlet UIButton *registionBtn;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (weak, nonatomic) IBOutlet UILabel *readlabel;
@property (weak, nonatomic) IBOutlet UIButton *userProtocolBtn;
@property (weak, nonatomic) IBOutlet UIButton *returnBtn;

@property (nonatomic, copy) void (^goBackClickedBlock)(void);
@property (nonatomic, copy) void (^closeViewBlock)(void);

@property (nonatomic, copy) void (^registSuccessBlock)(GreenFruitRegistionViewBlackCustomControl * registionView,GreenFruit_CustomNativeByte_SDKLoginCompletionBlock completionBlock,NSString * component);


- (IBAction)returnMethod:(id)sender;
- (IBAction)selectBtnMethod:(UIButton *)sender;
- (IBAction)returnBackMethod:(id)sender;
- (IBAction)registionMethod:(id)sender;
- (IBAction)protocolMethod:(id)sender;
- (IBAction)weatherSeePsdMethod:(UIButton *)sender;

@end
