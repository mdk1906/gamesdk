//
//  GreenFruitOtherWayLoginBlackCustomControl.h
//  GreenFruitframework
//
//  Created by 张 on 2018/11/29.
//  Copyright © 2018年 Hu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrangeZJAnimationPopView.h"
#import "OrangeGreenFruit_CustomNativeByte_SDKHelper.h"

typedef void(^GreenFruit_CustomNativeByte_SDKLoginCompletionBlock)(GreenFruit_CustomNativeByte_SDKUser *user,NSString *code);

@interface GreenFruitOtherWayLoginBlackCustomControl : UIView

@property (nonatomic, strong) OrangeZJAnimationPopView *popView;

@property (nonatomic, copy) GreenFruit_CustomNativeByte_SDKLoginCompletionBlock completionBlock;

@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UIButton *returnBackBtn;
@property (weak, nonatomic) IBOutlet UIButton *fastFellBtn;
@property (weak, nonatomic) IBOutlet UIButton *phoneLoginBtn;
@property (weak, nonatomic) IBOutlet UIButton *systemLoginBtn;
@property (weak, nonatomic) IBOutlet UILabel *fasrFeelLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLoginLabel;
@property (weak, nonatomic) IBOutlet UILabel *systemLoginLabel;
@property (weak, nonatomic) IBOutlet UIImageView *backImageView;


@property (nonatomic,retain)NSString * jumpViewType;
@property (nonatomic, copy) void (^goBackClickedBlock)(void);
//@property (nonatomic, copy) void (^cleanCacheBlock)(void);
@property (nonatomic, copy) void (^otherWayLoginBlock)(GreenFruitOtherWayLoginBlackCustomControl * otherWayloginView, UIButton *button);

@property (nonatomic, copy) void (^fastFeelLoginBlock)(GreenFruitOtherWayLoginBlackCustomControl * otherLoginView, UIButton *button);
@property (nonatomic, copy) void (^phoneAccountLoginBlock)(GreenFruitOtherWayLoginBlackCustomControl * otherLoginView, UIButton *button);

@property (nonatomic, copy) void (^fastLoginBlock)(NSString * account,NSString * password);

- (IBAction)returnBackMethod:(UIButton *)sender;
- (IBAction)fastLoginMethod:(UIButton *)sender;
- (IBAction)phoneLoginMethod:(UIButton *)sender;
- (IBAction)systemLoginMethod:(UIButton *)sender;

@end
