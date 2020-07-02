//
//  OrangeGreenFruitPayStore.m
//  GreenFruitframework
//
//  Created by shuangfei on 2018/3/10.
//  Copyright © 2018年 Hu. All rights reserved.
//

#import "OrangeGreenFruitPayStore.h"
#import "OrangeAPIParams.h"
#import "OrangeOrderModel.h"
#import "OrangeYYModel.h"
#import "OrangeMBManager.h"
#import "OrangeGreenFruitConfig.h"
#define kAppStoreVerifyURL @"https://buy.itunes.apple.com/verifyReceipt" //实际购买验证URL
#define kSandboxVerifyURL @"https://sandbox.itunes.apple.com/verifyReceipt" //开发阶段沙盒验证URL

@interface OrangeGreenFruitPayStore()

@property (nonatomic,copy) NSString *golbalOrderNo;
@property(nonatomic, strong)GreenFruit_CustomNativeByte_SDKPay *payInfo;

@end

@implementation OrangeGreenFruitPayStore

- (void)payGreenFruit_CustomNativeByte_SDKPay:(GreenFruit_CustomNativeByte_SDKPay*)pay{
    self.payInfo = pay;
    [self getOrderNo];
}

- (void)requestFinished{
    [[OrangeGreenFruitIAPManager share_CustomNativeByte_Manager] startPaymentWithProductId:self.payInfo.productID];
}

- (void)transactionPurchasedSKPaymentQueue:(SKPaymentQueue*)queue transaction:(SKPaymentTransaction*)transaction{
    NSLog(@"transactionPurchasedSKPaymentQueue");
}
- (void)transactionRestoreSKPaymentQueue:(SKPaymentQueue*)queue transaction:(SKPaymentTransaction*)transaction{
    NSLog(@"transactionRestoreSKPaymentQueue");
}
- (void)transactionRestoreFinished:(BOOL)isSuccess{
    NSLog(@"transactionRestoreFinished");
}

- (void)createOrderNotification:(NSNotificationCenter*)notification{
    [self startIAP];
}

- (void)startIAP{
    
    //支付前检查是否有未结束的订单
//    [[OrangeGreenFruitIAPManager share_CustomNativeByte_Manager] checkTransaction];
    
    NSLog(@"--传递的商品ID:%@",self.payInfo.productID);
    NSSet *productsIds = [NSSet setWithObject:self.payInfo.productID];
    [[OrangeGreenFruitIAPManager share_CustomNativeByte_Manager] setRequestWithProducts:productsIds delegate:self];
    [[OrangeGreenFruitIAPManager share_CustomNativeByte_Manager] startRequest];
}

- (void)getOrderNo{
    
    NSLog(@"获取苹果订单");
    
    [OrangeAPIParams requestGetOrderNo:self.payInfo SuccessBlock:^(id response) {
        NSDictionary *element = (NSDictionary*)response;
        OrangeOrderModel *orderModel = [OrangeOrderModel yy_modelWithJSON:element];
        if(orderModel.code == 200){
            NSLog(@"获取订单号成功");
            NSString *no = orderModel.content.orderNo;
            
            //将苹果内购订单号缓存  以备苹果校验后出现order为空的情况
            User_Defaules_Set(no, @"ApplePayOrderNo");
            
            NSLog(@"拿到订单号%@",no);
            [[OrangeGreenFruitIAPManager share_CustomNativeByte_Manager] setPayEntity:no];
            
            [self startIAP];
            
        }else{
            NSMutableDictionary *payDic = [NSMutableDictionary dictionary];
            payDic[@"result"] = [NSNumber numberWithBool:NO];
            [[NSNotificationCenter defaultCenter] postNotificationName:payfinish object:payDic];
            NSLog(@"获取订单号失败");
        }
        
    } failedblock:^(NSError *error) {
        NSLog(@"订单获取异常");
        NSMutableDictionary *payDic = [NSMutableDictionary dictionary];
        payDic[@"result"] = [NSNumber numberWithBool:NO];
        [[NSNotificationCenter defaultCenter] postNotificationName:payfinish object:payDic];
        if(error.code == 4){
            [OrangeMBManager show_CustomNativeByte_BriefAlert:@"网络异常" time:1];
        }else{
            [OrangeMBManager show_CustomNativeByte_BriefAlert:@"异常错误" time:1];
        }
    }];
}
@end
