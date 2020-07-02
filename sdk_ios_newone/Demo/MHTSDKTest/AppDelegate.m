//
//  AppDelegate.m
//  MHTSDKTest
//
//  Created by leigang on 2018/3/4.
//  Copyright © 2018年 gang. All rights reserved.
//

#import "AppDelegate.h"
#import <mhtframework/Orangemhtframework.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    /*
     新版初始化接口
     5c9680619fbe1f4dd0946ef8f0b06cd0    a455727bf7c4324383286686fde7ecc5
     */
     
     [[OrangeGreenFruit_CustomNativeByte_SDKCreate share_CustomNativeByte_Manager]GreenFruitNewOnCreateAppid:@"a455727bf7c4324383286686fde7ecc5" channellevel1:@"MHT" channellevel2:@"MHT" withGreenFruit_event_ad_id:@"157926" andGreenFruit_event_ad_appName:@"morixuezhanlingdong" successBlock:^(NSString *code) {
        NSLog(@"初始化返回状态:%@",code);

     } withLogoutStatusBlock:^(NSString *code) {
         NSLog(@"退出返回状态  %@",code);

     }];
    
    
    return YES;
    
}


- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(nullable NSString *)sourceApplication annotation:(id)annotation NS_DEPRECATED_IOS(4_2, 9_0, "Please use application:openURL:options:") __TVOS_PROHIBITED
{
    return true;
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
