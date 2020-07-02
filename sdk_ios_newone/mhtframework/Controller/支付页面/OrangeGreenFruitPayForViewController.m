//
//  OrangeGreenFruitPayForViewController.m
//  GreenFruit_CustomNativeByte_SDK
//
//  Created by shuangfei on 2018/2/16.
//  Copyright © 2018年 Hu. All rights reserved.
//

#import "OrangeGreenFruitPayForViewController.h"
#import "OrangeGreenFruitConfig.h"
#import "OrangeNSString+Utils.h"
#import "OrangeMBManager.h"
#import "OrangeGreenFruitDealWithBase64.h"

@interface OrangeGreenFruitPayForViewController ()<UIWebViewDelegate>
//@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) JSContext *context;
@property (nonatomic, copy) NSString *cancel;
@end

@implementation OrangeGreenFruitPayForViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.cancel = @"goBackGame";
    self.view.backgroundColor = [UIColor whiteColor];
    UINavigationBar *bar = [UINavigationBar appearance];
    bar.barTintColor = ThemeColor;
    //    [self setStatusBarBackgroundColor:ThemeColor];
    bar.tintColor = [UIColor whiteColor];
    [bar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    UIImage *backImg = [UIImage imageNamed:GreenFruitImage(@"Orange返回_2")];
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setBackgroundImage:backImg forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(0, 0, 20, 20);
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
    [self setWebViewConfigation];
    
    NSString *url = [NSString getWebUrlStr:payBaseUrl params:self.payInfo.getDictionary];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:5];
    [self removeWebCache];
    [self.webView loadRequest:request];
//    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Review" ofType:@"html"]]]];
    self.webView.delegate = self;
    //    self.webView.navigationDelegate = self;
    //    self.webView.UIDelegate = self;
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

- (void)setWebViewConfigation{
//    WKWebViewConfiguration *conf = [[WKWebViewConfiguration alloc] init];
//    conf.preferences = [[WKPreferences alloc]init];
//    conf.preferences.javaScriptEnabled = YES;
//    conf.preferences.javaScriptCanOpenWindowsAutomatically = NO;
//    [conf.userContentController addScriptMessageHandler:self name:self.cancel];?
//    self.webView = [[WKWebView alloc] initWithFrame:[UIScreen mainScreen].bounds configuration:conf];
    self.webView = [[UIWebView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.webView.backgroundColor = [UIColor whiteColor];
//    self.bridge=[WebViewJavascriptBridge bridgeForWebView:self.webView];
//    [self.bridge setWebViewDelegate:self];
    [self.view addSubview:self.webView];
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
//    NSLog(@"webViewDidFinishLoad");
    self.context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    //设置异常处理
    self.context.exceptionHandler = ^(JSContext *context, JSValue *exception) {
        [JSContext currentContext].exception = exception;
//        NSLog(@"exception:%@",exception);
    };
    //    self.context[@"OC"] = self;
    __weak typeof(self) weakSealf = self;
    self.context[@"goBackGame"] = ^{
        [weakSealf goBackGame];
    };
}

- (void)goBackGame{
    dispatch_async(dispatch_get_main_queue(), ^{
        [OrangeMBManager hideAlert];
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    });
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
//    NSLog(@"横竖屏布局wkwebviewSize：%@",NSStringFromCGRect([UIScreen mainScreen].bounds));
    [[NSNotificationCenter defaultCenter] postNotificationName:@"FloatingBallAutoEdgeOffSet" object:nil];
    if (size.width > size.height) {
        // 横屏布局
        self.webView.frame = CGRectMake(0, 0, self.view.frame.size.height, self.view.frame.size.width);
    } else {
        // 竖屏布局
        self.webView.frame = CGRectMake(0, 0, self.view.frame.size.height, self.view.frame.size.width);
    }
}

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

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
//    NSLog(@"%@",message.name);
    [OrangeMBManager hideAlert];
    if ([message.name isEqualToString:self.cancel]) {
        [self goBack];
    }
}

//收到服务器重定向请求后调用
//- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation{
//    NSLog(@"收到服务器重定向请求后调用%@",navigation);
//}

// 在收到响应开始加载后，决定是否跳转
//- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
//    NSLog(@"在收到响应开始加载后，决定是否跳转,%@",navigationResponse.response);
//    decisionHandler(WKNavigationResponsePolicyAllow);
//}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
//    NSString *requestString = [[[request URL]  absoluteString] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding ];
    NSURL *url = [request URL];
    if([[url scheme] isEqualToString:self.cancel]){
        [self goBack];
    }
    NSString* requestUrl = url.absoluteString;
    
    if ([requestUrl containsString:@"alipays://"] || [requestUrl containsString:@"alipay://"] || [requestUrl containsString:@"weixin:"]) {
        [[UIApplication sharedApplication] openURL:url];
    }

    
    return YES;
}

//- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
//    NSLog(@"decidePolicyForNavigationAction===%@",navigationAction.request.URL.absoluteURL);
//    NSURL *requestUrl = navigationAction.request.URL.absoluteURL;
//    if(!requestUrl){
//        return;
//    }
//    if ([requestUrl.absoluteString containsString:@"alipays:"]||[requestUrl.absoluteString containsString:@"alipay:"] || [requestUrl.absoluteString containsString:@"weixin:"] ) {
//        NSLog(@"准备打开微信或支付宝客户端");
//        decisionHandler(WKNavigationActionPolicyCancel);
//        if ([[UIApplication sharedApplication] canOpenURL:navigationAction.request.URL]) {
//            NSLog(@"打开微信或支付宝客户端");
//            [[UIApplication sharedApplication] openURL:navigationAction.request.URL options:@{UIApplicationOpenURLOptionUniversalLinksOnly: @NO} completionHandler:^(BOOL success) {
//
//            }];
//        }
//    }else{
//        decisionHandler(WKNavigationActionPolicyAllow);
//        return;
//    }
//}

- (void)goBack{
    [OrangeMBManager hideAlert];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:login_notification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:logout_notification object:nil];
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

