//
//  GreenFruitSetNewBoundPhoneViewBlackCustomControl.h
//  GreenFruitframework
//
//  Created by 张 on 2018/12/19.
//  Copyright © 2018年 Hu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GreenFruitSetNewBoundPhoneViewBlackCustomControl : UIView

@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UIButton *returnBtn;
@property (weak, nonatomic) IBOutlet UIButton *closeViewBtn;
@property (weak, nonatomic) IBOutlet UITextField *codeTextfield;
@property (weak, nonatomic) IBOutlet UIButton *getcodeBtn;
@property (weak, nonatomic) IBOutlet UIButton *ensureBtn;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextfield;

@property (nonatomic, copy) void(^goBackClickBlock)(void);
@property (nonatomic, copy) void(^closeviewBlock)(void);
@property (nonatomic, copy) void(^modifyNewPhoneBlock)(void);


- (IBAction)returnMethod:(id)sender;
- (IBAction)closeMethod:(id)sender;
- (IBAction)getcodeMethod:(UIButton *)sender;
- (IBAction)ensureMethod:(id)sender;

@end
