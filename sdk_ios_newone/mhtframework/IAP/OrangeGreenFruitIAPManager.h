//
//  OrangeGreenFruitIAPManager.h
//  OrangeGreenFruitframework
//
//  Created by shuangfei on 2018/3/10.
//  Copyright © 2018年 Hu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>
@protocol GreenFruitIAPRequestDelegate<NSObject>

- (void)requestFinished;

@end

@protocol GreenFruitIAPPaymentDelegate<NSObject>

- (void)transactionPurchasedSKPaymentQueue:(SKPaymentQueue*)queue transaction:(SKPaymentTransaction*)transaction;
- (void)transactionFailedSKPaymentQueue:(SKPaymentQueue*)queue transaction:(SKPaymentTransaction*)transaction;
- (void)transactionRestoreSKPaymentQueue:(SKPaymentQueue*)queue transaction:(SKPaymentTransaction*)transaction;
- (void)transactionDeferredSKPaymentQueue:(SKPaymentQueue*)queue transaction:(SKPaymentTransaction*)transaction;
- (void)transactionPurchasingSKPaymentQueue:(SKPaymentQueue*)queue transaction:(SKPaymentTransaction*)transaction;
- (void)transactionRestoreFailedWithError:(NSError*)error;
- (void)transactionRestoreFinished:(BOOL)isSuccess;

@end

@protocol GreenFruitIAPDelegate<GreenFruitIAPRequestDelegate,GreenFruitIAPPaymentDelegate>


@end

@interface OrangeGreenFruitIAPManager : NSObject<SKPaymentTransactionObserver,SKProductsRequestDelegate>
{
    //重试次数，默认三次
    int retry;
}

@property (nonatomic ,assign) BOOL restoreSuccess;
@property (nonatomic ,strong) NSMutableDictionary *productDict;
@property (nonatomic ,copy) NSString *productID;
@property (nonatomic ,strong) SKProductsRequest *request;
@property (nonatomic ,weak) id<SKPaymentTransactionObserver> observer;
@property (nonatomic ,weak) id<GreenFruitIAPDelegate> delegate;
@property (nonatomic ,weak) id<GreenFruitIAPPaymentDelegate> paymentDelegate;
@property (nonatomic ,copy) NSString *golbalOrderNo;

+ (instancetype)share_CustomNativeByte_Manager;
- (void)setRequestWithProducts:(NSSet*)productsIds delegate:(id<GreenFruitIAPDelegate>)delegate;
- (void)setGreenFruitIAPDelegate:(id<GreenFruitIAPDelegate>)delegate;
- (void)setPaymentTransactionsDelegate:(id<GreenFruitIAPPaymentDelegate>)delegate;
- (void)setPayEntity:(NSString*)orderNo;
- (void)removeProductsDelegate;
- (void)startRequest;
- (void)cancelRequest;
- (void)startPaymentWithProductId:(NSString*)productId;
- (void)restorePayment;
- (void)addTransactionObserver;
- (BOOL)isRetryMax;
- (void)resetRetry;
- (int)getRetry;
- (void)checkLocalOrder:(NSString*)type;
-(void) checkTransaction;
@end
