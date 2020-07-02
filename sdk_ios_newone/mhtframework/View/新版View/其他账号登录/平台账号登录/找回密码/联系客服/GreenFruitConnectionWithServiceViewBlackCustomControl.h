//
//  GreenFruitConnectionWithServiceViewBlackCustomControl.h
//  GreenFruitframework
//
//  Created by 张 on 2018/12/5.
//  Copyright © 2018年 Hu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GreenFruitConnectionWithServiceViewBlackCustomControl : UIView

@property (weak, nonatomic) IBOutlet UIButton *returnBackBtn;

@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIButton *contactBtn;

@property (nonatomic,retain)NSString * userName;
@property (nonatomic,retain)NSDictionary * serverceDic;

@property (nonatomic, copy) void (^goBackClickedBlock)(void);
@property (nonatomic, copy) void (^closeViewBlock)(void);


- (IBAction)returnBackMethod:(id)sender;
- (IBAction)closeViewMethod:(id)sender;
- (IBAction)getInTouchMethod:(id)sender;

@end
