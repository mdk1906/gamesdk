//
//  GreenFruitRealIdentityCheckViewBlackCustomControl.h
//  GreenFruitframework
//
//  Created by 张 on 2018/12/4.
//  Copyright © 2018年 Hu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrangeGreenFruit_CustomNativeByte_SDKHelper.h"

typedef void(^GreenFruit_CustomNativeByte_SDKLoginCompletionBlock)(GreenFruit_CustomNativeByte_SDKUser *user,NSString *code);

@interface GreenFruitRealIdentityCheckViewBlackCustomControl : UIView

@property (nonatomic, copy) GreenFruit_CustomNativeByte_SDKLoginCompletionBlock completionBlock;

@property (weak, nonatomic) IBOutlet UIButton *returnBackBtn;
@property (weak, nonatomic) IBOutlet UIImageView *logoImageview;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UITextField *nameTextfield;
@property (weak, nonatomic) IBOutlet UIButton *identityTypeBtn;
@property (weak, nonatomic) IBOutlet UIButton *pullupBtn;
@property (weak, nonatomic) IBOutlet UITextField *identityNumbertextfield;
@property (weak, nonatomic) IBOutlet UIButton *registionBtn;
@property (weak, nonatomic) IBOutlet UIButton *changeAccountBtn;

@property (nonatomic,retain) NSString * JumpviewType;//跳转过来的页面类型

@property (nonatomic,copy)void(^gobackClickBlock)(void);
@property (nonatomic,copy)void(^comeBackToSDKBlock)(void);
@property (nonatomic,copy)void(^closeViewBlock)(void);
@property (nonatomic,copy)void(^checkSuccessBlock)(void);
@property (nonatomic,copy)void(^changeAccountBlock)(void);
@property (nonatomic,copy)void(^accountSecuretyCloseBlcok)(void);

- (IBAction)returnBackMethod:(id)sender;
- (IBAction)closeMethod:(id)sender;
- (IBAction)spreadTypeMethod:(UIButton *)sender;
- (IBAction)ensureMethod:(id)sender;
- (IBAction)changeAccountMethod:(id)sender;

@end
