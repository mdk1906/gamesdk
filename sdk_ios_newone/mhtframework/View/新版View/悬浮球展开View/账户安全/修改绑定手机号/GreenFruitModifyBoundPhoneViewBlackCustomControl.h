//
//  GreenFruitModifyBoundPhoneViewBlackCustomControl.h
//  GreenFruitframework
//
//  Created by 张 on 2018/12/19.
//  Copyright © 2018年 Hu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GreenFruitModifyBoundPhoneViewBlackCustomControl : UIView

@property (weak, nonatomic) IBOutlet UIImageView *loginImageView;
@property (weak, nonatomic) IBOutlet UIButton *closeViewBtn;
@property (weak, nonatomic) IBOutlet UIButton *returnBtn;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UIButton *modifyBtn;

@property (nonatomic, copy) NSString * phoneStr;

@property (nonatomic, copy) void (^gobackClickBlock)(void);
@property (nonatomic, copy) void (^closeViewBlock)(void);
@property (nonatomic, copy) void (^modifyPhoneBlock)(void);

- (IBAction)closeViewMethod:(id)sender;
- (IBAction)ensureMethod:(id)sender;
- (IBAction)returnBtnMethod:(id)sender;

@end
