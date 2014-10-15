//
//  AppDelegate.m
//  WeShould
//
//  Created by Noah Teshu on 10/6/14.
//  Copyright (c) 2014 Noah Teshu. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>

@interface AppDelegate ()

@end

@implementation AppDelegate




- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self customizeAppearance];

    // Override point for customization after application launch.
    [Parse setApplicationId:@"HLh6vGMEIITwBefYZUQ2b6K1uvrzrBEw459Qe0iE"
                  clientKey:@"qzIO8FMEvV8Y0iGi29ksKdFJEBZkj6jmtQ5SU6ej"];
    
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

- (void)customizeAppearance {
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:0.557 green:0.675 blue:0.788 alpha:1]];
    [[UINavigationBar appearance]setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance]setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], UITextAttributeTextColor, nil]];
    [[UITabBar appearance]setTintColor:[UIColor whiteColor]];
    [[UITabBar appearance]setBarTintColor:[UIColor colorWithRed:0.557 green:0.675 blue:0.788 alpha:1]];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [[UIApplication sharedApplication]setStatusBarHidden:NO];
    
}

@end
