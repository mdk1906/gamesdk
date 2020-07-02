//
//  OrangeRegistFastModel.h
//  GreenFruit_CustomNativeByte_SDK
//
//  Created by shuangfei on 2018/2/6.
//  Copyright © 2018年 Hu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RegistFastModelContent : NSObject

@property(nonatomic, assign) NSInteger userID; //平台的userID
@property(nonatomic, copy) NSString *username; //平台生成的用户名
@property(nonatomic, copy) NSString *password; //平台生成的密码

@end

@interface OrangeRegistFastModel : NSObject

@property(nonatomic, assign) NSInteger code;
@property(nonatomic, copy) NSString *message;
@property(nonatomic, strong) RegistFastModelContent *content;

@end


