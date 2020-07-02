//
//  GreenFruitConfirmCodeInputViewBlackCustomControl.h
//  GreenFruitframework
//
//  Created by 张 on 2018/12/6.
//  Copyright © 2018年 Hu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrangeZJAnimationPopView.h"

typedef void (^PayCodeBlock)(NSString *payCode);

@interface GreenFruitConfirmCodeInputViewBlackCustomControl : UIView

+ (instancetype)payCodeView;

/// 设置是否暗文显示
@property (assign, nonatomic) BOOL secureTextEntry;
/// 最后一位输入完成时，是否退下键盘
@property (assign, nonatomic) BOOL endEditingOnFinished;
/// 支付密码
@property (copy, nonatomic, readonly) NSString *payCode;
/// 输入完成block
@property (copy, nonatomic) PayCodeBlock payBlock;
@property (nonatomic,retain) NSString * phone;
@property (nonatomic,retain) NSString * showPhoneStr;
@property (nonatomic,retain) NSString * jumpType;

@property (nonatomic, strong) OrangeZJAnimationPopView *popView;
@property (nonatomic, copy) void (^goBackClickedBlock)(void);
@property (nonatomic, copy) void (^closeViewBlock)(void);
@property (nonatomic, copy) void (^checkSuccessBlock)(NSString * phone);
@property (nonatomic, copy) void (^modifyPhoneCheckBlock)(void);
@property (nonatomic, copy) void (^modifyphoneGobackBlock)(void);
@property (nonatomic, copy) void (^modifyphoneCloseviewBlock)(void);
@property (nonatomic, copy) void (^boundPhoneSuccessBlock)(void);

@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UIButton *returnBackBtn;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumberLabel;
@property (weak, nonatomic) IBOutlet UIButton *getCodeBtn;
@property (weak, nonatomic) IBOutlet UILabel *explanLabel;
@property (weak, nonatomic) IBOutlet UIButton *reactionBtn;


- (IBAction)returnBackMethod:(id)sender;
- (IBAction)closeMethod:(id)sender;
- (IBAction)getCodeMethod:(UIButton *)sender;
- (IBAction)reactionMethod:(id)sender;



/******** method ********/
/// 让第一格成为键盘响应者
- (void)becomeKeyBoardFirstResponder;

@end
