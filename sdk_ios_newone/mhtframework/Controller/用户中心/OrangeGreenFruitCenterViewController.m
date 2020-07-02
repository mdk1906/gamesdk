//
//  OrangeGreenFruitCenterViewController.m
//  GreenFruit_CustomNativeByte_SDK
//
//  Created by shuangfei on 2018/2/21.
//  Copyright © 2018年 Hu. All rights reserved.
//

#import "OrangeGreenFruitCenterViewController.h"
#import "OrangeGreenFruitConfig.h"
#import "OrangeMBManager.h"
#import "OrangeNSString+Utils.h"
#import "OrangeAPIParams.h"
#import "OrangeRespondModel.h"
#import "OrangeYYModel.h"
#import "OrangeInfoArchive.h"
#import "OrangeCheckIdentifyModel.h"

@interface OrangeGreenFruitCenterViewController ()<WKNavigationDelegate,WKUIDelegate,WKScriptMessageHandler>

@property (nonatomic, strong) WKWebView *webView;
@end

@implementation OrangeGreenFruitCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.cancel = @"cancel";
    self.webviewHaveLoad = NO;
    self.qqModel = @"";
    self.kefuModel = @"";
    [self setStatusBarBackgroundColor:TabBarColor];
    [self setWebViewConfigation];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //为了不影响其他页面在viewDidDisappear做以下设置
    self.navigationController.navigationBar.translucent = YES;//透明
    [self setStatusBarBackgroundColor:[UIColor clearColor]];
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
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:meUrl] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:5];
    [self removeWebCache];
    //APP调用JavaScript
    WKWebViewConfiguration *conf = [[WKWebViewConfiguration alloc] init];
    NSString *str = [NSString stringWithFormat:@"bindDataForMe('%@')",self.userName];
    WKUserScript *userScript = [[WKUserScript alloc] initWithSource:str injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:true];
    [conf.userContentController addUserScript:userScript];
    [conf.userContentController addScriptMessageHandler:self name:self.cancel];
    [conf.userContentController addScriptMessageHandler:self name:checkIdentityString];
    [conf.userContentController addScriptMessageHandler:self name:collectPacksString];
    [conf.userContentController addScriptMessageHandler:self name:contactServiceString];
    [conf.userContentController addScriptMessageHandler:self name:updatePwdString];
    [conf.userContentController addScriptMessageHandler:self name:accountSecurityString];
    [conf.userContentController addScriptMessageHandler:self name:bandIdentityString];
    [conf.userContentController addScriptMessageHandler:self name:collectPacksCodeString];
    [conf.userContentController addScriptMessageHandler:self name:bandPhoneString];
    [conf.userContentController addScriptMessageHandler:self name:doPwdString];
    [conf.userContentController addScriptMessageHandler:self name:getVerCodeString];
    [conf.userContentController addScriptMessageHandler:self name:doAccountSecurityString];
    [conf.userContentController addScriptMessageHandler:self name:doOpenSchema];
    conf.preferences = [[WKPreferences alloc]init];
    conf.preferences.javaScriptEnabled = YES;
    conf.preferences.javaScriptCanOpenWindowsAutomatically = NO;
    self.webView = [[WKWebView alloc] initWithFrame:[UIScreen mainScreen].bounds configuration:conf];
    self.webView.navigationDelegate = self;
    self.webView.UIDelegate = self;
    [self.webView loadRequest:request];
    [self.view addSubview:self.webView];
    
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
//    NSLog(@"横竖屏布局wkwebviewSize：%@",NSStringFromCGRect([UIScreen mainScreen].bounds));
    [[NSNotificationCenter defaultCenter] postNotificationName:@"FloatingBallAutoEdgeOffSet" object:nil];
    
    if (size.width > size.height) {
        // 横屏布局
        self.webView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    } else {
        // 竖屏布局
        self.webView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    }
}

#pragma mark -- WKNavigationDelegate
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error{
    NSLog(@"无网络");
    [OrangeMBManager show_CustomNativeByte_BriefAlert:@"网络异常" time:1];
    if(!self.webviewHaveLoad){
        [self.navigationController setNavigationBarHidden:NO];
    }
    
//    if(self.navigationController.topViewController == self){
//        [self.navigationController popViewControllerAnimated:YES];
//    }else{
        [self dismissViewControllerAnimated:TRUE completion:nil];
//    }
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation{
    
    [self.navigationController setNavigationBarHidden:YES];
    self.webviewHaveLoad = YES;
    NSString *js1 = [NSString stringWithFormat:@"var str = '%@';var model = JSON.parse(str);",self.giftListModel];
    //调取js代码
    //领取礼包
    
    [webView evaluateJavaScript:js1 completionHandler:^(id object, NSError * _Nullable error) {
        if(error){
            
        }else{
            [webView evaluateJavaScript:@"bindDataForGetgit(model)" completionHandler:^(id object, NSError * _Nullable error) {
                
            }];
        }
    }];
    //联系客服
//    NSString *js2 = [NSString stringWithFormat:@"var str1 ='{\"qList\" : [{\"name\" : \"客服1\", \"value\" : \"3480356017\"},{ \"name\" : \"客服2\",\"value\" : \"3539342189\"}],\"phoneList\":[]}';var model2 = JSON.parse(str1);"];
    NSString *js2 = [NSString stringWithFormat:@"var str1 ='%@,%@';var model2 = JSON.parse(str1);",self.qqModel,self.kefuModel];
    

    [webView evaluateJavaScript:js2 completionHandler:^(id object, NSError * _Nullable error) {
        if(error){

        }else{
            [webView evaluateJavaScript:@"bindDataForCustomer(model2)" completionHandler:^(id object, NSError * _Nullable error) {
                
            }];
        }
    }];
    //身份认证通过后调用js接口,传realName和身份证号
    NSString *method = [NSString stringWithFormat:@"bindDataForApprove('\(%@)','\(%@)')",self.name,self.identifyno];
    [webView evaluateJavaScript:method completionHandler:^(id object, NSError * _Nullable error) {
        
    }];
    //修改密码需要调用js把已经绑定的手机号传给js
    NSString *acountName = self.bindPhoneNumber;
    NSString *method_pas = [NSString stringWithFormat:@"bindDataForSafetyPwd('\(%@)')",acountName];
    [webView evaluateJavaScript:method_pas completionHandler:^(id object, NSError * _Nullable error) {

    }];
    //账号安全,主动调用js的bindDataForSafetyUser方法,将账号对应的手机号传进去
    NSString *acountPhone = self.bindPhoneNumber;
    NSString *method_account = [NSString stringWithFormat:@"bindDataForSafetyUser('(%@)')",acountPhone];
    [webView evaluateJavaScript:method_account completionHandler:^(id object, NSError * _Nullable error) {

    }];
}

//通过接收JS传出消息的name进行捕捉的回调方法
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{//接受到JavaScript返回的信息
    NSLog(@"个人中心:%@",message.name);
    if([message.name isEqualToString:self.cancel]){
//        if(self.navigationController.topViewController == self){
//            [self.navigationController popViewControllerAnimated:YES];
//        }else{
            [self dismissViewControllerAnimated:YES completion:nil];
//        }
    }else if ([message.name isEqualToString: bandIdentityString]){
//        NSLog(@"实名认证的--%@,%@",message.name,message.body);
        
        NSDictionary *dic = [NSString dictionaryWithJsonString:message.body];
        self.name = dic[@"name"];
        self.identifyno = dic[@"search"];
        NSLog(@"进入实名认证了   实名认证参数信息 urlStr:%@",dic);
        //调用实名认证接口
        [OrangeMBManager showLoading];
        
        [OrangeAPIParams requestIdentifyVertifyUserId:self.userid name:self.name identityno:self.identifyno successblock:^(id response) {
//            NSDictionary *element = (NSDictionary*)response;
//            DataModel *dataModel = [DataModel yy_modelWithJSON:element];
            NSLog(@"-拿到实名认证后的数据---%@",response);
            
            NSString *urlStr = (NSString*)dic[@"success"];
           
            NSLog(@"拿到的请求成功后的webView地址:%@",urlStr);
            
            [OrangeMBManager show_CustomNativeByte_BriefAlert:@"实名认证通过" time:1];
            NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:5];
            [self removeWebCache];
            //实名验证成功后，加载webview地址
            [self.webView loadRequest:request];
            
        } failedblock:^(NSError *error) {
            if(error.code == 4){
                [OrangeMBManager show_CustomNativeByte_BriefAlert:@"网络异常" time:1];
            }else{
                [OrangeMBManager show_CustomNativeByte_BriefAlert:@"异常错误" time:1];
            }
        }];
    }else if([message.name isEqualToString:collectPacksCodeString]){
//        NSLog(@"领取礼包的--%@,%@",message.name,message.body);
        NSDictionary *dic = [NSString dictionaryWithJsonString:message.body];
        NSString *awardid = dic[@"awardid"];
        [OrangeAPIParams requestGiftUserId:self.userid awardid:awardid Successblock:^(id response) {
            NSDictionary *element = (NSDictionary*)response;
            GetGiftModel *giftModel = [GetGiftModel yy_modelWithJSON:element];
//            NSLog(@"礼包兑换码：%@,==%@",element,giftModel.content.awardCode);
            
            if(giftModel.code == 200){
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"礼包兑换码已复制" message:giftModel.content.awardCode preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self getGitList];
                    [self.webView reload];
                }];
                UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
                pasteboard.string = giftModel.content.awardCode;
                [alert addAction:alertAction];
                [self presentViewController:alert animated:YES completion:nil];
            }else{
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"礼包兑换码" message:@"礼包领取失败" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
                [alert addAction:alertAction];
                [self presentViewController:alert animated:YES completion:nil];
            }
            
        } failedblock:^(NSError *error) {
            if(error.code == 4){
                [OrangeMBManager show_CustomNativeByte_BriefAlert:@"网络异常" time:1];
            }else{
                [OrangeMBManager show_CustomNativeByte_BriefAlert:@"异常错误" time:1];
            }
        }];
        
    }else if([message.name isEqualToString:bandPhoneString]){
        //修改密码的绑定手机号按钮的点击事件,已做处理
        NSLog(@"修改手机号--,%@,%@",message.name,message.body);
        if(self.bindPhoneViewBlock){
            self.bindPhoneViewBlock();
        }
    }else if([message.name isEqualToString:doPwdString]){
        NSDictionary *dic = [NSString dictionaryWithJsonString:message.body];
        NSString *vcode = dic[@"verCode"];
        NSString *pwd = dic[@"pwd"];
        [OrangeAPIParams requestUpdatePassword:pwd username:self.userName vcode:vcode Successblock:^(id response) {
            NSDictionary *element = (NSDictionary*)response;
            DataModel *dataModel = [DataModel yy_modelWithJSON:element];
            if(dataModel.code == 200){
                [OrangeMBManager show_CustomNativeByte_BriefAlert:@"修改密码成功" time:1];
                [OrangeInfoArchive updateInfo:nil loginPwd:pwd];
                NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:meUrl] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:5];
                [self removeWebCache];
                [self.webView loadRequest:request];
            }else{
                if(dataModel.code == 510){
                    [OrangeMBManager show_CustomNativeByte_BriefAlert:@"验证码无效" time:1];
                }
            }
            
        } failedblock:^(NSError *error) {
            if(error.code == 4){
                [OrangeMBManager show_CustomNativeByte_BriefAlert:@"网络异常" time:1];
            }else{
                [OrangeMBManager show_CustomNativeByte_BriefAlert:@"异常错误" time:1];
            }
        }];
    }else if([message.name isEqualToString:getVerCodeString]){
        NSString *jsStr = @"document.getElementById('name').value";
        NSLog(@"获取短信验证码:%@",jsStr);
        [self.webView evaluateJavaScript:jsStr completionHandler:^(id object, NSError * _Nullable error) {
            NSString *phoneStr = (NSString*)object;
            NSLog(@"phoneStr:%@",phoneStr);
            if(phoneStr == nil || [phoneStr isEqualToString:@""]){
//                [OrangeMBManager showLoading];
                [OrangeAPIParams requestUsername:self.userName successblock:^(id response) {
                    NSDictionary *element = (NSDictionary*)response;
                    DataModel *dataModel = [DataModel yy_modelWithJSON:element];
                    if(dataModel.code == 200){
                        [OrangeMBManager show_CustomNativeByte_BriefAlert:@"获取验证码成功" time:1];
                    }else{
                        if(dataModel.code == 512){
                            [OrangeMBManager show_CustomNativeByte_BriefAlert:@"验证码发送失败" time:1];
                        }else if(dataModel.code == 511){
                            [OrangeMBManager show_CustomNativeByte_BriefAlert:@"验证码发送间隔未到一分钟" time:1];
                        }
                        
                    }
                } failedblock:^(NSError *error) {
                    if(error.code == 4){
                        [OrangeMBManager show_CustomNativeByte_BriefAlert:@"网络异常" time:1];
                    }else{
                        [OrangeMBManager show_CustomNativeByte_BriefAlert:@"异常错误" time:1];
                    }
                }];
            }
        }];
    }else{
        NSString *str = (NSString*)message.body;
        NSDictionary *dic = [NSString dictionaryWithJsonString:str];
        __block NSString *urlString;
        if([message.name isEqualToString:checkIdentityString]){
            //先判断是否实名认证了  ****
            [OrangeAPIParams requestCheckIdentifyUserid:self.userid successblock:^(id response) {
                NSDictionary *element = (NSDictionary*)response;
                if([element[@"code"] integerValue] == 528){
                    urlString = (NSString*)dic[@"failed"];
                }else{
                    urlString = (NSString*)dic[@"success"];
                    OrangeCheckIdentifyModel *model = [OrangeCheckIdentifyModel yy_modelWithJSON:element];
                    self.name = model.content.realName;
                    self.identifyno = model.content.identityNo;
                }
                NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:5];
                [self removeWebCache];
                [self.webView loadRequest:request];
            } failedblock:^(NSError *error) {
                NSLog(@"实名认证错误");
            }];
        }else if([message.name isEqualToString:collectPacksString]){
            NSLog(@"领取礼包");
            [self getGitList];
            urlString =  dic[@"jumpurl"];
            NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:5];
            [self removeWebCache];
            [self.webView loadRequest:request];
            
        }else if ([message.name isEqualToString:contactServiceString]){
            NSLog(@"联系客服");
            [self getPhoneList];
            [self settingKefuPhone];
            urlString =  dic[@"jumpurl"];
            
            NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:5];
            [self removeWebCache];
            [self.webView loadRequest:request];
        }else if ([message.name isEqualToString:updatePwdString]){
            NSLog(@"修改密码");
            [OrangeAPIParams requestCenterCheckPhoneCondition:self.userid SuccessBlock:^(id response) {
                NSDictionary *element = (NSDictionary*)response;
                PhoneModel *phoneModel = [PhoneModel yy_modelWithJSON:element];
                if(phoneModel.code == 514){
                    urlString =  dic[@"failed"];
                    self.bindPhoneNumber = @"";
                }else{
                    urlString =  dic[@"success"];
                    self.bindPhoneNumber = phoneModel.content.phone;
                }
                NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:5];
                [self removeWebCache];
                [self.webView loadRequest:request];
            } failedblock:^(NSError *error) {
                
            }];
        }
        else if ([message.name isEqualToString:doAccountSecurityString]){
            NSLog(@"修改绑定手机号:%@",dic);
            NSString *vcode = dic[@"pwd"];
            NSString *phone = dic[@"verCode"];
            urlString =  dic[@"success"];
            NSLog(@"修改绑定手机号 dic:%@",dic);
            urlString =  dic[@"success"];
            NSLog(@"修改绑定手机号 success:%@",urlString);
            [OrangeAPIParams requestBindPhone:phone vcode:vcode Successblock:^(id response) {
                NSDictionary *element = (NSDictionary*)response;
                OrangeRespondModel *modal = [OrangeRespondModel yy_modelWithJSON:element];
                if(modal.code == 200){
                    [OrangeMBManager show_CustomNativeByte_BriefAlert:@"绑定成功" time:1];
                    urlString =  dic[@"success"];
                    
                    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:5];
                    [self removeWebCache];
                    [self.webView loadRequest:request];
                    
                }else{
                    [OrangeMBManager show_CustomNativeByte_BriefAlert:@"绑定失败" time:1];
                }
            } failedblock:^(NSError *error) {
                if(error.code == 4){
                    [OrangeMBManager show_CustomNativeByte_BriefAlert:@"网络异常" time:1];
                }else{
                    [OrangeMBManager show_CustomNativeByte_BriefAlert:@"异常错误" time:1];
                }
            }];
        }
        else if([message.name isEqualToString:doOpenSchema]){
            NSString *schema = dic[@"schema"];
            NSLog(@"打开第三方应用,schema:%@",schema);
            
            NSURL * url = [NSURL URLWithString:schema];
            [[UIApplication sharedApplication] openURL:url];
            
            NSLog(@"打开QQ --");
        }
        else{
            NSLog(@"账号安全");
            [OrangeAPIParams requestCenterCheckPhoneCondition:self.userid SuccessBlock:^(id response) {
                NSDictionary *element = (NSDictionary*)response;
                PhoneModel *phoneModel = [PhoneModel yy_modelWithJSON:element];
                if(phoneModel.code == 514){//调出绑定手机页面
                    if(self.bindPhoneViewBlock){
                        self.bindPhoneViewBlock();
                    }
                }else{
                    self.bindPhoneNumber = phoneModel.content.phone;
                    urlString =  dic[@"success"];
                    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:5];
                    [self removeWebCache];
                    [self.webView loadRequest:request];
                }
                
            } failedblock:^(NSError *error) {
                
            }];
        }
    }
}

- (void)getGitList{
    [OrangeAPIParams requestGiftListSuccessblock:^(id response) {
        NSDictionary *element = (NSDictionary*)response;
        if([element[@"code"] integerValue] == 200){
            NSData *data = [NSJSONSerialization dataWithJSONObject:element[@"content"] options:NSJSONWritingPrettyPrinted error:nil];
            NSString *JSONString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            self.giftListModel = JSONString;
            self.giftListModel=[self.giftListModel stringByReplacingOccurrencesOfString:@" " withString:@""];
            self.giftListModel=[self.giftListModel stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        }
    } failedblock:^(NSError *error) {
        NSLog(@"获取礼包列表错误");
    }];
}

- (void)getPhoneList{
    [OrangeAPIParams requestSettingPhoneSuccessblock:^(id response) {
        NSDictionary *element = (NSDictionary*)response;
        if([element[@"code"] integerValue] == 200){
            NSData *data = [NSJSONSerialization dataWithJSONObject:element[@"content"] options:NSJSONWritingPrettyPrinted error:nil];
            NSString *JSONString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            self.kefuModel = JSONString;
            self.kefuModel = [self.kefuModel substringFromIndex:1];
            self.kefuModel=[self.kefuModel stringByReplacingOccurrencesOfString:@" " withString:@""];
            self.kefuModel=[self.kefuModel stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        }
    } failedblock:^(NSError *error) {
        NSLog(@"%@",error);
        if(error.code == 4){
            [OrangeMBManager show_CustomNativeByte_BriefAlert:@"网络异常" time:1];
        }else{
            [OrangeMBManager show_CustomNativeByte_BriefAlert:@"异常错误" time:1];
        }
    }];
}

- (void)settingKefuPhone{
    [OrangeAPIParams requestSettingQQSuccessblock:^(id response) {
        NSDictionary *element = (NSDictionary*)response;
        if([element[@"code"] integerValue] == 200){
            NSData *data = [NSJSONSerialization dataWithJSONObject:element[@"content"] options:NSJSONWritingPrettyPrinted error:nil];
            NSString *JSONString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            self.qqModel = JSONString;
            self.qqModel = [self.qqModel substringToIndex:self.qqModel.length-1];
            self.qqModel=[self.qqModel stringByReplacingOccurrencesOfString:@" " withString:@""];
            self.qqModel=[self.qqModel stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        }
    } failedblock:^(NSError *error) {
        NSLog(@"%@",error);
        if(error.code == 4){
            [OrangeMBManager show_CustomNativeByte_BriefAlert:@"网络异常" time:1];
        }else{
            [OrangeMBManager show_CustomNativeByte_BriefAlert:@"异常错误" time:1];
        }
    }];
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
