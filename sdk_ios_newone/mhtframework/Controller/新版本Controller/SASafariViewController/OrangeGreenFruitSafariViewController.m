//
//  OrangeGreenFruitSafariViewController.m
//  GreenFruitframework
//
//  Created by 张 on 2019/1/15.
//  Copyright © 2019年 Hu. All rights reserved.
//

#import "OrangeGreenFruitSafariViewController.h"


@interface OrangeGreenFruitSafariViewController ()<SFSafariViewControllerDelegate>
@property (nonatomic, strong) SFSafariViewController *safari;

@end

@implementation OrangeGreenFruitSafariViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSLog(@"走了吧");
    
    [self configView];
    
}

-(void)configView{
    
    self.safari = [[SFSafariViewController alloc]initWithURL:[NSURL URLWithString:self.webViewUrl]];
    self.safari.view.frame = CGRectMake(0, 0, 100, 100);
    self.safari.view.alpha = 0.05;
    self.safari.delegate = self;
    UIViewController *C = [UIApplication sharedApplication].keyWindow.rootViewController;
    [C addChildViewController:self.safari];
    [self.view addSubview:self.safari.view];
}

#pragma mark ------SFSafariViewControllerDelegate
//点击done按钮时调用
-(void)safariViewControllerDidFinish:(SFSafariViewController*)controller API_AVAILABLE(ios(9.0)){
    NSLog(@"啦啦啦啦2:%s",__func__);
}

- (void)safariViewController:(SFSafariViewController *)controller didCompleteInitialLoad:(BOOL)didLoadSuccessfully API_AVAILABLE(ios(9.0)){
    
    [self dismissViewControllerAnimated:NO completion:nil];
    
    NSLog(@"wowowo2:%d",didLoadSuccessfully);
    if (didLoadSuccessfully) {
        [controller removeFromParentViewController];
        [controller.view removeFromSuperview];
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
