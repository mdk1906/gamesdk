//
//  GreenFruitFastFeelViewBlackCustomControl.m
//  GreenFruitframework
//
//  Created by 张 on 2018/12/3.
//  Copyright © 2018年 Hu. All rights reserved.
//

#import "GreenFruitFastFeelViewBlackCustomControl.h"
#import "OrangeAPIParams.h"
#import "OrangeRegistFastModel.h"
#import "OrangeMBManager.h"
#import "OrangeYYModel.h"
#import <Photos/Photos.h>
#import "OrangeInfoArchive.h"
#import "OrangeGreenFruitConfig.h"
#import "GreenFruitBoundPhoneViewBlackCustomControl.h"
#import "OrangeGreenFruitBundle.h"
#import "OrangeNSString+Utils.h"
#import "OrangeUIImageView+MHImageWebCache.h"

#import <TTTracker/TTTracker.h>
#import <TTTracker/TTTracker+Game.h>
#import <TTTracker/TTInstallIDManager.h>

@interface GreenFruitFastFeelViewBlackCustomControl()<UITextFieldDelegate>
{
    CGPoint historyPoint;
}
@property (nonatomic,strong)GreenFruitBoundPhoneViewBlackCustomControl * boundPhoneView;
@property (nonatomic,strong)GreenFruit_CustomNativeByte_SDKUser *users;
@property (nonatomic,strong)OrangeRespondModel *models;
@property (nonatomic,retain)NSMutableDictionary *loginDic;
@property (nonatomic,retain)NSString * componentStr;//拿到判断是否跳转实名验证的信息
@property (nonatomic,retain)NSString * textfieldName;
@end

@implementation GreenFruitFastFeelViewBlackCustomControl

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    self.ensureBtn.layer.cornerRadius = 20.0f;
    
    self.componentStr = @"";
    
    [self configView];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeRotate:) name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
    
    //注册观察键盘的变化
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

}

-(void)configView{
    self.accountTextfield.delegate = self;
    self.passwordTextfield.delegate = self;
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    self.textfieldName = @"1";
    
    NSString * publicPath = User_Defaults_Get(@"publicImgPath");
    UIImage * getImage = [UIImage imageWithContentsOfFile:publicPath];
    self.logoImageView.image = getImage;
    
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (orientation == UIInterfaceOrientationPortrait
        || orientation == UIInterfaceOrientationPortraitUpsideDown){
        [self setWidth:300];
        [self setHeight:330];
        //        [self verticalUI];
        self.accountBackImgView.frame = CGRectMake(self.accountBackImgView.frame.origin.x, self.accountBackImgView.frame.origin.y, self.accountBackImgView.bounds.size.width, 40);
        self.passwordBackImgView.frame = CGRectMake(self.passwordBackImgView.frame.origin.x, self.passwordBackImgView.frame.origin.y, self.passwordBackImgView.bounds.size.width, 40);

        self.center = CGPointMake(self.superview.bounds.size.width/2, self.superview.bounds.size.height/2);
    }
    else{
        if(IS_IPHONE){
            [self setWidth:400];
            [self setHeight:320];
            self.accountBackImgView.frame = CGRectMake(self.accountBackImgView.frame.origin.x, self.accountBackImgView.frame.origin.y, self.accountBackImgView.bounds.size.width, 50);
            self.passwordBackImgView.frame = CGRectMake(self.passwordBackImgView.frame.origin.x, self.passwordBackImgView.frame.origin.y, self.passwordBackImgView.bounds.size.width, 50);
            self.center = CGPointMake(self.superview.bounds.size.width/2, self.superview.bounds.size.height/2);
        }else{
            [self setWidth:400];
            [self setHeight:340];
            self.accountBackImgView.frame = CGRectMake(self.accountBackImgView.frame.origin.x, self.accountBackImgView.frame.origin.y, self.accountBackImgView.bounds.size.width, 50);
            self.passwordBackImgView.frame = CGRectMake(self.passwordBackImgView.frame.origin.x, self.passwordBackImgView.frame.origin.y, self.passwordBackImgView.bounds.size.width, 50);
            self.center = CGPointMake(self.superview.bounds.size.width/2, self.superview.bounds.size.height/2);
        }
    }
}

#pragma mark -- 适配横屏竖屏
- (void)changeRotate:(NSNotification*)notification{
    [self changeOrientation];
    
}

- (void)changeOrientation{
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (orientation == UIInterfaceOrientationPortrait
        || orientation == UIInterfaceOrientationPortraitUpsideDown) {
        //竖屏
        [self verticalUI];
        [self setWidth:300];
        [self setHeight:330];
        self.accountBackImgView.frame = CGRectMake(self.accountBackImgView.frame.origin.x, self.accountBackImgView.frame.origin.y, self.accountBackImgView.bounds.size.width, 40);
        self.passwordBackImgView.frame = CGRectMake(self.passwordBackImgView.frame.origin.x, self.passwordBackImgView.frame.origin.y, self.passwordBackImgView.bounds.size.width, 40);
        self.center = CGPointMake(self.superview.bounds.size.width/2, self.superview.bounds.size.height/2);
        
    } else {
        //横屏
        if(IS_IPHONE){
            [self horizontalUI];
            [self setWidth:400];
            [self setHeight:320];
            self.accountBackImgView.frame = CGRectMake(self.accountBackImgView.frame.origin.x, self.accountBackImgView.frame.origin.y, self.accountBackImgView.bounds.size.width, 50);
            self.passwordBackImgView.frame = CGRectMake(self.passwordBackImgView.frame.origin.x, self.passwordBackImgView.frame.origin.y, self.passwordBackImgView.bounds.size.width, 50);
            self.center = CGPointMake(self.superview.bounds.size.width/2, self.superview.bounds.size.height/2);
        }else{
            [self verticalUI];
            [self setWidth:400];
            [self setHeight:340];
            self.center = CGPointMake(self.superview.bounds.size.width/2, self.superview.bounds.size.height/2);
        }
    }
}

-(void)verticalUI{

    
}

-(void)horizontalUI{
    

}

- (void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

#pragma mark -- 键盘弹出，视图动态上移
//键盘回收
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    for(UIView *view in self.subviews)
    {
        [view resignFirstResponder];
    }
}

//移动UIView
-(void)keyboardWillShow:(NSNotification *)note
{
    
    historyPoint = CGPointMake(self.center.x, self.center.y);
    
    //获取键盘高度，在不同设备上，以及中英文下是不同的
    CGFloat kbHeight = [[note.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    
    
    //计算出键盘顶端到inputTextView panel底端的距离(加上自定义的缓冲距离INTERVAL_KEYBOARD)
    //    CGFloat offset = (self.identityNumbertextfield.frame.origin.y+self.identityNumbertextfield.frame.size.height+10) - (self.frame.size.height - kbHeight);
    CGFloat offset;
    if ([self.textfieldName isEqualToString:@"1"]) {
        offset = (self.accountTextfield.frame.origin.y+self.accountTextfield.frame.size.height+20) - (kScreenHeight - kbHeight);
    }
    else if ([self.textfieldName isEqualToString:@"2"]){
        offset = (self.passwordTextfield.frame.origin.y+self.passwordTextfield.frame.size.height+20) - (kScreenHeight - kbHeight);
    }
    else{
        offset = (self.accountTextfield.frame.origin.y+self.accountTextfield.frame.size.height+20) - (kScreenHeight - kbHeight);
        
    }
    // 取得键盘的动画时间，这样可以在视图上移的时候更连贯
    double duration = [[note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    //将视图上移计算好的偏移
    if(offset > 0) {
        [UIView animateWithDuration:duration animations:^{
            self.frame = CGRectMake(self.frame.origin.x, -offset, self.frame.size.width, self.frame.size.height);
        }];
    }
    
}

-(void)keyboardWillHide:(NSNotification *)note
{
    self.center = historyPoint;
    
    // 键盘动画时间
    double duration = [[note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    //视图下沉恢复原状
    [UIView animateWithDuration:duration animations:^{
        self.center = CGPointMake(kScreenWidth/2, kScreenHeight/2);
    }];
    
}

#pragma mark ---- 键盘代理

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if (textField == self.accountTextfield) {
        self.textfieldName = @"1";
    }else if (textField == self.passwordTextfield){
        self.textfieldName = @"2";
    }else{
        
    }
}

//返回
- (IBAction)returnBackMethod:(id)sender {
    if (self.goBackClickedBlock) {
        self.goBackClickedBlock();
    }
}

//确认按钮
- (IBAction)ensureMethod:(id)sender {
    
    [self endEditing:YES];

    NSString * userName = [NSString stringWithFormat:@"%@",self.accountTextfield.text];
    NSString * passWord = [NSString stringWithFormat:@"%@",self.passwordTextfield.text];
    
    if(![NSString isValidAccount:userName] || ![NSString isValidPassword:passWord]){
        [OrangeMBManager show_CustomNativeByte_BriefAlert:@"请输入正确的用户名和密码" time:1];
        return;
    }
    
    [self goToRegistRealAccount:userName password:passWord];
    
}

//拿到快速注册的账号和密码后，真正去注册为账号
- (void)goToRegistRealAccount:(NSString*)username password:(NSString*)password{
    
    [OrangeAPIParams requestFastRegisterStep2Username:username password:password SuccessBlock:^(id response) {
        [OrangeMBManager hideAlert];
        NSDictionary *element = (NSDictionary*)response;
        OrangeRegistFastModel *model = [OrangeRegistFastModel yy_modelWithJSON:element];
        if(model.code == 200){
            [OrangeInfoArchive putUserid:[NSNumber numberWithInteger:model.content.userID]];
            [OrangeInfoArchive putAccountName:username];
            [OrangeInfoArchive putLoginPwd:password];
            [OrangeMBManager show_CustomNativeByte_BriefAlert:@"注册成功" time:1];
            
//            UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"是否保存账号密码到相册" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//            [alertView show];
            //****** 新增头条的注册埋点
            NSString * TAppid = [[NSUserDefaults standardUserDefaults]objectForKey:@"toutiaoAPPID"];
            NSString * TAppName = [[NSUserDefaults standardUserDefaults]objectForKey:@"toutiaoAPPNAME"];
            if (TAppid.length !=0 && TAppName.length != 0) {
                NSLog(@"-头条--注册埋点");
                [TTTracker registerEventByMethod:@"mobile" isSuccess:YES];
                /** Method:注册⽅方式 isSuccess: 是否成功 */
            }
            
            [self enterGameMethod];

            
        }else{
            [OrangeMBManager show_CustomNativeByte_BriefAlert:model.message ? model.message : @"获取帐号失败" time:1];
        }
        
    } failedblock:^(NSError *error) {
        if(error.code == 4){
            [OrangeMBManager show_CustomNativeByte_BriefAlert:@"网络异常" time:1];
        }else{
            [OrangeMBManager show_CustomNativeByte_BriefAlert:@"异常错误" time:1];
        }
    }];
}

#pragma mark -- 网络请求 请求快速注册
//跳转界面前，已经加载此方法
- (void)getAccountInfo{
    [OrangeAPIParams requestFastRegisterSuccessBlock:^(id response) {

        NSDictionary *element = (NSDictionary*)response;
        OrangeRegistFastModel *model = [OrangeRegistFastModel yy_modelWithJSON:element];
        if(model.code == 200){
            [OrangeMBManager show_CustomNativeByte_BriefAlert:@"获取帐号成功" time:1];
            
            self.accountTextfield.text = model.content.username;
            self.passwordTextfield.text = model.content.password;
            
        }else{
            [OrangeMBManager show_CustomNativeByte_BriefAlert:model.message ? model.message : @"获取帐号失败" time:1];
        }

    } failedblock:^(NSError *error) {
        NSLog(@"--错误的返回信息:--%@",error);
        if(error.code == 4){
            [OrangeMBManager show_CustomNativeByte_BriefAlert:@"网络异常" time:1];
        }else{
            [OrangeMBManager show_CustomNativeByte_BriefAlert:@"异常错误" time:1];
        }
    }];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
//    id alertbutton = [alertView buttonTitleAtIndex:buttonIndex];
    
    if (buttonIndex == 0) {
        
        NSLog(@"不允许访问");
        [self enterGameMethod];
        
    }else{
        
        NSLog(@"允许访问");
        //处理截屏逻辑
        UIImage * image =  [self getImageWithFullScreenshot];
        
        NSLog(@"拿到的截屏图片:%@",image);
        
//        [self askPhotoAuthorizationWithImage:image];
        [self saveImageToPhoto:image];
        
//        [self loadImageFinished:image];//存入相册
        
        [self enterGameMethod];
    }
    
}

- (void)saveImageToPhoto:(UIImage *)img {
    
    NSLog(@"保存至相册");
    
    UIImageWriteToSavedPhotosAlbum(img, self, @selector(image:didFinishSavingWithError:contextInfo:),nil);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    if (error == nil) {
        NSLog(@"保存成功");
    }
    
}


-(void)askPhotoAuthorizationWithImage:(UIImage *)image{
    //创建新的相簿
    NSError * error = nil;
    
    NSLog(@"111");
    
    __block NSString * assetID =  nil;
    
    [[PHPhotoLibrary sharedPhotoLibrary]  performChangesAndWait:^{
        
        assetID =  [PHAssetChangeRequest creationRequestForAssetFromImage:image].placeholderForCreatedAsset.localIdentifier;
        
        NSLog(@"2222");
        
    } error:&error];
    
}

-(void)enterGameMethod{//进入游戏的方法
    
    
    [OrangeAPIParams requestLogin:self.accountTextfield.text password:self.passwordTextfield.text SuccessBlock:^(id response) {
        NSDictionary *element = (NSDictionary*)response;
        
        
        NSDictionary * tempDic = element[@"content"];
        self.componentStr = [NSString stringWithFormat:@"%@",tempDic[@"component"]];
        
        self.models = [OrangeRespondModel yy_modelWithJSON:element];
        if(self.models.code == 200){
            [OrangeMBManager show_CustomNativeByte_BriefAlert:@"登录成功" time:1];
            self.users = [GreenFruit_CustomNativeByte_SDKUser new];
            self.users.appId = Appid;
            self.users.channellevel1 = Channelleve1;
            self.users.channellevel2 = Channellevel2;
            self.users.userId = self.models.content.userid;
            self.users.accountname = [OrangeInfoArchive getAccountName];
            self.users.ssid = self.models.content.sid ? self.models.content.sid : @"";
            [OrangeInfoArchive putLoginStatus:[NSNumber numberWithBool:TRUE]];
            [OrangeInfoArchive putUserid:self.users.userId];
            [OrangeInfoArchive putSid:self.users.ssid];
            
            User_Defaules_Set(self.users.userId, @"USERID");
            
            NSMutableDictionary * loginCacheDic = [[NSMutableDictionary alloc]initWithCapacity:0];
            [loginCacheDic setObject:@"FastLogin" forKey:@"LoginType"];
            [loginCacheDic setObject:self.accountTextfield.text forKey:@"LoginAccount"];
            [loginCacheDic setObject:self.passwordTextfield.text forKey:@"LoginPassword"];
            
            NSMutableArray * loginCacheArr = [[NSMutableArray alloc]initWithCapacity:0];
            NSMutableArray * TempArr = User_Defaults_Get(@"firstLoginCacheArr");
            if (TempArr!=nil) {
                loginCacheArr = [TempArr mutableCopy];

            }else{
//                NSLog(@"缓存中暂无登录信息数组");
            }
            [loginCacheArr addObject:loginCacheDic];
            
            User_Defaules_Set(loginCacheArr,@"firstLoginCacheArr");
            
            //设置正在登录状态
            [[NSUserDefaults standardUserDefaults]setObject:@"3" forKey:@"loginingType"];
            
            //处理悬浮球相关数据
            NSDictionary * contentDic = element[@"content"];
            NSString * highlight = [NSString stringWithFormat:@"%@",contentDic[@"highlight"]];
            NSString * normal = [NSString stringWithFormat:@"%@",contentDic[@"normal"]];
            NSString * refresh = [NSString stringWithFormat:@"%@",contentDic[@"refresh"]];
            if ([refresh isEqualToString:@"1"]) {//此时需要缓存图片信息
                User_Defaules_Set(highlight, @"HighlightPicture");
                User_Defaules_Set(normal, @"NormalPicture");
                
            }else{
//                NSLog(@"不需要缓存悬浮球图片");
            }
            if (self.returnTheCompletionBlock) {
                if (self.completionBlock) {
                    NSString * codes = [NSString stringWithFormat:@"%ld",(long)self.models.code];
                    self.completionBlock(self.users, codes);
                    self.returnTheCompletionBlock(self.completionBlock);
                }
            }
            self.loginDic = [NSMutableDictionary dictionary];
            self.loginDic[@"login"] = @"1";
            self.loginDic[@"floatModel"] = self.models.content.floatmodel;
            [[NSNotificationCenter defaultCenter] postNotificationName:login_notification object:self.loginDic];
            
            //跳转到绑定手机页面
//            [self performSelector:@selector(jumpToAnotherView) withObject:nil afterDelay:1.0f];

            /**头条登录埋点**/
            NSString * TAppid = [[NSUserDefaults standardUserDefaults]objectForKey:@"toutiaoAPPID"];
            NSString * TAppName = [[NSUserDefaults standardUserDefaults]objectForKey:@"toutiaoAPPNAME"];
            if (TAppid.length !=0 && TAppName.length != 0) {
                NSLog(@"userID%@",USERID);
                [[TTInstallIDManager sharedInstance] setCurrentUserUniqueID:USERID];
                [TTTracker loginEventByMethod:@"mobile" isSuccess:YES];
            }
            
        }else{
            [OrangeMBManager show_CustomNativeByte_BriefAlert:self.models.message ? self.models.message : @"获取帐号失败" time:1];
        }
    } failedblock:^(NSError *error) {
        if(error.code == 4){
            [OrangeMBManager show_CustomNativeByte_BriefAlert:@"网络异常" time:1];
        }else{
            [OrangeMBManager show_CustomNativeByte_BriefAlert:@"异常错误" time:1];
        }
    }];
}

-(void)jumpToAnotherView{
    NSLog(@"跳转页面");
    
    if (self.JumptoBoundPhoneBlock) {
        self.JumptoBoundPhoneBlock(self, self.loginDic, self.models, self.users, self.componentStr);
    }
}

- (void)pop_CustomNativeByte_SDKView:(UIView*)view{
    if(self.popView.isPop){
        [self.popView dismiss];
    }
    self.popView = [[OrangeZJAnimationPopView alloc] initWith_CustomNativeByte_CustomView:view popStyle:ZJAnimationPopStyleNO dismissStyle:ZJAnimationDismissStyleNO];
    self.popView.popBGAlpha = 0;
    self.popView.isObserver_CustomNativeByte_OrientationChange = YES;
    [self handleCustom_CustomNativeByte_ActionEnvent:self.popView customerView:view];
    [self.popView pop];
    
}

#pragma mark --- SDK页面跳转封装方法
- (void)handleCustom_CustomNativeByte_ActionEnvent:(OrangeZJAnimationPopView *)popView customerView:(UIView*)customerView{
    
    if ([customerView isKindOfClass:[GreenFruitBoundPhoneViewBlackCustomControl class]]) {
        GreenFruitBoundPhoneViewBlackCustomControl * boundPhoneView = (GreenFruitBoundPhoneViewBlackCustomControl *)customerView;
        boundPhoneView.goBackClickBlock = ^{
            [popView dismiss];
        };
        boundPhoneView.joinGameBtnBlock = ^(GreenFruitBoundPhoneViewBlackCustomControl *signView, UIButton *button) {
            
            self.completionBlock = signView.completionBlock;
            [popView dismiss];
        };
        boundPhoneView.completionBlock = ^(GreenFruit_CustomNativeByte_SDKUser *user, NSString *code) {
            self.joinGameBtnBlock(self, self.ensureBtn);
            //***
            [popView dismiss];
        };
    }
}

- (void)loadImageFinished:(UIImage *)image
{
    NSLog(@"是否走了此方法");
    NSMutableArray *imageIds = [NSMutableArray array];
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        
        //写入图片到相册
        PHAssetChangeRequest *req = [PHAssetChangeRequest creationRequestForAssetFromImage:image];
        //记录本地标识，等待完成后取到相册中的图片对象
        [imageIds addObject:req.placeholderForCreatedAsset.localIdentifier];
        
        NSLog(@"1--先执行这里--");
        
        
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        
        NSLog(@"success = %d, error = %@", success, error);
        
        if (success)
        {
            //成功后取相册中的图片对象
            __block PHAsset *imageAsset = nil;
            PHFetchResult *result = [PHAsset fetchAssetsWithLocalIdentifiers:imageIds options:nil];
            [result enumerateObjectsUsingBlock:^(PHAsset * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                imageAsset = obj;
                *stop = YES;
                
            }];
            
            if (imageAsset)
            {
                //加载图片数据
                [[PHImageManager defaultManager] requestImageDataForAsset:imageAsset
                                                                  options:nil
                                                            resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
                                                                NSLog(@"2--再执行这里--");
                                                                NSLog(@"保存好的图片数据 imageData = %@", imageData);
                                                                
                                                            }];
            }
        }
        
    }];
}


//截取全屏视图
-(UIImage *)getImageWithFullScreenshot
{
    
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    CGSize imageSize = CGSizeZero;
    
    //适配横屏状态
    if (UIInterfaceOrientationIsPortrait(orientation) )
        imageSize = [UIScreen mainScreen].bounds.size;
    else
        imageSize = CGSizeMake([UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width);
    
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    for (UIWindow *window in [[UIApplication sharedApplication] windows])
    {
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, window.center.x, window.center.y);
        CGContextConcatCTM(context, window.transform);
        CGContextTranslateCTM(context, -window.bounds.size.width * window.layer.anchorPoint.x, -window.bounds.size.height * window.layer.anchorPoint.y);
        
        // Correct for the screen orientation
        if(orientation == UIInterfaceOrientationLandscapeLeft)
        {
            CGContextRotateCTM(context, (CGFloat)M_PI_2);
            CGContextTranslateCTM(context, 0, -imageSize.width);
        }
        else if(orientation == UIInterfaceOrientationLandscapeRight)
        {
            CGContextRotateCTM(context, (CGFloat)-M_PI_2);
            CGContextTranslateCTM(context, -imageSize.height, 0);
        }
        else if(orientation == UIInterfaceOrientationPortraitUpsideDown)
        {
            CGContextRotateCTM(context, (CGFloat)M_PI);
            CGContextTranslateCTM(context, -imageSize.width, -imageSize.height);
        }
        
        if([window respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)])
            [window drawViewHierarchyInRect:window.bounds afterScreenUpdates:NO];
        else
            [window.layer renderInContext:UIGraphicsGetCurrentContext()];
        
        CGContextRestoreGState(context);
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}


@end
