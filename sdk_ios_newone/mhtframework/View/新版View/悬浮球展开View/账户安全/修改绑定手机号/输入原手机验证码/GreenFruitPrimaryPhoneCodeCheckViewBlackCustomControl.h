//
//  GreenFruitPrimaryPhoneCodeCheckViewBlackCustomControl.h
//  GreenFruitframework
//
//  Created by 张 on 2018/12/19.
//  Copyright © 2018年 Hu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrangeZJAnimationPopView.h"

typedef void (^PayCodeBlock)(NSString *payCode);

@interface GreenFruitPrimaryPhoneCodeCheckViewBlackCustomControl : UIView

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

@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UIButton *returnBackBtn;
@property (weak, nonatomic) IBOutlet UIButton *closeViewBtn;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UIButton *getCodeBtn;

@property (nonatomic, copy) void (^PhoneCheckBlock)(void);
@property (nonatomic, copy) void (^phoneGobackBlock)(void);
@property (nonatomic, copy) void (^phoneCloseviewBlock)(void);

- (IBAction)returnBackMethod:(id)sender;
- (IBAction)closeViewMethod:(id)sender;
- (IBAction)getCodeMethod:(UIButton *)sender;
- (IBAction)reactionBtnMethod:(id)sender;

/******** method ********/
/// 让第一格成为键盘响应者
- (void)becomeKeyBoardFirstResponder;

@end
