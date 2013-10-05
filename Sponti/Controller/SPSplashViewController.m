//
//  SPSplashViewController.m
//  Sponti
//
//  Created by Melad Barjel on 16/09/13.
//  Copyright (c) 2013 Sponti. All rights reserved.
//

#import "SPSplashViewController.h"
#import "SPSplashView.h"

#import "SPLoginViewController.h"
#import "SPTabViewController.h"

#import "SPUserManager.h"
#import "SPPopulateCoreData.h"

@interface SPSplashViewController ()

@end

@implementation SPSplashViewController

- (id)init {
    self = [super init];
    if (self) {
        BOOL hasPopulatedDummyData = [[[NSUserDefaults standardUserDefaults] objectForKey:@"populatedDummyData"] boolValue];
        
        if (!hasPopulatedDummyData) {
            [self populateCoreDataWithDummyData];
            [[NSUserDefaults standardUserDefaults] setObject:@YES forKey:@"populatedDummyData"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self performSelector:@selector(displayViewController) withObject:nil afterDelay:1.f];
}

- (void)loadView {
    SPSplashView* splashView = [[SPSplashView alloc] init];
    self.view = splashView;
}

- (void)displayViewController {
    UIViewController* viewController;
    if ([[SPUserManager sharedManager] userExists]) {
        SPTabViewController * tabViewController = [[SPTabViewController alloc] init];
        viewController = [[UINavigationController alloc] initWithRootViewController:tabViewController];
        [[(UINavigationController *)viewController navigationBar] setTranslucent:NO];
    } else {
        viewController = [[SPLoginViewController alloc] init];
    }
    viewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self.navigationController presentViewController:viewController animated:YES completion:nil];
}

- (void)populateCoreDataWithDummyData {
    [[SPPopulateCoreData sharedManager] populateWithDummyData];
}

@end
