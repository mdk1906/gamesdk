//
//  GreenFruitRealIdentityCheckViewBlackCustomControl.m
//  GreenFruitframework
//
//  Created by 张 on 2018/12/4.
//  Copyright © 2018年 Hu. All rights reserved.
//

#import "GreenFruitRealIdentityCheckViewBlackCustomControl.h"
#import "OrangeGreenFruitBundle.h"
#import "OrangeAPIParams.h"
#import "OrangeInfoArchive.h"
#import "OrangeMBManager.h"
#import "GreenFruitIdentifyTypeTableViewCellBlackCustomControl.h"
#import "OrangeGreenFruitConfig.h"
#import "OrangeUIImageView+MHImageWebCache.h"


static NSString * identifier = @"cell";

@interface GreenFruitRealIdentityCheckViewBlackCustomControl()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    UITableView * typeTableView;
    BOOL isSpread;
    CGPoint historyPoint;
    UITextField * nowTextfield;
}
@property (nonatomic,retain)NSString * nameString;
@property (nonatomic,retain)NSString * identityType;
@property (nonatomic,retain)NSString * identityNumber;
@property (nonatomic,retain)NSMutableArray * typeArr;
@property (nonatomic,retain)NSString * textfieldName;

@end

@implementation GreenFruitRealIdentityCheckViewBlackCustomControl

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    [self initData];
 
    [self configView];
        
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeRotate:) name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
//    //注册观察键盘的变化
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
}

-(void)initData{
    isSpread = NO;
    self.typeArr = [[NSMutableArray alloc]initWithObjects:@"身份证",@"居住证",@"护照",@"通行证",@"军官证", nil];
    
    nowTextfield = [[UITextField alloc]init];
    
    nowTextfield.delegate = self;
    
    self.textfieldName = @"1";
}

-(void)configView{
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];

    self.registionBtn.layer.cornerRadius = 20.0f;
    self.nameTextfield.delegate = self;
    self.nameTextfield.tag = 100;
    self.identityNumbertextfield.delegate = self;
    self.identityNumbertextfield.tag = 200;
    self.identityNumbertextfield.keyboardType = UIKeyboardTypeNumberPad;
    self.pullupBtn.alpha = 0;
    self.returnBackBtn.alpha = 0;
    self.changeAccountBtn.alpha = 0;
    if ([self.JumpviewType isEqualToString:@"SDKView"]) {
        self.returnBackBtn.alpha = 1;
        self.closeBtn.alpha = 0;
        self.changeAccountBtn.alpha = 0;
    }
 
    if ([self.JumpviewType isEqualToString:@"accountSecurityView"]) {
        self.returnBackBtn.alpha = 1;
    }
    
    NSString * publicPath = User_Defaults_Get(@"publicImgPath");
    UIImage * getImage = [UIImage imageWithContentsOfFile:publicPath];
    self.logoImageview.image = getImage;
    
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (orientation == UIInterfaceOrientationPortrait
        || orientation == UIInterfaceOrientationPortraitUpsideDown){
        [self setWidth:300];
        [self setHeight:330];
        self.center = CGPointMake(self.superview.bounds.size.width/2, self.superview.bounds.size.height/2);
    }
    else{
        if(IS_IPHONE){
            [self setWidth:400];
            [self setHeight:320];
            self.center = CGPointMake(self.superview.bounds.size.width/2, self.superview.bounds.size.height/2);
        }else{
            [self setWidth:400];
            [self setHeight:340];
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
        
        self.center = CGPointMake(self.superview.bounds.size.width/2, self.superview.bounds.size.height/2);
        
    } else {
        //横屏
        if(IS_IPHONE){
            [self horizontalUI];
            [self setWidth:400];
            [self setHeight:320];
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
    CGFloat offset;
    if ([self.textfieldName isEqualToString:@"1"]) {
         offset = (self.nameTextfield.frame.origin.y+self.nameTextfield.frame.size.height+10) - (kScreenHeight - kbHeight);
    }
    else if ([self.textfieldName isEqualToString:@"2"]){
        offset = (self.identityNumbertextfield.frame.origin.y+self.identityNumbertextfield.frame.size.height+10) - (kScreenHeight - kbHeight);
    }
    else{
        offset = (self.nameTextfield.frame.origin.y+self.nameTextfield.frame.size.height+10) - (kScreenHeight - kbHeight);

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

//返回
- (IBAction)returnBackMethod:(id)sender {
    if (self.gobackClickBlock) {
        self.gobackClickBlock();
    }
}

//关闭页面
- (IBAction)closeMethod:(id)sender {
    if (self.closeViewBlock) {
        self.closeViewBlock();
    }
}

//展开类型
- (IBAction)spreadTypeMethod:(UIButton *)sender {
//    if (isSpread == NO) {
//        NSString * pathString = [[OrangeGreenFruitBundle mainBundle]pathForResource:@"上拉" ofType:@"png"];
//        [self.pullupBtn setBackgroundImage:[UIImage imageWithData:[NSData dataWithContentsOfFile:pathString]] forState:UIControlStateNormal];
//        [self createTableView];
//        isSpread = YES;
//    }else{
//        NSString * pathString = [[OrangeGreenFruitBundle mainBundle]pathForResource:@"下拉" ofType:@"png"];
//        [self.pullupBtn setBackgroundImage:[UIImage imageWithData:[NSData dataWithContentsOfFile:pathString]] forState:UIControlStateNormal];
//        [typeTableView removeFromSuperview];
//        isSpread = NO;
//    }
    
}

-(void)createTableView{
    typeTableView = [[UITableView alloc]initWithFrame:CGRectMake(self.identityTypeBtn.frame.origin.x, self.identityTypeBtn.frame.origin.y+30, self.identityTypeBtn.bounds.size.width, 100) style:UITableViewStylePlain];
    typeTableView.delegate = self;
    typeTableView.dataSource = self;
    typeTableView.rowHeight = 40;
    typeTableView.backgroundColor = [UIColor whiteColor];
    typeTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [self addSubview:typeTableView];
    [typeTableView registerNib:[UINib nibWithNibName:@"GreenFruitIdentifyTypeTableViewCellBlackCustomControl" bundle:[OrangeGreenFruitBundle mainBundle]] forCellReuseIdentifier:identifier];
}

#pragma mark -- UITextFieldDelegate
-(void)textFieldDidBeginEditing:(UITextField *)textField{
  
    
    if (textField == self.nameTextfield) {
        self.textfieldName = @"1";
    }
    else if (textField == self.identityNumbertextfield){
        self.textfieldName = @"2";
    }else{
        NSLog(@"都不是");
    }
}

//点击输入框界面跟随键盘上移
- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    NSInteger tag = textField.tag;
    switch (tag) {
        case 100:
        {
            self.nameString = [NSString stringWithFormat:@"%@",textField.text];
        }
            break;
        case 200:
        {
            self.identityNumber = [NSString stringWithFormat:@"%@",textField.text];
        }
            break;
        default:
            break;
    }
}

#pragma mark -- UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.typeArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GreenFruitIdentifyTypeTableViewCellBlackCustomControl * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[GreenFruitIdentifyTypeTableViewCellBlackCustomControl alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.contentlabel.text = [NSString stringWithFormat:@"%@",self.typeArr[indexPath.row]];
    return cell;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

#pragma mark -- UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString * titleString = [NSString stringWithFormat:@"%@",self.typeArr[indexPath.row]];
    [self.identityTypeBtn setTitle:titleString forState:UIControlStateNormal];
    
    isSpread = NO;
    
    [typeTableView removeFromSuperview];
    
}


//确认按钮
- (IBAction)ensureMethod:(id)sender {
    [self endEditing:YES];

    if (self.nameString.length == 0) {
        [OrangeMBManager show_CustomNativeByte_BriefAlert:@"请输入姓名" time:1.0f];
        return;
    }
    if (self.identityNumber.length == 0) {
        [OrangeMBManager show_CustomNativeByte_BriefAlert:@"请输入证件号码" time:1.0f];
        return;
    }
    
    NSString * userId = [OrangeInfoArchive getUserId];
    [OrangeAPIParams requestIdentifyVertifyUserId:userId name:self.nameString identityno:self.identityNumber successblock:^(id response) {
        NSDictionary * infoDic = (NSDictionary *)response;
        NSString * status = [NSString stringWithFormat:@"%@",infoDic[@"code"]];
        if ([status isEqualToString:@"200"]) {
            [OrangeMBManager show_CustomNativeByte_BriefAlert:@"验证通过" time:1.0f];
            
            if ([self.JumpviewType isEqualToString:@"SDKView"]) {
                if (self.comeBackToSDKBlock) {
                    self.comeBackToSDKBlock();
                }
            }
            if (self.checkSuccessBlock) {//实名验证通过
                self.checkSuccessBlock();
            }
            if (self.accountSecuretyCloseBlcok) {
                self.accountSecuretyCloseBlcok();
            }
        }else{
          
            NSString * message = [NSString stringWithFormat:@"%@",infoDic[@"message"]];
            [OrangeMBManager show_CustomNativeByte_BriefAlert:message time:1.0f];
        }
        
    } failedblock:^(NSError *error) {
        if(error.code == 4){
            [OrangeMBManager show_CustomNativeByte_BriefAlert:@"网络异常" time:1];
        }else{
            [OrangeMBManager show_CustomNativeByte_BriefAlert:@"异常错误" time:1];
        }
    }];
}

//切换账号登录
- (IBAction)changeAccountMethod:(id)sender {
//    if (self.changeAccountBlock) {
//        self.changeAccountBlock();
//    }
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}


@end
