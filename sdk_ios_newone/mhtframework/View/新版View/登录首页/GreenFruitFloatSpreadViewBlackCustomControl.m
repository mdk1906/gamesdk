//
//  GreenFruitFloatSpreadViewBlackCustomControl.m
//  GreenFruitframework
//
//  Created by 张 on 2018/11/22.
//  Copyright © 2018年 Hu. All rights reserved.
//

#import "GreenFruitFloatSpreadViewBlackCustomControl.h"
#import "OrangeMBManager.h"
#import "OrangeGreenFruitBundle.h"
#import "GreenFruitTouristUserLoginViewBlackCustomControl.h"
#import "OrangeGreenFruitConfig.h"
#import "OrangeNSString+Utils.h"
#import "GreenFruitPhoneHistoryRecordTableViewCellBlackCustomControl.h"
#import "OrangeGreenFruitAddvertiseViewController.h"
#import "GreenFruitAddversitionViewBlackCustomControl.h"
#import "GreenFruitOtherWayLoginBlackCustomControl.h"
#import "OrangeAPIParams.h"
#import "OrangeRespondModel.h"
#import "OrangeInfoArchive.h"
#import "OrangeYYModel.h"
#import "OrangeUIImageView+MHImageWebCache.h"

#import <TTTracker/TTTracker.h>
#import <TTTracker/TTTracker+Game.h>
#import <TTTracker/TTInstallIDManager.h>

static NSString * identifier = @"cell";

@interface GreenFruitFloatSpreadViewBlackCustomControl()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
{
    BOOL isSpread;
    
}
@property (nonatomic,strong)GreenFruitFloatSpreadViewBlackCustomControl * floatSpreadLoginView;
@property (nonatomic,strong)GreenFruitAddversitionViewBlackCustomControl * addWebView;
@property (nonatomic,strong)GreenFruitTouristUserLoginViewBlackCustomControl * toursitView;
@property (nonatomic,strong)GreenFruitOtherWayLoginBlackCustomControl * otherWayLoginView;
@property (nonatomic,strong)UITableView * historyTableView;
@property (nonatomic,retain)NSMutableArray * historyInfoArray;
@property (nonatomic,strong)NSDictionary * iconInfoDic;//下方的icon以及对应要触发的事件
@property (nonatomic,strong)NSMutableArray * iconInfoArr;
@property (nonatomic,strong)UIViewController *selfVC;
@property (nonatomic,retain)NSString * accountStr;//账号
@property (nonatomic,retain)NSString * passwordStr;//密码
@property (nonatomic,retain)NSString * loginTypeStr;//登录类型
@property (nonatomic,assign)BOOL iscreated;//json按钮是否创建
@property (nonatomic,retain)NSString * displayString;//json数据状态
@end

@implementation GreenFruitFloatSpreadViewBlackCustomControl

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //需要初始化进行调用
        NSLog(@"进入自定义初始化方法");
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect {
    
//    self.iscreated = NO;
    
    [self createBorder];
    
    [self readLocalInfoArray];//提前读取数据
    
    [self initData];
    
    [self configView];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeRotate:) name:UIApplicationDidChangeStatusBarFrameNotification object:nil];

}

#pragma mark --- 适配横屏竖屏
- (void)changeRotate:(NSNotification*)notification{
    [self createBorder];
    [self changeOrientation];
}

-(void)createBorder{
    
    [self setNeedsLayout];
    self.otherWayLoginBtn.layer.cornerRadius = 13.5f;
    self.phoneTextfield.delegate = self;
    self.phoneTextfield.textAlignment = NSTextAlignmentCenter;

}


- (void)changeOrientation{
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (orientation == UIInterfaceOrientationPortrait
        || orientation == UIInterfaceOrientationPortraitUpsideDown) {
        //竖屏
        [self setWidth:300];

        if ([self.displayString isEqualToString:@"1"]) {
            [self verticalUI];
            [self setHeight:330];
        }else{
            [self setHeight:250];
        }
        
        self.center = CGPointMake(self.superview.bounds.size.width/2, self.superview.bounds.size.height/2);
        
    } else {
        //横屏
        if(IS_IPHONE){
            [self setWidth:400];
            if ([self.displayString isEqualToString:@"1"]) {
                [self horizontalUI];
                [self setHeight:320];
            }
            else{
                [self setHeight:250];
            }
            self.center = CGPointMake(self.superview.bounds.size.width/2, self.superview.bounds.size.height/2);
        }else{
            [self setWidth:400];
            if ([self.displayString isEqualToString:@"1"]) {
                [self verticalUI];
                [self setHeight:340];
            }
            else{
                [self setHeight:250];
            }
            self.center = CGPointMake(self.superview.bounds.size.width/2, self.superview.bounds.size.height/2);
        }
    }
}

-(void)verticalUI{
    for (int i = 0; i<self.iconInfoArr.count; i++) {
        UIButton * tempButton = [self viewWithTag:200+i];
        float wide = 300/self.iconInfoArr.count;
        float buttonWidth = 50;
        float distance = (wide-buttonWidth)/2;
        tempButton.frame = CGRectMake(distance+(2*distance+buttonWidth)*i,220+20 , buttonWidth, buttonWidth);
        
        UILabel * tempLabel = [self viewWithTag:300+i];
        tempLabel.frame = CGRectMake(tempButton.frame.origin.x, tempButton.frame.origin.y+55, tempButton.bounds.size.width, 15);
    }
}

-(void)horizontalUI{
    for (int i = 0; i<self.iconInfoArr.count; i++) {
        UIButton * tempButton = [self viewWithTag:200+i];
        float wide = 400/self.iconInfoArr.count;
        float buttonWidth = 50;
        float distance = (wide-buttonWidth)/2;
        tempButton.frame = CGRectMake(distance+(2*distance+buttonWidth)*i,220+20 , buttonWidth, buttonWidth);
        
        UILabel * tempLabel = [self viewWithTag:300+i];
        tempLabel.frame = CGRectMake(tempButton.frame.origin.x, tempButton.frame.origin.y+55, tempButton.bounds.size.width, 15);
    }
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

-(void)configView{
    
    NSString * publicPath = User_Defaults_Get(@"publicImgPath");
    UIImage * getImage = [UIImage imageWithContentsOfFile:publicPath];
    self.logoImageView.image = getImage;
//    [self.logoImageView setWebImageWithUrlStr:publicPath placeholderImageName:getImage];
    
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (orientation == UIInterfaceOrientationPortrait
        || orientation == UIInterfaceOrientationPortraitUpsideDown){
        [self setWidth:300];
        if ([self.displayString isEqualToString:@"1"]) {
            [self setHeight:330];
            [self verticalUI];
        }else{
            [self setHeight:250];

        }
        self.center = CGPointMake(self.superview.bounds.size.width/2, self.superview.bounds.size.height/2);
    }
    else{
        if(IS_IPHONE){
            [self setWidth:400];

            if ([self.displayString isEqualToString:@"1"]) {
                [self horizontalUI];
                [self setHeight:320];
            }else{
                [self setHeight:250];
            }
            self.center = CGPointMake(self.superview.bounds.size.width/2, self.superview.bounds.size.height/2);
            
        }else{
            
            [self setWidth:400];
            if ([self.displayString isEqualToString:@"1"]) {
                [self horizontalUI];
                [self setHeight:340];
            }else{
                [self setHeight:250];
            }
            self.center = CGPointMake(self.superview.bounds.size.width/2, self.superview.bounds.size.height/2);
        }
    }
    
    if (self.historyInfoArray != nil) {
        NSInteger index;
        if (self.historyInfoArray.count == 0) {
            index = 0;
        }else{
            index = self.historyInfoArray.count-1;
        }
        //默认显示 缓存中最新的一组数据
        NSDictionary * infoDic = self.historyInfoArray[index];
        self.loginTypeStr = [NSString stringWithFormat:@"%@",infoDic[@"LoginType"]];
        self.accountStr = [NSString stringWithFormat:@"%@",infoDic[@"LoginAccount"]];
        self.passwordStr = [NSString stringWithFormat:@"%@",infoDic[@"LoginPassword"]];
        
        if ([self.loginTypeStr isEqualToString:@"System"]) {//systomAccout
            NSString * logoPath = User_Defaults_Get(@"logoImgPath");
            UIImage * getImage = [UIImage imageWithContentsOfFile:logoPath];
            self.loginTypeImageview.image = getImage;
            
        }else if ([self.loginTypeStr isEqualToString:@"Phone"]){
            NSString * imgPath = [[OrangeGreenFruitBundle mainBundle]pathForResource:@"Orangephonelogin" ofType:@"png"];
            self.loginTypeImageview.image = [UIImage imageWithData:[NSData dataWithContentsOfFile:imgPath]];
        }else{
            NSString * imgPath = [[OrangeGreenFruitBundle mainBundle]pathForResource:@"Orangefastfeel" ofType:@"png"];
            self.loginTypeImageview.image = [UIImage imageWithData:[NSData dataWithContentsOfFile:imgPath]];
        }
        self.phoneTextfield.text = [NSString stringWithFormat:@"%@",infoDic[@"LoginAccount"]];
    }
    
    [self.pullDownBtn addTarget:self action:@selector(pullDownMethod) forControlEvents:UIControlEventTouchUpInside];
    self.phoneTextfield.enabled = YES;
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pullDownMethod)];
    [self.phoneTextfield addGestureRecognizer:tap];
    
    self.backImageView.layer.cornerRadius = 30.0f;
}

//加载json文件
-(void)initData{
    
    isSpread = NO;
    self.accountStr = @"";
    self.passwordStr = @"";
    self.loginTypeStr = @"";
    
    self.iconInfoDic = [[NSDictionary alloc]init];
    NSDictionary * tempDic = [GreenFruitFloatSpreadViewBlackCustomControl readLocalFileWithName:@"icon"];
    if (tempDic != nil) {
        self.iconInfoDic = tempDic;
        self.displayString = [NSString stringWithFormat:@"%@",self.iconInfoDic[@"display"]];

    }else{
        self.displayString = @"0";
    }
    
    //解析json文件
    self.iconInfoArr = [[NSMutableArray alloc]initWithCapacity:0];
    
    if ([self.displayString isEqualToString:@"1"]) {
        
        self.iconInfoArr = self.iconInfoDic[@"gameAds"];
        if (self.iconInfoArr!=nil&&self.iconInfoArr.count!=0) {
            
            if (self.iscreated == NO) {
                
                for (int i = 0; i<self.iconInfoArr.count; i++) {
                    float wide = 300/self.iconInfoArr.count;
                    float buttonWidth = 50;
                    float distance = (wide-buttonWidth)/2;
                    UIButton * tempbutton = [[UIButton alloc]initWithFrame:CGRectMake(distance+(2*distance+buttonWidth)*i,220+20 , buttonWidth, buttonWidth)];
                    tempbutton.backgroundColor = [UIColor whiteColor];
                    
                    NSDictionary * infoDic = [self.iconInfoArr objectAtIndex:i];
                    NSString * name = [NSString stringWithFormat:@"%@",infoDic[@"name"]];
                    NSString * iconUrl = [NSString stringWithFormat:@"%@",infoDic[@"icon"]];
                    NSURL * imgUrl = [NSURL URLWithString:iconUrl];
//                    通知主线程更新UI
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSLog(@"异步加载了图片");
                        [tempbutton setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:imgUrl]] forState:UIControlStateNormal];
                    });
                    
                    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(tempbutton.frame.origin.x, tempbutton.frame.origin.y+55, tempbutton.bounds.size.width, 15)];
                    titleLabel.text = [NSString stringWithFormat:@"%@",name];
                    titleLabel.font = [UIFont systemFontOfSize:11.0f];
                    titleLabel.textColor = [UIColor grayColor];
                    titleLabel.backgroundColor = [UIColor whiteColor];
                    titleLabel.textAlignment = NSTextAlignmentCenter;
                    titleLabel.tag = 300+i;
                    [self addSubview:titleLabel];
                    
                    tempbutton.tag = 200+i;
                    [tempbutton addTarget:self action:@selector(doSomethingMethod:) forControlEvents:UIControlEventTouchUpInside];
                    [self addSubview:tempbutton];
                }
                self.iscreated = YES;
            }
            
        }
        
    }else{
        self.frame = CGRectMake(kScreenWidth/2-150, kScreenHeight/2-125, 300, 250);
    }
    
}

-(void)configTableView{
   
    self.historyTableView = [[UITableView alloc]initWithFrame:CGRectMake(self.textBottomImageView.frame.origin.x, self.textBottomImageView.frame.origin.y+35, self.textBottomImageView.bounds.size.width, 100) style:UITableViewStylePlain];
    self.historyTableView.delegate = self;
    self.historyTableView.dataSource = self;
    self.historyTableView.rowHeight = 44;
    self.historyTableView.backgroundColor = [UIColor whiteColor];
    self.historyTableView.layer.borderWidth = 1.0;
    self.historyTableView.layer.borderColor=[[UIColor lightGrayColor]CGColor];
    self.historyTableView.layer.cornerRadius = 8.0f;
    self.historyTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [self addSubview:self.historyTableView];
    
    [self.historyTableView registerNib:[UINib nibWithNibName:@"GreenFruitPhoneHistoryRecordTableViewCellBlackCustomControl" bundle:[OrangeGreenFruitBundle mainBundle]] forCellReuseIdentifier:identifier];

}

#pragma mark -- UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.historyInfoArray == nil) {
        return 0;
    }else{
        return self.historyInfoArray.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GreenFruitPhoneHistoryRecordTableViewCellBlackCustomControl * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[GreenFruitPhoneHistoryRecordTableViewCellBlackCustomControl alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    if (self.historyInfoArray) {
        NSDictionary * loginCacheDic = self.historyInfoArray[indexPath.row];
        NSString * account = [NSString stringWithFormat:@"%@",loginCacheDic[@"LoginAccount"]];
        NSString * loginType = [NSString stringWithFormat:@"%@",loginCacheDic[@"LoginType"]];
        if ([loginType isEqualToString:@"Phone"]) {
            NSString * imgPath = [[OrangeGreenFruitBundle mainBundle]pathForResource:@"Orangephonelogin" ofType:@"png"];
            cell.leftLoginView.image = [UIImage imageWithData:[NSData dataWithContentsOfFile:imgPath]];
        }
        else if ([loginType isEqualToString:@"FastLogin"]){
            NSString * imgPath = [[OrangeGreenFruitBundle mainBundle]pathForResource:@"Orangefastfeel" ofType:@"png"];
            cell.leftLoginView.image = [UIImage imageWithData:[NSData dataWithContentsOfFile:imgPath]];
        }
        else{
//            NSString * imgPath = [[OrangeGreenFruitBundle mainBundle]pathForResource:@"OrangesystomAccout" ofType:@"png"];
//            cell.leftLoginView.image = [UIImage imageWithData:[NSData dataWithContentsOfFile:imgPath]];
            NSString * logoPath = User_Defaults_Get(@"logoImgPath");
            UIImage * getImage = [UIImage imageWithContentsOfFile:logoPath];
            cell.leftLoginView.image = getImage;
            
        }
        cell.recordLabel.text = account;
        [cell.deleteBtn addTarget:self action:@selector(deleteARecordMethod:) forControlEvents:UIControlEventTouchUpInside];
        cell.deleteBtn.tag = 1000+indexPath.row;
    }
    return cell;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

#pragma mark -- UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary * loginCacheDic = self.historyInfoArray[indexPath.row];
    
    self.accountStr = [NSString stringWithFormat:@"%@",loginCacheDic[@"LoginAccount"]];
    self.passwordStr = [NSString stringWithFormat:@"%@",loginCacheDic[@"LoginPassword"]];
    self.loginTypeStr = [NSString stringWithFormat:@"%@",loginCacheDic[@"LoginType"]];
    
    self.phoneTextfield.text = [NSString stringWithFormat:@"%@",self.accountStr];
    
    NSString * pathString = [[OrangeGreenFruitBundle mainBundle]pathForResource:@"Orange下拉_2" ofType:@"png"];
    
    [self.pullDownBtn setBackgroundImage:[UIImage imageWithData:[NSData dataWithContentsOfFile:pathString]] forState:UIControlStateNormal];
    
    isSpread = NO;
    
    if ([self.loginTypeStr isEqualToString:@"Phone"]) {
        NSString * imgPath = [[OrangeGreenFruitBundle mainBundle]pathForResource:@"Orangephonelogin" ofType:@"png"];
        self.loginTypeImageview.image = [UIImage imageWithData:[NSData dataWithContentsOfFile:imgPath]];
        
    }
    else if ([self.loginTypeStr isEqualToString:@"FastLogin"]){
        NSString * imgPath = [[OrangeGreenFruitBundle mainBundle]pathForResource:@"Orangefastfeel" ofType:@"png"];
        self.loginTypeImageview.image = [UIImage imageWithData:[NSData dataWithContentsOfFile:imgPath]];
    }
    else{
//        NSString * imgPath = [[OrangeGreenFruitBundle mainBundle]pathForResource:@"OrangesystomAccout" ofType:@"png"];
//        self.loginTypeImageview.image = [UIImage imageWithData:[NSData dataWithContentsOfFile:imgPath]];
        NSString * logoPath = User_Defaults_Get(@"logoImgPath");
        UIImage * getImage = [UIImage imageWithContentsOfFile:logoPath];
        self.loginTypeImageview.image = getImage;
        
    }
    
    [self.historyTableView removeFromSuperview];

}

#pragma mark -- UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField{
    NSString * string = [NSString stringWithFormat:@"%@",textField.text];
    NSLog(@"输出:%@",string);
}

#pragma mark -- 按钮方法
//下方推广按钮
-(void)doSomethingMethod:(UIButton *)sender{
    NSInteger index = sender.tag - 200;
    
    NSDictionary * infoDic = [self.iconInfoArr objectAtIndex:index];
    
    NSString * model = [NSString stringWithFormat:@"%@",infoDic[@"model"]];
    NSString * targetPath = [NSString stringWithFormat:@"%@",infoDic[@"target"]];
    
    if ([model isEqualToString:@"app"]) {
        NSURL *url = [NSURL URLWithString:targetPath];
        
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            
            [[UIApplication sharedApplication] openURL:url];
            
        }else{
            [OrangeMBManager show_CustomNativeByte_BriefAlert:@"未安装此应用" time:1.5];
        }
        
    }else if ([model isEqualToString:@"web"]){
        
        self.addWebView = [[[OrangeGreenFruitBundle mainBundle]loadNibNamed:@"GreenFruitAddversitionViewBlackCustomControl" owner:self options:nil] lastObject];
        self.addWebView.webUrlString = targetPath;
        [self pop_CustomNativeByte_SDKView:self.addWebView];
        
    }else{
        NSLog(@"do nothing");
    }

}

//删除历史记录
-(void)deleteARecordMethod:(UIButton *)sender{
    NSInteger index = sender.tag - 1000;
    NSDictionary * logincacheDic = self.historyInfoArray[index];
    
    NSMutableArray * tempArr = [[NSMutableArray alloc]initWithCapacity:0];
    tempArr = [self.historyInfoArray mutableCopy];
    [tempArr removeObjectAtIndex:index];
    self.historyInfoArray = [tempArr mutableCopy];
    User_Defaules_Set(self.historyInfoArray, @"firstLoginCacheArr");
    
    [self.historyTableView reloadData];

    
    if (self.historyInfoArray.count == 0) {
        if (self.cacheCleanSuccessBlock) {
            self.cacheCleanSuccessBlock();
        }
        return;
    }
    
}

//返回按钮
- (IBAction)returnBackMethod:(UIButton *)sender {
    
    if(self.goBackClickedBlock){
        
        self.goBackClickedBlock();
    }
}

//登录按钮
- (IBAction)nextStepMethod:(UIButton *)sender {

  
    if (self.phoneTextfield.text.length == 0) {
        [OrangeMBManager show_CustomNativeByte_BriefAlert:@"请填写账号信息" time:1.0f];
        return;
    }
    
    if ([self.loginTypeStr isEqualToString:@"Phone"]) {//手机号登录
        
        NSLog(@"此时为手机号登录  密码为二次加密密码，不需要再加密 账号:%@ 密码:%@",self.accountStr,self.passwordStr);
        
        [OrangeAPIParams requestPhoneLogin:self.accountStr password:self.passwordStr SuccessBlock:^(id response) {
            
            NSDictionary * element = (NSDictionary *)response;
            NSLog(@"以手机号登录的接口返回信息:%@",element);
            OrangeRespondModel *model = [OrangeRespondModel yy_modelWithJSON:element];
            if(model.code == 200){
                GreenFruit_CustomNativeByte_SDKUser *user = [GreenFruit_CustomNativeByte_SDKUser new];
                user.appId = Appid;
                user.channellevel1 = Channelleve1;
                user.channellevel2 = Channellevel2;
                user.userId = model.content.userid;
                user.accountname = self.accountStr;
                user.ssid = model.content.sid ? model.content.sid : @"";
                [OrangeInfoArchive putLoginStatus:[NSNumber numberWithBool:TRUE]];
                [OrangeInfoArchive putUserid:user.userId];
                [OrangeInfoArchive putSid:user.ssid];
                [OrangeInfoArchive putAccountName:self.accountStr];
                [OrangeInfoArchive putLoginPwd:self.passwordStr];
               
                User_Defaules_Set(user.userId, @"USERID");

                
                //处理悬浮球相关数据
                NSDictionary * contentDic = element[@"content"];
                NSString * highlight = [NSString stringWithFormat:@"%@",contentDic[@"highlight"]];
                NSString * normal = [NSString stringWithFormat:@"%@",contentDic[@"normal"]];
                NSString * refresh = [NSString stringWithFormat:@"%@",contentDic[@"refresh"]];
                if ([refresh isEqualToString:@"1"]) {//此时需要缓存图片信息
                    User_Defaules_Set(highlight, @"HighlightPicture");
                    User_Defaules_Set(normal, @"NormalPicture");
                    
                }else{
                    NSLog(@"不需要缓存悬浮球图片");
                }
                
                [self loginCacheMethodWithLoginType:self.loginTypeStr];//做登录信息缓存
               
                
                if (self.loginSuccessBlock) {
                    self.loginSuccessBlock();
                    if (self.completionBlock) {
                        NSString * codeStr = [NSString stringWithFormat:@"%@",element[@"code"]];
                        self.completionBlock(user, codeStr);
                    }
                }
                
                NSMutableDictionary *loginDic = [NSMutableDictionary dictionary];
                loginDic[@"login"] = @"1";
                loginDic[@"floatModel"] = model.content.floatmodel;
                [[NSNotificationCenter defaultCenter] postNotificationName:login_notification object:loginDic];
                [OrangeMBManager show_CustomNativeByte_BriefAlert:@"登录成功" time:1];
                
                /**头条登录埋点**/
                NSString * TAppid = [[NSUserDefaults standardUserDefaults]objectForKey:@"toutiaoAPPID"];
                NSString * TAppName = [[NSUserDefaults standardUserDefaults]objectForKey:@"toutiaoAPPNAME"];
                if (TAppid.length !=0 && TAppName.length != 0) {
                    NSLog(@"userid%@",USERID);
                    [[TTInstallIDManager sharedInstance] setCurrentUserUniqueID:USERID];
                    [TTTracker loginEventByMethod:@"mobile" isSuccess:YES];
                }
             
            }
            else{
                NSString * message = [NSString stringWithFormat:@"%@",element[@"message"]];
                [OrangeMBManager show_CustomNativeByte_BriefAlert:message time:1.0f];
            }
            
        } failedblock:^(NSError *error) {
            NSLog(@"错误信息:%@",error);
            if(error.code == 4){
                [OrangeMBManager show_CustomNativeByte_BriefAlert:@"网络异常" time:1];
            }else{
                [OrangeMBManager show_CustomNativeByte_BriefAlert:@"异常错误" time:1];
            }
        }];;
        
    }else{//快速登录以及系统账号登录不变
//        NSLog(@"此时为快速和系统账号登录  密码为原始密码，需要二次加密 账号:%@ 密码:%@",self.accountStr,self.passwordStr);

        [OrangeAPIParams requestLogin:self.accountStr password:self.passwordStr SuccessBlock:^(id response) {
            NSDictionary * element = (NSDictionary *)response;
            OrangeRespondModel *model = [OrangeRespondModel yy_modelWithJSON:element];
            if(model.code == 200){
                GreenFruit_CustomNativeByte_SDKUser *user = [GreenFruit_CustomNativeByte_SDKUser new];
                user.appId = Appid;
                user.channellevel1 = Channelleve1;
                user.channellevel2 = Channellevel2;
                user.userId = model.content.userid;
                user.accountname = self.accountStr;
                user.ssid = model.content.sid ? model.content.sid : @"";
                [OrangeInfoArchive putLoginStatus:[NSNumber numberWithBool:TRUE]];
                [OrangeInfoArchive putUserid:user.userId];
                [OrangeInfoArchive putSid:user.ssid];
                [OrangeInfoArchive putAccountName:self.accountStr];
                [OrangeInfoArchive putLoginPwd:self.passwordStr];
                
                User_Defaules_Set(user.userId, @"USERID");

                
                [self loginCacheMethodWithLoginType:self.loginTypeStr];//做登录信息缓存

                //处理悬浮球相关数据
                NSDictionary * contentDic = element[@"content"];
                NSString * highlight = [NSString stringWithFormat:@"%@",contentDic[@"highlight"]];
                NSString * normal = [NSString stringWithFormat:@"%@",contentDic[@"normal"]];
                NSString * refresh = [NSString stringWithFormat:@"%@",contentDic[@"refresh"]];
                if ([refresh isEqualToString:@"1"]) {//此时需要缓存图片信息
                    User_Defaules_Set(highlight, @"HighlightPicture");
                    User_Defaules_Set(normal, @"NormalPicture");
                    
                }else{
                    NSLog(@"不需要缓存悬浮球图片");
                }
                
                if (self.loginSuccessBlock) {
                    self.loginSuccessBlock();
                    if (self.completionBlock) {
                        NSString * codeStr = [NSString stringWithFormat:@"%@",element[@"code"]];
                        self.completionBlock(user, codeStr);
                    }
                }
                
                NSMutableDictionary *loginDic = [NSMutableDictionary dictionary];
                loginDic[@"login"] = @"1";
                loginDic[@"floatModel"] = model.content.floatmodel;
                [[NSNotificationCenter defaultCenter] postNotificationName:login_notification object:loginDic];
                [OrangeMBManager show_CustomNativeByte_BriefAlert:@"登录成功" time:1];
                
                /**头条登录埋点**/
                NSString * TAppid = [[NSUserDefaults standardUserDefaults]objectForKey:@"toutiaoAPPID"];
                NSString * TAppName = [[NSUserDefaults standardUserDefaults]objectForKey:@"toutiaoAPPNAME"];
                if (TAppid.length !=0 && TAppName.length != 0) {
                    NSLog(@"userid%@",USERID);

                    [[TTInstallIDManager sharedInstance] setCurrentUserUniqueID:USERID];
                    [TTTracker loginEventByMethod:@"mobile" isSuccess:YES];
                }
                
            }
            else{
                NSString * message = [NSString stringWithFormat:@"%@",element[@"message"]];
                [OrangeMBManager show_CustomNativeByte_BriefAlert:message time:1.0f];
            }
            
        } failedblock:^(NSError *error) {
            NSLog(@"错误信息:%@",error);
            if(error.code == 4){
                [OrangeMBManager show_CustomNativeByte_BriefAlert:@"网络异常" time:1];
            }else{
                [OrangeMBManager show_CustomNativeByte_BriefAlert:@"异常错误" time:1];
            }
            
        }];
    }
}

-(void)loginCacheMethodWithLoginType:(NSString *)loginTypeStr{
    NSMutableDictionary * loginCacheDic = [[NSMutableDictionary alloc]initWithCapacity:0];
    [loginCacheDic setObject:loginTypeStr forKey:@"LoginType"];
    [loginCacheDic setObject:self.accountStr forKey:@"LoginAccount"];
    [loginCacheDic setObject:self.passwordStr forKey:@"LoginPassword"];
    
    NSMutableArray * loginCacheArr = [[NSMutableArray alloc]initWithCapacity:0];
    NSMutableArray * TempArr = User_Defaults_Get(@"firstLoginCacheArr");
    if (TempArr!=nil) {
        
        loginCacheArr = [TempArr mutableCopy];
        
    }else{
        NSLog(@"缓存中暂无登录信息数组");
    }
    
    //遍历一遍缓存的信息，如果有账号相同的，就把原位置信息删除，新账号添加进缓存数组
    
    BOOL isSame;//是否有同样的账号在缓存中
    isSame = NO;
    if (loginCacheArr.count!=0) {
        NSInteger countNumber = loginCacheArr.count;
        for (int i = 0; i<countNumber; i++) {
            NSDictionary * cacheDic = loginCacheArr[i];
            NSString * accountName = [NSString stringWithFormat:@"%@",cacheDic[@"LoginAccount"]];
            if ([self.accountStr isEqualToString:accountName]) {
                [loginCacheArr removeObjectAtIndex:i];//删除原位置数据
                [loginCacheArr addObject:loginCacheDic];//加上新数据
                isSame = YES;
                
            }else{
//                NSLog(@"缓存中该位置账号和新增账号不一致");
            }
        }
    }
    if (isSame == NO) {//如果遍历所有账号都没有相同账号，则将新账号加入缓存
        [loginCacheArr addObject:loginCacheDic];
    }
    User_Defaules_Set(loginCacheArr,@"firstLoginCacheArr");
    //设置正在登录状态
    [[NSUserDefaults standardUserDefaults]setObject:@"3" forKey:@"loginingType"];
}


//其他账号登录
- (IBAction)otherWayLoginMethod:(UIButton *)sender {
    
    self.otherWayLoginView = [[[OrangeGreenFruitBundle mainBundle]loadNibNamed:@"GreenFruitOtherWayLoginBlackCustomControl" owner:self options:nil] lastObject];
    [self pop_CustomNativeByte_SDKView:self.otherWayLoginView];

}

//下拉按钮
-(void)pullDownMethod{
    
    if (isSpread == NO) {
        
        NSString * imgPath = [[OrangeGreenFruitBundle mainBundle]pathForResource:@"Orange上拉_2" ofType:@"png"];
        [self.pullDownBtn setBackgroundImage:[UIImage imageWithData:[NSData dataWithContentsOfFile:imgPath]] forState:UIControlStateNormal];
        
        [self configTableView];
        
    }else{
        NSString * imgPath = [[OrangeGreenFruitBundle mainBundle]pathForResource:@"Orange下拉_2" ofType:@"png"];
        [self.pullDownBtn setBackgroundImage:[UIImage imageWithData:[NSData dataWithContentsOfFile:imgPath]] forState:UIControlStateNormal];
        
        [self.historyTableView removeFromSuperview];
    }
    isSpread = !isSpread;
}


#pragma mark --- SDK页面跳转封装方法
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

#pragma mark 处理自定义视图操作事件
- (void)handleCustom_CustomNativeByte_ActionEnvent:(OrangeZJAnimationPopView *)popView customerView:(UIView*)customerView{
    
    if([customerView isKindOfClass:[GreenFruitAddversitionViewBlackCustomControl class]]){
        GreenFruitAddversitionViewBlackCustomControl *webview = (GreenFruitAddversitionViewBlackCustomControl *)customerView;
        webview.goBackClickedBlock = ^{
            [popView dismiss];
        };
    }
    else if ([customerView isKindOfClass:[GreenFruitOtherWayLoginBlackCustomControl class]]){
        //这里是有缓存时，从首页登录页面跳转过来的操作控制
        GreenFruitOtherWayLoginBlackCustomControl * otherLoginView = (GreenFruitOtherWayLoginBlackCustomControl *)customerView;
        otherLoginView.goBackClickedBlock = ^{
            [popView dismiss];
            if (self.goBackClickedBlock) {
                self.goBackClickedBlock();
            }
        };
        otherLoginView.completionBlock = ^(GreenFruit_CustomNativeByte_SDKUser *user, NSString *code) {
            if (self.completionBlock) {
                self.completionBlock(user, code);
            };
        };
        
    }
}

- (void)pop_CustomNativeByte_SDKView:(UIView*)view popView:(OrangeZJAnimationPopView*)backPopView{
    [backPopView dismiss];
    OrangeZJAnimationPopView *popView = [[OrangeZJAnimationPopView alloc] initWith_CustomNativeByte_CustomView:view popStyle:ZJAnimationPopStyleNO dismissStyle:ZJAnimationDismissStyleNO];
    popView.popBGAlpha = 0;
    popView.isObserver_CustomNativeByte_OrientationChange = YES;
    [self handleCustom_CustomNativeByte_ActionEnvent:popView customerView:view];
    [popView pop];
    NSLog(@"进入下一页");
}

- (void)goBackSDKView:(UIView*)view popView:(OrangeZJAnimationPopView*)backPopView{
    [backPopView dismiss];
    OrangeZJAnimationPopView *popView = [[OrangeZJAnimationPopView alloc] initWith_CustomNativeByte_CustomView:view popStyle:ZJAnimationPopStyleNO dismissStyle:ZJAnimationDismissStyleNO];
    popView.popBGAlpha = 0;
    popView.isObserver_CustomNativeByte_OrientationChange = YES;
    [self handleCustom_CustomNativeByte_ActionEnvent:popView customerView:view];
    [popView pop];
    NSLog(@"返回上一页   是否返回");
}


#pragma mark -- 读取本地文件
-(void)readLocalInfoArray{
    
    NSMutableArray * tempArr = User_Defaults_Get(@"firstLoginCacheArr");
    
    self.historyInfoArray = [tempArr mutableCopy];
    
    [self.historyTableView reloadData];
}

// 读取本地JSON文件
+ (NSDictionary *)readLocalFileWithName:(NSString *)name {
    
    // 获取文件路径
//    NSString *path = [[OrangeGreenFruitBundle mainBundle] pathForResource:name ofType:@"json"];
//    // 将文件数据化
//    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
//    // 对数据进行JSON格式化并返回字典形式
//    return [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    
    /*
      新地址:http://api.17173g.cn/sdk-center/ads/appid/ads.json
      原地址：http://api.17173g.cn/sdk-center/ads/ads.json
     */
    NSString * urlStr = [NSString stringWithFormat:@"http://api.17173g.cn/sdk-center/ads/%@/ads.json",Appid];
    NSURL * url = [NSURL URLWithString:urlStr];
    NSData * data = [NSData dataWithContentsOfURL:url];
    // 将文件数据化
//    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
    if (data == nil) {
        return nil;
    }
    
    // 对数据进行JSON格式化并返回字典形式
    return [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];

}



+(GreenFruitFloatSpreadViewBlackCustomControl *)getSpreadView{
    GreenFruitFloatSpreadViewBlackCustomControl * customView = [[[UINib nibWithNibName:@"GreenFruitFloatSpreadViewBlackCustomControl" bundle:nil]instantiateWithOwner:self options:nil] lastObject];
    return customView;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
}


@end
