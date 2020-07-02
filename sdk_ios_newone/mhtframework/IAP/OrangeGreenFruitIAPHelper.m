//
//  OrangeGreenFruitIAPHelper.m
//  OrangeGreenFruitframework
//
//  Created by shuangfei on 2018/3/10.
//  Copyright © 2018年 Hu. All rights reserved.
//

#import "OrangeGreenFruitIAPHelper.h"

@implementation OrangeGreenFruitIAPHelper

- (void)config{
    [self initWithDeledate:self];
}

- (void)requestProductsWithIds:(NSSet*)productsIds completion:(ProductRequestCompletionBlock)completion{
    self.productRequestCompletionBlock = completion;
    [[OrangeGreenFruitIAPManager share_CustomNativeByte_Manager] setRequestWithProducts:productsIds delegate:nil];
    [[OrangeGreenFruitIAPManager share_CustomNativeByte_Manager] startRequest];
}

- (void)purchaseProductWithId:(NSString*)productId completion:(TransactionPurchasedCompletionBlock)completion{
    self.transactionPurchasedCompletionBlock = completion;
    [[OrangeGreenFruitIAPManager share_CustomNativeByte_Manager] startPaymentWithProductId:productId];
}

- (void)restoreWithCompletion:(TransactionRestoredCompletionBlock)success finish:(RestoreFinishCompletionBlcok)finish{
    self.transactionRestoredCompletionBlock = success;
    self.restoreFinishCompletionBlcok = finish;
}

- (void)verifyReceipt:(VerifyCompletion)completion{
    
}

- (void)initWithDeledate:(id<GreenFruitIAPDelegate>)deledate{
    [[OrangeGreenFruitIAPManager share_CustomNativeByte_Manager] setGreenFruitIAPDelegate:deledate];
}

- (void)transactionPurchasedSKPaymentQueue:(SKPaymentQueue*)queue transaction:(SKPaymentTransaction*)transaction{
    self.transactionPurchasedCompletionBlock(transaction);
}

- (void)transactionRestoreSKPaymentQueue:(SKPaymentQueue*)queue transaction:(SKPaymentTransaction*)transaction{
    self.transactionRestoredCompletionBlock(transaction);
}

- (void)transactionRestoreFinished:(BOOL)isSuccess{
    self.restoreFinishCompletionBlcok(isSuccess);
}

- (void)requestFinished{
    self.productRequestCompletionBlock();
}
@end
