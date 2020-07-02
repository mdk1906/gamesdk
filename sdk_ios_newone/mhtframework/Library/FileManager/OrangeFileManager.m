//
//  OrangeFileManager.m
//  OrangeGreenFruitframework
//
//  Created by 张 on 2018/8/16.
//  Copyright © 2018年 Hu. All rights reserved.
//

#import "OrangeFileManager.h"

@implementation OrangeFileManager
/**
 存储用户购买凭证
 
 @param receipt 购买凭证
 @param orderNum 订单号
 */
+ (void)saveReceiptValidation:(NSString *_Nonnull)receipt
                     orderNum:(NSString *_Nonnull)orderNum
                     file:(NSString *_Nonnull)file
{
//    NSDate *dateSaved = [NSDate date];
//    NSString *fileName = [NSString stringWithFormat:@"IAPInfo-%@", orderNum];
//    NSString *fileDir = [[self class] getIAPInfoLocalFilePath:@"GreenFruit-IAPAY"];
//    NSString *savedPath = [NSString stringWithFormat:@"%@%@.plist", fileDir, fileName];
//    NSDictionary *dic =[NSDictionary dictionaryWithObjectsAndKeys:
//                        receipt, @"receipt",
//                        dateSaved, @"date",
//                        orderNum, @"orderNo",
//                        nil];
//
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//
//    BOOL isDir = FALSE;
//    BOOL isDirExist = [fileManager fileExistsAtPath:fileDir isDirectory:&isDir];
//
//    if(!(isDirExist && isDir)) {//目录不存在
//        BOOL bCreateDir = [fileManager createDirectoryAtPath:fileDir withIntermediateDirectories:YES attributes:nil error:nil];
//
//        if(!bCreateDir){
//            NSLog(@"Create Directory Failed.");
//        } else {
//            [[self class] saveFile:savedPath withDictionary:dic];
//        }
//
//    } else {//目录存在，直接保存
//        [[self class] saveFile:savedPath withDictionary:dic];
//    }
    
    NSString *filePatch = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0]stringByAppendingPathComponent:file];
    NSDate *dateSaved = [NSDate date];
    NSMutableDictionary *dic =[NSMutableDictionary dictionaryWithObjectsAndKeys:
                            orderNum, @"orderNo",
                            receipt, @"receipt",
                            dateSaved, @"date",
                            nil];
//    NSLog(@"缓存订单:%@",dic);
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    if(![fileManager fileExistsAtPath:filePatch]){
//        NSLog(@"order.plist文件不存在");
//        [fileManager createFileAtPath:filePatch contents:nil attributes:nil];
//    }
    
    NSMutableDictionary *userDict = [[NSMutableDictionary alloc ]initWithContentsOfFile:filePatch];
    if (!userDict) {
        userDict = [[NSMutableDictionary alloc] init];
    }
    [userDict setObject:dic forKey:orderNum];
    [[self class] saveFile:filePatch withDictionary:userDict];
}

+ (BOOL)saveFile:(NSString *)savedPath withDictionary:(NSDictionary *)dic
{
    BOOL isWrited = [dic writeToFile:savedPath atomically:YES];
//    NSLog(@"saveReceiptValidation is success ? %@,  at savedPath：%@", @(isWrited), savedPath);
    return isWrited;
}

+ (NSString *)getIAPInfoLocalFilePath:(NSString *)sID
{
    return [NSString stringWithFormat:@"%@/IAPReceipt-%@/", [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject], sID];
}


+(void) delOrderPlist{
//    NSLog(@"删除plist");
    NSFileManager *fileMger = [NSFileManager defaultManager];
    NSString *order = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0]stringByAppendingPathComponent:@"order.plist"];
    //如果文件路径存在的话    BOOL bRet = [fileMger fileExistsAtPath:xiaoXiPath];
    NSError *err;
    [fileMger removeItemAtPath:order error:&err];
}

+(void) delDic:(NSString *) orderNo{
//    NSLog(@"移除订单号:%@",orderNo);
    NSString *filePatch = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0]stringByAppendingPathComponent:@"order.plist"];
    NSMutableDictionary *userDict = [[NSMutableDictionary alloc ]initWithContentsOfFile:filePatch];
    [userDict removeObjectForKey:orderNo];
     [[self class] saveFile:filePatch withDictionary:userDict];
}

/**
 验证receipt失败，再次验证
 
 @param sID 唯一标识（比如UserId）
 */
+ (void)resendFailedReceiptValidation
{
    NSString *filePatch = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0]stringByAppendingPathComponent:@"order.plist"];
    
    //搜索该目录下的所有文件和目录
    
    NSMutableDictionary *userDict = [[NSMutableDictionary alloc ]initWithContentsOfFile:filePatch];
//    NSLog(@"%@", userDict);
}


//读取第一条订单
+ (NSMutableDictionary *)readFirstOrder{
    NSString *filePatch = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0]stringByAppendingPathComponent:@"order.plist"];
    //搜索该目录下的所有文件和目录
    NSMutableDictionary *userDict = [[NSMutableDictionary alloc ]initWithContentsOfFile:filePatch];
    NSArray *orderKeys = [userDict allKeys];
    NSArray *sortedKeys = [orderKeys sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    for (NSObject *object in sortedKeys) {
//        NSLog(@"读取订单号:%@",object);
        NSMutableDictionary * orderDic = [userDict objectForKey:object];
        return orderDic;
    }
    return nil;
}

@end
