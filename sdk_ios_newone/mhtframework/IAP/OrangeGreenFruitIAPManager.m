//
//  OrangeGreenFruitIAPManager.m
//  OrangeGreenFruitframework
//
//  Created by shuangfei on 2018/3/10.
//  Copyright © 2018年 Hu. All rights reserved.
//

#import "OrangeGreenFruitIAPManager.h"
#import "OrangeAPIParams.h"
#import "OrangeVerifyModel.h"
#import "OrangeYYModel.h"
#import "OrangeMBManager.h"
#import "OrangeGreenFruitConfig.h"
#import "OrangeFileManager.h"
//购买验证URL
#define kAppStoreVerifyURL @"https://buy.itunes.apple.com/verifyReceipt" //实际购买验证URL
#define kSandboxVerifyURL @"https://sandbox.itunes.apple.com/verifyReceipt" //开发阶段沙盒验证URL

@implementation OrangeGreenFruitIAPManager

+ (instancetype)share_CustomNativeByte_Manager {
    static OrangeGreenFruitIAPManager *config = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        config = [[OrangeGreenFruitIAPManager alloc] init];
    });
    return config;
}

- (void)setRequestWithProducts:(NSSet*)productsIds delegate:(id<GreenFruitIAPDelegate>)delegate{
    self.request = [[SKProductsRequest alloc]initWithProductIdentifiers:productsIds];
    self.request.delegate = self;
//    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
//    [self addTransactionObserver];
    if(delegate){
        [self setGreenFruitIAPDelegate:delegate];
    }
}

-(void) addTransactionObserver{
//    NSLog(@"addTransactionObserver");
    if ([NSThread isMainThread]) {
//        NSLog(@"当前线程:主线程");
    }
    else{
//        NSLog(@"当前线程:子线程");
    }
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
}




- (void)setGreenFruitIAPDelegate:(id<GreenFruitIAPDelegate>)delegate{
    self.delegate = delegate;
    self.paymentDelegate = delegate;
}

- (void)setPaymentTransactionsDelegate:(id<GreenFruitIAPPaymentDelegate>)delegate{
//    NSLog(@"setPaymentTransactionsDelegate");
    self.paymentDelegate = delegate;
}

- (void)setPayEntity:(NSString*)orderNo{
    self.golbalOrderNo = orderNo;
}

- (void)removeProductsDelegate{
//    NSLog(@"removeProductsDelegate");
    self.paymentDelegate = nil;
}

- (void)startRequest{
    [self testIsNil];
    [self.request start];
}

- (void)cancelRequest{
    [self testIsNil];
    [self.request cancel];
}



- (void)startPaymentWithProductId:(NSString*)productId{
//    NSLog(@"startPaymentWithProductId:%@",productId);
    if([SKPaymentQueue canMakePayments]){
        if(self.productDict){
            SKProduct *product = (SKProduct*)self.productDict[productId];
            [self requestPaymentWithProduct:product];
        }else{
//            NSLog(@"products haven't been loaded");
        }
    }
}

- (void)restorePayment{
    self.restoreSuccess = false;
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}

#pragma mark -SKProductsRequestDelegate
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response{
    if(!self.productDict){
//        NSLog(@"first load products");
        self.productDict = [NSMutableDictionary dictionaryWithCapacity:response.products.count];
    }
    for(SKProduct *product in response.products){
//        NSLog(@"product(%@)loaded",product.productIdentifier);
//        self.productDict[product.productIdentifier] = product;
        [self.productDict setObject:product forKey:product.productIdentifier];
        [self startPaymentWithProductId:product.productIdentifier];
    }
}

#pragma mark -SKPaymentTransactionObserver
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray<SKPaymentTransaction *> *)transactions{
    //记录了所有的购买记录
    for (SKPaymentTransaction *transaction in transactions) {
        
        switch (transaction.transactionState) {
            case SKPaymentTransactionStatePurchased:
            {
//                NSLog(@"交易完成");
                [self resetRetry];
                [self verifyPruchase:transaction];
            }
                break;
                
            case SKPaymentTransactionStatePurchasing:
            {
               
                NSLog(@"商品添加进列表");
            }
                break;
                
            case SKPaymentTransactionStateRestored:
            {
                self.restoreSuccess = YES;
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                NSMutableDictionary *payDic = [NSMutableDictionary dictionary];
                payDic[@"result"] = [NSNumber numberWithBool:NO];
                [[NSNotificationCenter defaultCenter] postNotificationName:payfinish object:payDic];
                NSLog(@"已经购买过商品");
            }
                break;
            case SKPaymentTransactionStateFailed:
            {
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                NSMutableDictionary *payDic = [NSMutableDictionary dictionary];
                payDic[@"result"] = [NSNumber numberWithBool:NO];
                [[NSNotificationCenter defaultCenter] postNotificationName:payfinish object:payDic];
                NSLog(@"交易失败");
            }
                break;
            default:
                 NSLog(@"交易异常");
                break;
        }
    }
}

- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error{
//    NSLog(@"retore failed with error:%@",error);
    [self.paymentDelegate transactionRestoreFailedWithError:error];
}

- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue{
//    NSLog(@"paymentQueueRestoreCompletedTransactionsFinished");
    [self.paymentDelegate transactionRestoreFinished:self.restoreSuccess];
}

- (void)requestPaymentWithProduct:(SKProduct*)product{
//    NSLog(@"requestPaymentWithProduct");
    SKMutablePayment* payment = [SKMutablePayment paymentWithProduct:product];
    payment.applicationUsername = self.golbalOrderNo;
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

- (void)testIsNil{
    if(!self.request){
//       NSLog(@"request hasn't been init");
    }else if (!self.request.delegate){
//        NSLog(@"request delegate hasn't been set");
    }
}

- (void)verifyPruchase:(SKPaymentTransaction*) transaction{
    NSURL *receiptURL = [[NSBundle mainBundle] appStoreReceiptURL];
    NSData *receiptData = [NSData dataWithContentsOfURL:receiptURL];
    NSString* order = [[transaction payment] applicationUsername];
    NSString *encodeStr = [receiptData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    NSLog(@"凭证验证中。。");
    if(order == NULL|| [order isEqual:@""]){
        NSLog(@"凭证中orderNo为空");
//        [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
//        return;

        NSString * orderNo = User_Defaults_Get(@"ApplePayOrderNo");
        order = [NSString stringWithFormat:@"%@",orderNo];
    }
    
    //苹果支付回调后，先将订单信息保存到本地文件。
    [OrangeFileManager saveReceiptValidation:encodeStr orderNum:order file:@"order.plist"];
    
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    
//    [self checkPay:encodeStr orderNo:order];
    [self checkLocalOrder:@"1"];
}

- (void)checkPay:(NSString*)requestData orderNo:(NSString *) orderNo{

    NSMutableDictionary *payDic = [NSMutableDictionary dictionary];
    payDic[@"orderNo"] = orderNo;
    payDic[@"data"] = requestData;
    payDic[@"type"] = @"1";
    NSLog(@"发起支付验证通知,dic:%@)",payDic);
//
    dispatch_async(dispatch_get_main_queue(), ^{
//        [[NSNotificationCenter defaultCenter] postNotificationName:payfinish object:payDic];
        [[NSNotificationCenter defaultCenter] postNotificationName:payverify_notification object:payDic];
    });
}


//是否重试最大次数
- (BOOL)isRetryMax{
    if(retry >= 3)
        return YES;
    retry++;
    return NO;
}

- (void)resetRetry{
    retry = 0;
}

- (int)getRetry{
    return retry;
}

//保存支付订单
-(void) saveOrder:(NSString *) orderNo data:(NSString *) data file:(NSString *) file{
    [OrangeFileManager saveReceiptValidation:data orderNum:orderNo file:file];
}

//检查本地是否有未完成的订单
- (void)checkLocalOrder:(NSString *)type{
//    NSLog(@"开始检查本地订单");
    NSMutableDictionary * order =  [OrangeFileManager readFirstOrder];
    if(order == nil){
//        NSLog(@"没有本地订单需要发送");
        return;
    }
    
    NSString * orderNo = [order objectForKey:@"orderNo"];
    NSString * receipt = [order objectForKey:@"receipt"];
    
    //调用发送订单接口
    NSMutableDictionary *payDic = [NSMutableDictionary dictionary];
    payDic[@"orderNo"] = orderNo;
    payDic[@"data"] = receipt;
    payDic[@"type"] = type;
//    NSLog(@"订单:%@",payDic);
    //再次发起支付
    //
    dispatch_async(dispatch_get_main_queue(), ^{
        //        [[NSNotificationCenter defaultCenter] postNotificationName:payfinish object:payDic];
        [[NSNotificationCenter defaultCenter] postNotificationName:payverify_notification object:payDic];
    });
    
//    [[OrangeGreenFruitIAPManager share_CustomNativeByte_Manager] checkLocalOrder];
}


/**
 检查是否有未关闭的交易
 */
-(void) checkTransaction{
    NSArray* transactions = [SKPaymentQueue defaultQueue].transactions;
    if (transactions.count > 0) {
        //检测是否有未完成的交易
        SKPaymentTransaction* transaction = [transactions firstObject];
        if (transaction.transactionState == SKPaymentTransactionStatePurchased) {
            [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
            return;
        }
    }
}

@end
