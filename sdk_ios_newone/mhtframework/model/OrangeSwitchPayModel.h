//
//  OrangeSwitchPayModel.h
//  OrangeGreenFruitframework
//
//  Created by shuangfei on 2018/3/10.
//  Copyright © 2018年 Hu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SwitchPayDataModel : NSObject

@property(nonatomic, copy) NSString *type;

@end

@interface OrangeSwitchPayModel : NSObject

@property(nonatomic, assign) NSInteger code;
@property(nonatomic, copy) NSString *message;
@property(nonatomic, strong) SwitchPayDataModel *content;

@end
