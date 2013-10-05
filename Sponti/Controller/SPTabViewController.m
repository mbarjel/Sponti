//
//  SPTabViewController.m
//  Sponti
//
//  Created by Melad Barjel on 16/09/13.
//  Copyright (c) 2013 Sponti. All rights reserved.
//

#import "SPTabViewController.h"
#import "SPContactsViewController.h"
#import "SPChatsViewController.h"
#import "SPSettingsViewController.h"

@interface SPTabViewController ()

@property (nonatomic, strong) UIImageView* tabBarOverlayImageView;

@end

@implementation SPTabViewController

- (id)init {
    self = [super init];
    if (self) {
        [self setupTabs];
        [self displayOverlay];
        [self setSelectedIndex:1];
    }
    return self;
}

- (void)setupTabs {
    SPContactsViewController* favouriteContactsViewController = [[SPContactsViewController alloc] initWithType:SPContactsTypeFavourites];
    SPContactsViewController* localContactsViewController = [[SPContactsViewController alloc] initWithType:SPContactsTypeLocal];
    SPContactsViewController* regionalContactsViewController = [[SPContactsViewController alloc] initWithType:SPContactsTypeRegional];
    SPChatsViewController* chatsViewController = [[SPChatsViewController alloc] init];
    SPSettingsViewController* settingsViewController = [[SPSettingsViewController alloc] init];
    self.viewControllers = @[favouriteContactsViewController,localContactsViewController, regionalContactsViewController, chatsViewController,settingsViewController];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [self.navigationController pushViewController:viewController animated:animated];
}

- (void)displayOverlay {
    if(![[NSUserDefaults standardUserDefaults] valueForKey:@"tabBarOverlay"]) {
        _tabBarOverlayImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tabBarOverlay.jpg"]];
        _tabBarOverlayImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer* tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeOverlay)];
        [_tabBarOverlayImageView addGestureRecognizer:tapGestureRecognizer];
        _tabBarOverlayImageView.alpha = 0.75;
        _tabBarOverlayImageView.frame = CGRectMake(0, 0, 320, 414);
        [self.view addSubview:_tabBarOverlayImageView];
    }
}

- (void)removeOverlay {
    [[NSUserDefaults standardUserDefaults] setValue:@YES forKey:@"tabBarOverlay"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [UIView animateWithDuration:0.25 animations:^{
        _tabBarOverlayImageView.alpha = 0.f;
    } completion:^(BOOL finished) {
        [_tabBarOverlayImageView removeFromSuperview];
        _tabBarOverlayImageView = nil;
    }];
}

@end
