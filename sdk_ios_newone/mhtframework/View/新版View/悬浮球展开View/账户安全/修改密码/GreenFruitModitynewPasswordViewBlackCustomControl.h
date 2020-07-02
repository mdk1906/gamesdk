//
//  GreenFruitModitynewPasswordViewBlackCustomControl.h
//  GreenFruitframework
//
//  Created by 张 on 2018/12/19.
//  Copyright © 2018年 Hu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GreenFruitModitynewPasswordViewBlackCustomControl : UIView


@property (weak, nonatomic) IBOutlet UIImageView *loginImageView;
@property (weak, nonatomic) IBOutlet UIButton *returnBtn;
@property (weak, nonatomic) IBOutlet UIButton *closeViewBlock;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UITextField *codeTextfield;
@property (weak, nonatomic) IBOutlet UIButton *getCodeBtn;
@property (weak, nonatomic) IBOutlet UIButton *ensureBtn;
@property (weak, nonatomic) IBOutlet UITextField *passwordtextfield;
@property (weak, nonatomic) IBOutlet UITextField *confirmTextfield;
@property (nonatomic, retain) NSString * phoneNum;

@property (nonatomic, copy) void(^goBackClickBlock)(void);
@property (nonatomic, copy) void(^closeviewBlock)(void);
@property (nonatomic, copy) void(^modifySuccessBlock)(void);


- (IBAction)returnBtnMethod:(id)sender;
- (IBAction)closeViewMethod:(id)sender;
- (IBAction)getCodeMethod:(UIButton *)sender;
- (IBAction)ensureMethod:(id)sender;

@end
