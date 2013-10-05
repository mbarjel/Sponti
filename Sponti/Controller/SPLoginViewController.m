//
//  SPLoginViewController.m
//  Sponti
//
//  Created by Melad Barjel on 16/09/13.
//  Copyright (c) 2013 Sponti. All rights reserved.
//

#import "SPLoginViewController.h"
#import "SPLoginView.h"
#import "SPTabViewController.h"

#import "SPUserManager.h"

@interface SPLoginViewController () <SPLoginViewDelegate>

@end

@implementation SPLoginViewController

- (void)loadView {
    SPLoginView* loginView = [[SPLoginView alloc] init];
    loginView.delegate = self;
    self.view = loginView;
}

#pragma mark - SPLoginViewDelegate

- (void)didPressLoginWithloginView:(SPLoginView *)loginView {
    [[SPUserManager sharedManager] saveUser];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
