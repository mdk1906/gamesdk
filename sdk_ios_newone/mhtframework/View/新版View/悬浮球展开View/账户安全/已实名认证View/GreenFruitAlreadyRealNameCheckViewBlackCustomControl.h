//
//  GreenFruitAlreadyRealNameCheckViewBlackCustomControl.h
//  GreenFruitframework
//
//  Created by 张 on 2018/12/10.
//  Copyright © 2018年 Hu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GreenFruitAlreadyRealNameCheckViewBlackCustomControl : UIView


@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *identityNumLabel;
@property (weak, nonatomic) IBOutlet UIButton *ensureBtn;
@property (nonatomic,retain)NSString * realName;
@property (nonatomic,retain)NSString * identitysId;

@property (nonatomic, copy) void (^goBackClickedBlock)(void);

- (IBAction)ensureMethod:(id)sender;

@end
