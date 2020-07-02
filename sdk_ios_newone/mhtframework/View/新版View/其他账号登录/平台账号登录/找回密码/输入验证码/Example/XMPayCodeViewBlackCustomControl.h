//
//  XMPayCodeViewBlackCustomControl.h
//  XMScreenLockDemo
//
//  Created by sfk-ios on 2018/5/9.
//  Copyright © 2018年 sfk-JasonSu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^PayCodeBlock)(NSString *payCode);

@interface XMPayCodeViewBlackCustomControl : UIView

+ (instancetype)payCodeView;

/// 设置是否暗文显示
@property (assign, nonatomic) BOOL secureTextEntry;
/// 最后一位输入完成时，是否退下键盘
@property (assign, nonatomic) BOOL endEditingOnFinished;
/// 支付密码
@property (copy, nonatomic, readonly) NSString *payCode;
/// 输入完成block
@property (copy, nonatomic) PayCodeBlock payBlock;

@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UIButton *returnBackBtn;

@property (weak, nonatomic) IBOutlet UIButton *closeBtn;

@property (nonatomic, copy) void (^goBackClickedBlock)(void);

@property (weak, nonatomic) IBOutlet UIButton *reactionBtn;


- (IBAction)reactionBtnMethod:(UIButton *)sender;

- (IBAction)returnBackMethod:(id)sender;

- (IBAction)closeMethod:(id)sender;


/******** method ********/
/// 让第一格成为键盘响应者
- (void)becomeKeyBoardFirstResponder;

@end
