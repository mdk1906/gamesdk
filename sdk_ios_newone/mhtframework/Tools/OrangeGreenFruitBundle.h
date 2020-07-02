//
//  OrangeGreenFruitBundle.h
//  GreenFruitframework
//
//  Created by shuangfei on 2018/3/4.
//  Copyright © 2018年 Hu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrangeGreenFruitBundle : NSObject

+ (NSString *)getBundlePath: (NSString *)bundleName;
+ (NSBundle *)mainBundle;

@end
