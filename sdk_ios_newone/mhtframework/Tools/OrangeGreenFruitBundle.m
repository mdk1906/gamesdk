//
//  OrangeGreenFruitBundle.m
//  GreenFruitframework
//
//  Created by shuangfei on 2018/3/4.
//  Copyright © 2018年 Hu. All rights reserved.
//

#import "OrangeGreenFruitBundle.h"

@implementation OrangeGreenFruitBundle

+ (NSBundle *)mainBundle {
    return [NSBundle bundleWithPath: [[NSBundle mainBundle] pathForResource:@"mht" ofType: @"bundle"]];
}
+ (NSString *)getBundlePath: (NSString *) bundleName{
    NSBundle *myBundle = [OrangeGreenFruitBundle mainBundle];
    if (myBundle && bundleName) {
        return [[myBundle resourcePath] stringByAppendingPathComponent: bundleName];
    }
    return nil;
}


@end
