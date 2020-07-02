//
//  OrangeFileManager.h
//  OrangeGreenFruitframework
//
//  Created by 张 on 2018/8/16.
//  Copyright © 2018年 Hu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrangeFileManager : NSObject
+ (void)saveReceiptValidation:(NSString *_Nonnull)receipt
                     orderNum:(NSString *_Nonnull)orderNum
                     file:(NSString *_Nonnull)file;
+ (void)resendFailedReceiptValidation;
+ (void) delDic:(NSString *) orderNo;
+ (void) delOrderPlist;
+ (NSMutableDictionary*) readFirstOrder;
@end
