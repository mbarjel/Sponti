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
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"TableViewCellReuseIdentifer"];
    cell.accessoryView = nil;
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    if (indexPath.item == 0) {
        cell.textLabel.text = @"About Us";
    } else if (indexPath.item == 1) {
        cell.textLabel.text = @"Contact Us";
    } else if (indexPath.item == 2) {
        cell.textLabel.text = @"Log Out Timer";
    } else {
        cell.textLabel.text = @"Push Notifications";
        self.pushNotificationSwitch = [[UISwitch alloc] init];
        cell.accessoryView = self.pushNotificationSwitch;
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
        SPFeedbackViewController* feedbackViewController = [[SPFeedbackViewController alloc] init];
        [(SPTabViewController *)self.tabBarController pushViewController:feedbackViewController animated:YES];
    } else if (indexPath.item == 2) {
        SPLogoutViewController* logoutViewController = [[SPLogoutViewController alloc] init];
        [(SPTabViewController *)self.tabBarController pushViewController:logoutViewController animated:YES];
    }
}

@end
