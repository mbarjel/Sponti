//
//  SPNotificationsViewController.m
//  Sponti
//
//  Created by Melad Barjel on 17/10/13.
//  Copyright (c) 2013 Sponti. All rights reserved.
//

#import "SPNotificationsViewController.h"

@interface SPNotificationsViewController ()

@end

@implementation SPNotificationsViewController

- (id)init {
    self = [super init];
    if (self) {
        self.title = @"Notifications";
        self.view.backgroundColor = [UIColor whiteColor];
        
        UILabel* firstNotifyLabel = [[UILabel alloc] init];
        firstNotifyLabel.backgroundColor = [UIColor clearColor];
        firstNotifyLabel.text = @"Notify me when favourites are within local range";
        firstNotifyLabel.font = [UIFont systemFontOfSize:14.f];
        firstNotifyLabel.numberOfLines = 2;
        firstNotifyLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [self.view addSubview:firstNotifyLabel];
        [firstNotifyLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.left).with.offset(20);
            make.top.equalTo(self.view.top).with.offset(20);
            make.width.equalTo(@160);
            make.height.equalTo(@60);
        }];
        
        UISwitch* firstSwitch = [[UISwitch alloc] init];
        [self.view addSubview:firstSwitch];
        [firstSwitch makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.view.right).with.offset(-20);
            make.top.equalTo(self.view.top).with.offset(30);
            make.width.equalTo(@80);
            make.height.equalTo(@44);
        }];
        
        UILabel* secondNotifyLabel = [[UILabel alloc] init];
        secondNotifyLabel.backgroundColor = [UIColor clearColor];
        secondNotifyLabel.text = @"Notify chat requests";
        secondNotifyLabel.font = [UIFont systemFontOfSize:14.f];
        secondNotifyLabel.numberOfLines = 2;
        secondNotifyLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [self.view addSubview:secondNotifyLabel];
        [secondNotifyLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.left).with.offset(20);
            make.top.equalTo(firstNotifyLabel.bottom).with.offset(20);
            make.width.equalTo(@160);
            make.height.equalTo(@30);
        }];
        
        UISwitch* secondSwitch = [[UISwitch alloc] init];
        [self.view addSubview:secondSwitch];
        [secondSwitch makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.view.right).with.offset(-20);
            make.top.equalTo(secondNotifyLabel.top).with.offset(4);
            make.width.equalTo(@80);
            make.height.equalTo(@44);
        }];
    }
    return self;
}

@end
