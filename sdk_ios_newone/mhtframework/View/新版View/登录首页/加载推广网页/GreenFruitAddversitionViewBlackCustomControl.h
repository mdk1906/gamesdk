//
//  GreenFruitAddversitionViewBlackCustomControl.h
//  GreenFruitframework
//
//  Created by 张 on 2018/11/29.
//  Copyright © 2018年 Hu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GreenFruitAddversitionViewBlackCustomControl : UIView

@property (weak, nonatomic) IBOutlet UIButton *returnBackBtn;

@property (weak, nonatomic) IBOutlet UIWebView *webView;

- (IBAction)returnBackMethod:(UIButton *)sender;

@property (nonatomic, copy) void (^goBackClickedBlock)(void);

@property (nonatomic,retain)NSString * webUrlString;

@end
