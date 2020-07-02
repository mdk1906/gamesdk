//
//  OrangeGreenFruitUserCenterNewViewController.m
//  GreenFruitframework
//
//  Created by 张 on 2018/12/10.
//  Copyright © 2018年 Hu. All rights reserved.
//  

#import "OrangeGreenFruitUserCenterNewViewController.h"
#import "OrangeGreenFruitConfig.h"
#import "OrangeMBManager.h"
#import "OrangeNSString+Utils.h"
#import "OrangeAPIParams.h"
#import "OrangeRespondModel.h"
#import "OrangeYYModel.h"
#import "OrangeInfoArchive.h"
#import "OrangeCheckIdentifyModel.h"
#import "OrangeGreenFruitBundle.h"

@interface OrangeGreenFruitUserCenterNewViewController ()<WKNavigationDelegate,WKUIDelegate,WKScriptMessageHandler,UIScrollViewDelegate>
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) UIView * topView;
@property (nonatomic, copy) NSString *cancel;

@end

@implementation OrangeGreenFruitUserCenterNewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
//    self.title = @"个人中心";
    
    self.view.backgroundColor = KGreenColor;
    
    self.cancel = @"cancel";

    [self setStatusBarBackgroundColor:[UIColor clearColor]];
    
    [self setWebViewConfigation];
    
    
    [self configView];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeRotate:) name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
    
}
-(void)configView{
    
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (orientation == UIInterfaceOrientationPortrait
        || orientation == UIInterfaceOrientationPortraitUpsideDown){
        NSLog(@"进来时是竖屏");
        [self setWidth:kScreenWidth];
        [self setHeight:kScreenHeight];
        //        [self verticalUI];

        self.view.center = CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height/2);
    }
    else{
        if(IS_IPHONE){
            NSLog(@"设备为手机");
            //    [self horizontalUI];
            [self setWidth:kScreenWidth];
            [self setHeight:kScreenHeight];

            self.view.center = CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height/2);
        }else{
            NSLog(@"设备为ipad");
            //     [self verticalUI];
            [self setWidth:kScreenWidth];
            [self setHeight:kScreenHeight];

            self.view.center = CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height/2);
        }
    }
}

#pragma mark -- 适配横屏竖屏
- (void)changeRotate:(NSNotification*)notification{
    //    [self createBorder];
    [self changeOrientation];
    
}

- (void)changeOrientation{
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (orientation == UIInterfaceOrientationPortrait
        || orientation == UIInterfaceOrientationPortraitUpsideDown) {
        //竖屏
        NSLog(@"竖屏");
        [self verticalUI];
        [self setWidth:kScreenWidth];
        [self setHeight:kScreenHeight];
        
        self.view.center = CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height/2);
        
    } else {
        //横屏
        NSLog(@"横屏");
        if(IS_IPHONE){
            NSLog(@"设备为手机");
            [self horizontalUI];
            [self setWidth:kScreenWidth];
            [self setHeight:kScreenHeight];
            self.topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 64)];
            self.view.center = CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height/2);
        }else{
            NSLog(@"设备为ipad");
            [self verticalUI];
            [self setWidth:kScreenWidth];
            [self setHeight:kScreenHeight];
            self.topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 64)];
            self.view.center = CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height/2);
        }
    }
}

-(void)verticalUI{
    NSLog(@"进行竖屏适配");
    
}

-(void)horizontalUI{
    NSLog(@"进行横屏适配");
}

- (void)setWidth:(CGFloat)width
{
    CGRect frame = self.view.frame;
    frame.size.width = width;
    self.view.frame = frame;
}

- (void)setHeight:(CGFloat)height {
    CGRect frame = self.view.frame;
    frame.size.height = height;
    self.view.frame = frame;
}

- (void)setSize:(CGSize)size {
    CGRect frame = self.view.frame;
    frame.size = size;
    self.view.frame = frame;
}



- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //为了不影响其他页面在viewDidDisappear做以下设置
    self.navigationController.navigationBar.translucent = NO;//透明
    [self setStatusBarBackgroundColor:[UIColor clearColor]];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
    
}

//设置状态栏颜色
- (void)setStatusBarBackgroundColor:(UIColor *)color {
    
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.backgroundColor = color;
    }
}

- (BOOL)prefersStatusBarHidden{
    return NO;
}

- (void)setWebViewConfigation {
    
    self.topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 64)];
    self.topView.backgroundColor = KGreenColor;
    [self.view addSubview:self.topView];
    
    UIButton * goBackButton = [[UIButton alloc]initWithFrame:CGRectMake(20, 30, 40, 20)];
    [goBackButton setTitle:@"返回" forState:UIControlStateNormal];
    goBackButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [goBackButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [goBackButton addTarget:self action:@selector(gobackMethod) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:goBackButton];

    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.webViewUrl] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:5];
    //*** 注释了清除缓存的代码
    [self removeWebCache];
    
    NSHTTPCookieStorage * cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
//    for (NSHTTPCookie * cookie in [cookieJar cookies]) {
//        NSLog(@"cookie%@",cookie);
//    }
    
    //APP调用JavaScript
    WKWebViewConfiguration *conf = [[WKWebViewConfiguration alloc] init];
    [conf.userContentController addScriptMessageHandler:self name:self.cancel];
    [conf.userContentController addScriptMessageHandler:self name:doOpenSchema];
    conf.preferences.javaScriptCanOpenWindowsAutomatically = YES;
    self.webView = [[WKWebView alloc] initWithFrame:[UIScreen mainScreen].bounds configuration:conf];
    self.webView.frame = CGRectMake(0, 64, kScreenWidth, kScreenHeight-64);
    self.webView.navigationDelegate = self;
    self.webView.UIDelegate = self;
    self.webView.scrollView.delegate = self;
    [self.webView sizeToFit];
    [self.webView loadRequest:request];
    self.webView.scrollView.scrollEnabled = YES;
    [self.view addSubview:self.webView];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    //    NSLog(@"横竖屏布局wkwebviewSize：%@",NSStringFromCGRect([UIScreen mainScreen].bounds));
    [[NSNotificationCenter defaultCenter] postNotificationName:@"FloatingBallAutoEdgeOffSet" object:nil];
    if (size.width > size.height) {
        self.topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 64)];
        // 横屏布局
        self.webView.frame = CGRectMake(0, 64, self.view.frame.size.height, self.view.frame.size.width-64);
    } else {
        self.topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenHeight, 64)];

        // 竖屏布局
        self.webView.frame = CGRectMake(0, 64, self.view.frame.size.height, self.view.frame.size.width-64);
    }
}


#pragma mark -- WKUIDelegate代理事件
// 页面开始加载时调用
-(void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    NSLog(@"页面开始加载时调用 %@",webView);
 
}
// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    NSLog(@"当内容开始返回时调用 %@",webView);
   
}
// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{//这里修改导航栏的标题，动态改变
//    self.title = webView.title;
    
}
// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation{
    
}
// 接收到服务器跳转请求之后再执行
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation{
    NSLog(@"接收到服务器跳转请求之后再执行 %@",webView);

}
// 在收到响应后，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    
    NSLog(@"在收到响应后，决定是否跳转webview:%@",webView);
    NSLog(@"在收到响应后，决定是否跳转响应信息:%@",navigationResponse);
    
    WKNavigationResponsePolicy actionPolicy = WKNavigationResponsePolicyAllow;
    //这句是必须加上的，不然会异常
    decisionHandler(actionPolicy);
    
}
// 在发送请求之前，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    
//    self.title = webView.title;
    
    WKNavigationActionPolicy actionPolicy = WKNavigationActionPolicyAllow;
    
    
    if (navigationAction.navigationType==WKNavigationTypeBackForward) {//判断是返回类型
        
        //同时设置返回按钮和关闭按钮为导航栏左边的按钮 这里可以监听左滑返回事件，仿微信添加关闭按钮。
        //***
//        self.navigationItem.leftBarButtonItems = @[self.backBtn, self.closeBtn];
        //可以在这里找到指定的历史页面做跳转
        //        if (webView.backForwardList.backList.count>0) {                                  //得到栈里面的list
        //            NSLog(@"%@",webView.backForwardList.backList);
        //            NSLog(@"%@",webView.backForwardList.currentItem);
        //            WKBackForwardListItem * item = webView.backForwardList.currentItem;          //得到现在加载的list
        //            for (WKBackForwardListItem * backItem in webView.backForwardList.backList) { //循环遍历，得到你想退出到
        //                //添加判断条件
        //                [webView goToBackForwardListItem:[webView.backForwardList.backList firstObject]];
        //            }
        //        }
    }
    //这句是必须加上的，不然会异常
    decisionHandler(actionPolicy);
}

#pragma mark -- js调用OC代码段实现期望功能 ！
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    
    NSLog(@"进入 js调用OC代码回调：%@",message);
    
    NSLog(@"body:%@",message.body);
    NSDictionary *dic = [NSString dictionaryWithJsonString:message.body];
    NSLog(@"--拿回的信息:--%@",dic);
    
    if ([message.name isEqualToString:doOpenSchema]){
        
        NSString *schema = dic[@"schema"];
        NSLog(@"打开第三方应用,schema:%@",schema);
        
        NSURL * url = [NSURL URLWithString:schema];
        [[UIApplication sharedApplication] openURL:url];
        
    }
    else if ([message.name isEqualToString:self.cancel]){
        [self dismissViewControllerAnimated:YES completion:nil];
    }
 
}

#pragma mark --- WKUIDelegate代理事件,主要实现与js的交互
//显示一个JS的Alert（与JS交互）
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    NSLog(@"弹窗alert");
    NSLog(@"1%@",message);
    NSLog(@"2%@",frame);
    completionHandler();
}

//弹出一个输入框（与JS交互的）
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * __nullable result))completionHandler{
    NSLog(@"弹窗输入框");
    NSLog(@"11%@",prompt);
    NSLog(@"22%@",defaultText);
    NSLog(@"33%@",frame);
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:prompt message:defaultText preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *a1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        //这里必须执行不然页面会加载不出来
        completionHandler(@"");
    }];
    UIAlertAction *a2 = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"%@",
             [alert.textFields firstObject].text);
        completionHandler([alert.textFields firstObject].text);
    }];
    [alert addAction:a1];
    [alert addAction:a2];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        NSLog(@"%@",textField.text);
    }];
    [self presentViewController:alert animated:YES completion:nil];
}

//显示一个确认框（JS的）
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler{
    NSLog(@"弹窗确认框");
    NSLog(@"111%@",message);
    NSLog(@"222%@",frame);
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:message message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(NO);
    }];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}


//-(void)backNative{
//    //判断是否有上一层H5页面
//    if ([self.webView canGoBack]) {
//        //如果有则返回
//        [self.webView goBack];
//        //同时设置返回按钮和关闭按钮为导航栏左边的按钮
//        self.navigationItem.leftBarButtonItems = @[self.backBtn, self.closeBtn];
//    } else {
//        [self closeNative];
//    }
//}


//清除缓存
- (void)removeWebCache{
    NSDate *date = [[NSDate alloc] initWithTimeIntervalSince1970:0];
    if(@available(iOS 9.0, *)){
        NSSet *websiteDataTypes = [WKWebsiteDataStore allWebsiteDataTypes];
        [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:date completionHandler:^{
            NSLog(@"清空缓存完成");
        }];
    }else{
        NSString *libraryPath = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES)[0];
        NSString *cookiesFolderPath = [libraryPath stringByAppendingString:@"/Cookies"];
        [[NSFileManager defaultManager] removeItemAtPath:cookiesFolderPath error:nil];
    }
}

-(void)gobackMethod{
    if (self.notificationBlock) {
        self.notificationBlock();
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
