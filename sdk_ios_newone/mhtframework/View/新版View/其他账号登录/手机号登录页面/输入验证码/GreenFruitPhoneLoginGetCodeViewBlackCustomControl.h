//
//  GreenFruitPhoneLoginGetCodeViewBlackCustomControl.h
//  GreenFruitframework
//
//  Created by 张 on 2018/12/8.
//  Copyright © 2018年 Hu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrangeZJAnimationPopView.h"
#import "OrangeGreenFruit_CustomNativeByte_SDKHelper.h"


typedef void (^PayCodeBlock)(NSString *payCode);

typedef void(^GreenFruit_CustomNativeByte_SDKLoginCompletionBlock)(GreenFruit_CustomNativeByte_SDKUser *user,NSString *code);

@interface GreenFruitPhoneLoginGetCodeViewBlackCustomControl : UIView

+ (instancetype)payCodeView;

@property (nonatomic, copy) GreenFruit_CustomNativeByte_SDKLoginCompletionBlock completionBlock;

/// 设置是否暗文显示
@property (assign, nonatomic) BOOL secureTextEntry;
/// 最后一位输入完成时，是否退下键盘
@property (assign, nonatomic) BOOL endEditingOnFinished;
/// 支付密码
@property (copy, nonatomic, readonly) NSString *payCode;
/// 输入完成block
@property (copy, nonatomic) PayCodeBlock payBlock;
@property (nonatomic,retain) NSString * phone;

@property (nonatomic, strong) OrangeZJAnimationPopView *popView;
@property (nonatomic, copy) void (^goBackClickedBlock)(void);
@property (nonatomic, copy) void (^closeViewBlock)(void);
@property (nonatomic, copy) void (^successCheckCodeBlock)(GreenFruit_CustomNativeByte_SDKLoginCompletionBlock completionBlock);
@property (nonatomic, copy) void (^realIdentifyCheckBlock)(void);
@property (nonatomic, copy) void (^boundPhoneBlock)(void);
@property (nonatomic, copy) void (^skipViewBlock)(void);

@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UIButton *returnBackbtn;
@property (weak, nonatomic) IBOutlet UIButton *closeViewBtn;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumberLabel;
@property (weak, nonatomic) IBOutlet UIButton *getCodeBtn;
@property (weak, nonatomic) IBOutlet UIButton *dosomethingBtn;
@property (weak, nonatomic) IBOutlet UIButton *reactionBtn;


- (IBAction)returnBackBtn:(UIButton *)sender;
- (IBAction)closeView:(UIButton *)sender;
- (IBAction)getCodemethod:(UIButton *)sender;
- (IBAction)reactionBtn:(id)sender;
- (IBAction)doSomethingMethod:(id)sender;

@end
