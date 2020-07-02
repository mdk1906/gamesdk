//
//  OrangeCheckIdentifyModel.h
//  GreenFruit_CustomNativeByte_SDK
//
//  Created by shuangfei on 2018/2/21.
//  Copyright © 2018年 Hu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IdentifyDataModel : NSObject

@property(nonatomic, copy) NSString *identityNo;
@property(nonatomic, copy) NSString *realName;

@end

@interface OrangeCheckIdentifyModel : NSObject

@property(nonatomic, assign) NSInteger code;
@property(nonatomic, strong) IdentifyDataModel *content;
@property(nonatomic, copy) NSString *message;

@end
