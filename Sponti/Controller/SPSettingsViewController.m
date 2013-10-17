//
//  SPSettingsViewController.m
//  Sponti
//
//  Created by Melad Barjel on 17/09/13.
//  Copyright (c) 2013 Sponti. All rights reserved.
//

#import "SPSettingsViewController.h"

#import "SPTabViewController.h"

#import "SPAboutViewController.h"
#import "SPFeedbackViewController.h"
#import "SPLogoutViewController.h"
#import "SPInviteFacebookFriendsViewController.h"
#import "SPAllContactsViewController.h"
#import "SPNotificationsViewController.h"

@interface SPSettingsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) UISwitch* pushNotificationSwitch;

@end

@implementation SPSettingsViewController

- (id)init {
    self = [super init];
    if (self) {
        self.title = @"Settings";
        self.view.backgroundColor = [UIColor whiteColor];
        
        self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"TableViewCellReuseIdentifer"];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [self.view addSubview:self.tableView];
        
        [self.tableView makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.title = self.title;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"TableViewCellReuseIdentifer"];
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (indexPath.item == 0) {
        cell.textLabel.text = @"About Us";
    } else if (indexPath.item == 1) {
        cell.textLabel.text = @"Invite Facebook Friends";
    } else if (indexPath.item == 2) {
        cell.textLabel.text = @"My Sponti Friends";
    } else if (indexPath.item == 3) {
        cell.textLabel.text = @"Push Notifications";
    } else if (indexPath.item == 4) {
        cell.textLabel.text = @"Auto Offline";
    } else if (indexPath.item == 5) {
        cell.textLabel.text = @"Help";
    } else {
        cell.textLabel.text = @"Logout";
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.textLabel.textColor = [UIColor blackColor];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.contentView.backgroundColor = [UIColor redColor];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item == 0) {
        SPAboutViewController* aboutViewController = [[SPAboutViewController alloc] init];
        [(SPTabViewController *)self.tabBarController pushViewController:aboutViewController animated:YES];
    } else if (indexPath.item == 1) {
        SPInviteFacebookFriendsViewController* inviteFacebokkFriendsVieController = [[SPInviteFacebookFriendsViewController alloc] init];
        [(SPTabViewController *)self.tabBarController pushViewController:inviteFacebokkFriendsVieController animated:YES];
    } else if (indexPath.item == 2) {
        SPAllContactsViewController* allContactsViewController = [[SPAllContactsViewController alloc] init];
        [(SPTabViewController *)self.tabBarController pushViewController:allContactsViewController animated:YES];
    } else if (indexPath.item == 3) {
        SPNotificationsViewController* notificationsViewController = [[SPNotificationsViewController alloc] init];
        [(SPTabViewController *)self.tabBarController pushViewController:notificationsViewController animated:YES];
    } else if (indexPath.item == 4) {
        SPLogoutViewController* logoutViewController = [[SPLogoutViewController alloc] init];
        [(SPTabViewController *)self.tabBarController pushViewController:logoutViewController animated:YES];
    } else if (indexPath.item == 5) {
        SPFeedbackViewController* feedbackViewController = [[SPFeedbackViewController alloc] init];
        [(SPTabViewController *)self.tabBarController pushViewController:feedbackViewController animated:YES];
    } else {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userExists"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

@end
