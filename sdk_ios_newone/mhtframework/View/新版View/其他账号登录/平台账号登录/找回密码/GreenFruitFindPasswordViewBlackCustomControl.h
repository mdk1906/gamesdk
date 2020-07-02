//
//  GreenFruitFindPasswordViewBlackCustomControl.h
//  GreenFruitframework
//
//  Created by 张 on 2018/11/30.
//  Copyright © 2018年 Hu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrangeZJAnimationPopView.h"


@interface GreenFruitFindPasswordViewBlackCustomControl : UIView

@property (nonatomic, strong) OrangeZJAnimationPopView *popView;

@property (weak, nonatomic) IBOutlet UIImageView *loginImageView;
@property (weak, nonatomic) IBOutlet UIButton *returnBackBtn;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UIImageView *backImageView;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextfield;
@property (weak, nonatomic) IBOutlet UIButton *nextStepButton;
@property (weak, nonatomic) IBOutlet UIButton *returnBtn;

@property (nonatomic,copy)void(^goBackBlock)(void);
@property (nonatomic,copy)void(^closeViewBlock)(void);
@property (nonatomic,copy)void(^checkSuccessBlock)(NSString * showPhoneStr,NSString * phone);
@property (nonatomic,copy)void(^goToQQServiceBlock)(NSString * phone,NSDictionary * dic);


- (IBAction)returnBackMethod:(id)sender;
- (IBAction)nextStepMethod:(id)sender;

- (IBAction)returnMethod:(id)sender;

@end
