//
//  OrangeGreenFruitIAPHelper.h
//  OrangeGreenFruitframework
//
//  Created by shuangfei on 2018/3/10.
//  Copyright © 2018年 Hu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OrangeGreenFruitIAPManager.h"

typedef void(^TransactionPurchasedCompletionBlock)(SKPaymentTransaction *transaction);
typedef void(^TransactionRestoredCompletionBlock)(SKPaymentTransaction *transaction);
typedef void(^ProductRequestCompletionBlock)(void);
typedef void(^RestoreFinishCompletionBlcok)(BOOL);
typedef void(^VerifyCompletion)(NSDictionary *dictionary,NSError *error);

@interface OrangeGreenFruitIAPHelper : NSObject<GreenFruitIAPDelegate>

@property (nonatomic, copy) TransactionPurchasedCompletionBlock transactionPurchasedCompletionBlock;
@property (nonatomic, copy) TransactionRestoredCompletionBlock transactionRestoredCompletionBlock;
@property (nonatomic, copy) ProductRequestCompletionBlock productRequestCompletionBlock;
@property (nonatomic, copy) RestoreFinishCompletionBlcok restoreFinishCompletionBlcok;
@end
