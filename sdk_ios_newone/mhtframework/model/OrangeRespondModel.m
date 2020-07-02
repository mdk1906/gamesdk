//
//  OrangeRespondModel.m
//  GreenFruit_CustomNativeByte_SDK
//
//  Created by shuangfei on 2018/2/8.
//  Copyright © 2018年 Hu. All rights reserved.
//

#import "OrangeRespondModel.h"



@implementation RespondModelContent

@end

@implementation OrangeRespondModel

@end

@implementation DataModel

@end

@implementation AwardModel

@end

@implementation GetGiftModel

@end

@implementation PhoneModelContent

@end

@implementation PhoneModel

@end

@implementation QQModelListContent

@end

@implementation QQModelContent
// 返回容器类中的所需要存放的数据类型 (以 Class 或 Class Name 的形式)。
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"qList" : [QQModelListContent class]};
}
@end

@implementation QQModel

@end

