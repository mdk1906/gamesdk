//
//  OrangeRespondModel.h
//  GreenFruit_CustomNativeByte_SDK
//
//  Created by shuangfei on 2018/2/8.
//  Copyright © 2018年 Hu. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface RespondModelContent : NSObject

@property(nonatomic, copy) NSString *sid;
@property(nonatomic, copy) NSString *userid;
@property(nonatomic, copy) NSString *floatmodel;

@end

@interface OrangeRespondModel : NSObject

@property(nonatomic, assign) NSInteger code;
@property(nonatomic, copy) NSString *message;
@property(nonatomic, strong) RespondModelContent *content;

@end

@interface DataModel : NSObject

@property(nonatomic, assign) NSInteger code;
@property(nonatomic, copy) NSString *message;
@property(nonatomic, copy) NSString *content;

@end

@interface AwardModel : NSObject

@property(nonatomic, copy) NSString *awardCode;

@end

@interface GetGiftModel : NSObject

@property(nonatomic, assign) NSInteger code;
@property(nonatomic, copy) NSString *message;
@property(nonatomic, strong) AwardModel *content;

@end

@interface PhoneModelContent : NSObject

@property(nonatomic, copy) NSString *phone;

@end

@interface PhoneModel : NSObject

@property(nonatomic, assign) NSInteger code;
@property(nonatomic, copy) NSString *message;
@property(nonatomic, strong) PhoneModelContent *content;

@end

@interface QQModelListContent : NSObject

@property(nonatomic, copy) NSString *name;
@property(nonatomic, copy) NSString *value;

@end


@interface QQModelContent : NSObject

@property(nonatomic, strong) NSArray *qList;

@end

@interface QQModel : NSObject

@property(nonatomic, assign) NSInteger code;
@property(nonatomic, copy) NSString *message;
@property(nonatomic, strong) QQModelContent *content;

@end


