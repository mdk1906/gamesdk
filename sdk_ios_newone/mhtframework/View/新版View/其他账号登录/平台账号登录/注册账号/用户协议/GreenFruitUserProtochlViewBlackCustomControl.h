//
//  GreenFruitUserProtochlViewBlackCustomControl.h
//  GreenFruitframework
//
//  Created by 张 on 2018/12/5.
//  Copyright © 2018年 Hu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GreenFruitUserProtochlViewBlackCustomControl : UIView

@property (weak, nonatomic) IBOutlet UIButton *returnBackBtn;

@property (weak, nonatomic) IBOutlet UIWebView *protochlWebView;

@property (nonatomic, copy) void (^goBackClickedBlock)(void);


- (IBAction)returnBackMethod:(id)sender;

@end
