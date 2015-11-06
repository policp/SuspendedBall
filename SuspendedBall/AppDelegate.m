//
//  AppDelegate.m
//  SuspendedBall
//
//  Created by chenpeng on 15/11/6.
//  Copyright © 2015年 chenpeng. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "SuspendedBall.h"
@interface AppDelegate ()<SuspendedBallDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
    MainViewController *main = [[MainViewController alloc]init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:main];
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    
    NSArray *imagesArray = @[[UIImage imageNamed:@"icon_chat_record"],[UIImage imageNamed:@"icon_config"],[UIImage imageNamed:@"icon_pay_success"],[UIImage imageNamed:@"icon_remedical"]];
    [SuspendedBallView showBallViewWithImages:imagesArray andTarget:self];
    // Override point for customization after application launch.
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)suspendedBall:(UIView *)view didSelectBallCellAtIndex:(NSInteger)index{
    [WZShowAlertView showAlertViewDuration:2.0f andPosition:AlertViewPosition_center showMessage:@"请在SuspendedBallcell代理中添加事件"];
}

@end
