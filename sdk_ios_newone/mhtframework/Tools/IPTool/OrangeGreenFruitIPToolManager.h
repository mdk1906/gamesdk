//
//  OrangeGreenFruitIPToolManager.h
//  GreenFruitframework
//
//  Created by 张 on 2019/1/15.
//  Copyright © 2019年 Hu. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface OrangeGreenFruitIPToolManager : NSObject

/**
 *  单例
 */
+(instancetype)sharedManager;


/**
 *  方法一
 *  获取具体的ip地址
 */
-(NSString *)currentIpAddress;


/**
 *  方法二
 *  获取ip地址的详细信息
 */
-(void)currentIPAdressDetailInfo;

@end
