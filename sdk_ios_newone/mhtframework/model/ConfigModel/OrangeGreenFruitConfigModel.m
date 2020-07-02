//
//  OrangeGreenFruitConfigModel.m
//  OrangeGreenFruitframework
//
//  Created by 张 on 2019/3/15.
//  Copyright © 2019年 Hu. All rights reserved.
//

#import "OrangeGreenFruitConfigModel.h"

@implementation OrangeGreenFruitConfigModel

+ (instancetype)share_CustomNativeByte_Manager {
    
    static OrangeGreenFruitConfigModel *config = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        config = [[OrangeGreenFruitConfigModel alloc] init];
    });
    return config;
}

@end
