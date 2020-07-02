//
//  OrangeGreenFruitProtocol.h
//  GreenFruitframework
//
//  Created by 张 on 2018/8/13.
//  Copyright © 2018年 Hu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrangeGreenFruitProtocol : UIView
@property (nonatomic, copy) void (^goBackClickedBlock)(void);
@end
