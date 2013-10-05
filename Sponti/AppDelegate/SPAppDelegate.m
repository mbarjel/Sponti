//
//  SPAppDelegate.m
//  Sponti
//
//  Created by Melad Barjel on 16/09/13.
//  Copyright (c) 2013 Sponti. All rights reserved.
//

#import "SPAppDelegate.h"
#import "SPSplashViewController.h"

@implementation SPAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    [MagicalRecord setupCoreDataStackWithAutoMigratingSqliteStoreNamed:@"Sponti.sqlite"];
    
    SPSplashViewController* viewController = [[SPSplashViewController alloc] init];
    UINavigationController* navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    navigationController.navigationBarHidden = YES;
    self.window.rootViewController = navigationController;
    [self.window makeKeyAndVisible];
    return YES;
}

@end
