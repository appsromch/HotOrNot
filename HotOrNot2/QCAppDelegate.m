//
//  QCAppDelegate.m
//  HotOrNot2
//
//  Created by Eliot Arntz on 6/20/13.
//  Copyright (c) 2013 self.edu. All rights reserved.
//

#import "QCAppDelegate.h"
#import <Parse/Parse.h>

#import "ProfileViewController.h"

#import "QCDetailViewController.h"

@implementation QCAppDelegate
//adding a line to app delegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    [Parse setApplicationId:@"ELQApEBuR2KC2dJzfzAN5TEhBdQSMpgD7H0lRBo2" clientKey:@"JNuRPPbCZgxzYBhhZBARalfstu4pxQgk3c142z85"];
    
    [PFFacebookUtils initializeFacebook];
    QCLoginViewController *loginVC = [[QCLoginViewController alloc] initWithNibName:nil bundle:nil];
   
    self.window.rootViewController = loginVC;
    [self.window makeKeyAndVisible];
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [PFFacebookUtils handleOpenURL:url];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
}
*/

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed
{
}
*/


-(void)createAndPresentTabBarController
{
    QCDetailViewController *viewController2 = [[QCDetailViewController alloc] initWithNibName:nil bundle:nil];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:viewController2];
    [[UINavigationBar appearance]setBackgroundImage:[UIImage imageNamed:@"textured_nav"] forBarMetrics:UIBarMetricsDefault];
    QCLeaderBoardViewController *leaderBoardViewController = [[QCLeaderBoardViewController alloc] initWithNibName:nil bundle:nil];
    ProfileViewController *profileViewController = [[ProfileViewController alloc] initWithNibName:nil bundle:nil];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:profileViewController];
    self.tabBarController = [[UITabBarController alloc] init];
    self.tabBarController.viewControllers = @[navController, leaderBoardViewController, navigationController];
    UIImage *tabbg = [UIImage imageNamed:@"tabbar_bg.png"];
    [self.tabBarController.tabBar setBackgroundImage:tabbg];
    [self.tabBarController.tabBar setTintColor:[UIColor whiteColor]];
    [self.tabBarController.tabBar setSelectedImageTintColor:[UIColor whiteColor]];
    
    [[UINavigationBar appearance] setTitleTextAttributes: @{
     //     UITextAttributeTextColor: [UIColor greenColor],
     // UITextAttributeTextShadowColor: [UIColor redColor],
     //UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetMake(0.0f, 1.0f)],
                                     UITextAttributeFont: [UIFont fontWithName:@"DevanagariSangamMN-Bold" size:20.0f]
     //UITextAttributeFont: [UIFont fontWithName:@"Noteworthy" size:19.0f]
     
     }];

    
    
    self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];

}

@end
