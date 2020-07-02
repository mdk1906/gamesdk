//
//  ViewController.m
//  MHTSDKTest
//
//  Created by leigang on 2018/3/4.
//  Copyright © 2018年 gang. All rights reserved.
//

#import "ViewController.h"
#import <mhtframework/OrangeGreenFruit_CustomNativeByte_SDKCreate.h>


#define KWidth ([UIScreen mainScreen].bounds.size.width)
#define KHeight ([UIScreen mainScreen].bounds.size.height)


#import <StoreKit/StoreKit.h>
//沙盒测试环境验证
#define SANDBOX @"https://sandbox.itunes.apple.com/verifyReceipt"
//正式环境验证
#define AppStore @"https://buy.itunes.apple.com/verifyReceipt"
#define ProductID1 @"mhtAbroadSdk_gold_coin_01"


@interface ViewController ()<SKProductsRequestDelegate,SKPaymentTransactionObserver>
{
    UIButton * deleteButton;
    
    UIView * textBackView;
    
    UITextField * amtTextfield;
}

@property (nonatomic,retain)UIImageView * shotImageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];

}

- (IBAction)loginClick:(UIButton *)sender {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        //处理耗时操作在此次添加
        //通知主线程刷新
        dispatch_async(dispatch_get_main_queue(), ^{
            //在主线程刷新UI

            NSLog(@"登录了哈");
            
            [[OrangeGreenFruit_CustomNativeByte_SDKCreate share_CustomNativeByte_Manager]GreenFruitLoginRootVC:self CompletionBlock:^(GreenFruit_CustomNativeByte_SDKUser *user, NSString *code) {
                NSLog(@"==1=%@",code);
                NSLog(@"==2=%@",user.userId);
                NSLog(@"==3=%@",user.accountname);
                NSLog(@"==4=%@",user.channellevel1);
                NSLog(@"==5=%@",user.channellevel2);
                NSLog(@"==6=%@",user.ssid);
                NSLog(@"==7=%@",user.appId);
            }];
            
        });
    });
}

- (IBAction)setRoleData:(id)sender {
    
    GreenFruit_CustomNativeByte_SDKRoleData *roleData = [[GreenFruit_CustomNativeByte_SDKRoleData alloc] initWithRoleId:@"1001" roleName:@"IOS测试账号" roleLevel:@"1000" zoneId:@"1" zoneName:@"测试一区"];
    
    
    [[OrangeGreenFruit_CustomNativeByte_SDKCreate share_CustomNativeByte_Manager]GreenFruitSettingRoleDataWithRootVC:self roleData:roleData CompletionBlock:^(NSString *code) {
        NSLog(@"上报角色信息返回状态 %@",code);

    }];
    
}

- (IBAction)pay:(id)sender {
    
    
    textBackView = [[UIView alloc]initWithFrame:CGRectMake(0, KHeight/2-80, KWidth, 80)];
    textBackView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:textBackView];
    
    amtTextfield = [[UITextField alloc]initWithFrame:CGRectMake(20, 20, KWidth-120, 40)];
    amtTextfield.placeholder = @"请输入充值金额";
    amtTextfield.keyboardType = UIKeyboardTypeNumberPad;
    amtTextfield.borderStyle = UITextBorderStyleRoundedRect;
    [textBackView addSubview:amtTextfield];
    
    UIButton * ensureBtn = [[UIButton alloc]initWithFrame:CGRectMake(KWidth-80, 20, 60, 40)];
    ensureBtn.backgroundColor = [UIColor brownColor];
    ensureBtn.layer.cornerRadius = 5.0f;
    [ensureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [ensureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [ensureBtn addTarget:self action:@selector(dissMissView) forControlEvents:UIControlEventTouchUpInside];
    [textBackView addSubview:ensureBtn];
    
}

-(void)dissMissView{
    
    [textBackView removeFromSuperview];
    
    NSString * amtString =[NSString stringWithFormat:@"%@",amtTextfield.text];

    NSLog(@"输入金额:%@",amtString);
    
    GreenFruit_CustomNativeByte_SDKPay * pay = [[GreenFruit_CustomNativeByte_SDKPay alloc]initWithGreenFruitOrderName:@"250钻石" GreenFruitOrderDetail:@"250钻石" GreenFruitOrderAmt:amtString consumerId:@"11|MHT_2019021508114852100534_0100003" consumerName:@"11|MHT_2019021508114852100534_0100003" zoneName:@"内网测试服" GreenFruitCurrency:@"0" notifyUrl:@"" productID:ProductID1];
    
//    //平台支付
////    [[MHTSDKCreate share_CustomNativeByte_Manager] mhtPayDataWithRootVC:self pay:pay];

    //    //苹果内购
    
    [[OrangeGreenFruit_CustomNativeByte_SDKCreate share_CustomNativeByte_Manager]GreenFruitPayByStoreIAP:self pay:pay];
    
    NSLog(@"支付按钮咯");
    

    
}

- (IBAction)logout:(id)sender {

    NSLog(@"进入方法");
    
    [[OrangeGreenFruit_CustomNativeByte_SDKCreate share_CustomNativeByte_Manager]GreenFruitLogoutRootVC:self CompletionBlock:^(NSString *code) {
        NSLog(@"退出：%@",code);

    }];
    
}

- (BOOL)prefersStatusBarHidden{
    return NO;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
