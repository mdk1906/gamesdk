//
//  GreenFruitSetPasswordViewBlackCustomControl.h
//  GreenFruitframework
//
//  Created by 张 on 2018/12/6.
//  Copyright © 2018年 Hu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GreenFruitSetPasswordViewBlackCustomControl : UIView

@property (weak, nonatomic) IBOutlet UIButton *returnBackBtn;

@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumberLabel;
@property (weak, nonatomic) IBOutlet UITextField *setPasswordTextfield;
@property (weak, nonatomic) IBOutlet UIButton *weatherseePsdBtn;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UIButton *ensureModifyBtn;

@property (nonatomic, retain) NSString * phoneNumber;


@property (weak, nonatomic) IBOutlet UIImageView *textfieldBackImageView;
@property (weak, nonatomic) IBOutlet UILabel *firstLabel;

@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightLabel;
@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UIView *view2;
@property (weak, nonatomic) IBOutlet UIView *view3;
@property (weak, nonatomic) IBOutlet UIView *view4;
@property (weak, nonatomic) IBOutlet UIView *view5;
@property (weak, nonatomic) IBOutlet UIView *view6;




@property (nonatomic, copy) void (^goBackClickedBlock)(void);
@property (nonatomic, copy) void (^closeViewBlock)(void);
@property (nonatomic, copy) void (^modifySuccessBlock)(NSString * account,NSString * password);


- (IBAction)returnBackMethod:(id)sender;
- (IBAction)closeViewMethod:(id)sender;
- (IBAction)weatherSeeMethod:(UIButton *)sender;
- (IBAction)ensureModifyMethod:(id)sender;

@end
