//
//  SPContactsViewController.m
//  Sponti
//
//  Created by Melad Barjel on 17/09/13.
//  Copyright (c) 2013 Sponti. All rights reserved.
//

#import "SPContactsViewController.h"
#import "SPContact.h"
#import "SPTabViewController.h"
#import "SPContactTableViewCell.h"
#import "SPChatViewController.h"
#import "NSArray+SPFunctional.h"

@interface SPContactsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) SPContactsManager* contactsManager;
@property (nonatomic, assign) SPContactsType type;
@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) NSArray* filteredContacts;
@property (nonatomic, strong) NSArray* contactsToRemove;

@property (nonatomic, strong) UIBarButtonItem* editBarButtonItem;

@end

@implementation SPContactsViewController

- (id)initWithType:(SPContactsType)type {
    self = [super init];
    if (self) {
        self.type = type;
        self.editing = NO;
        self.contactsManager = [SPContactsManager sharedManager];
        
        self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        [self.tableView registerClass:[SPContactTableViewCell class] forCellReuseIdentifier:[SPContactTableViewCell reuseIdentifier]];
        [self.view addSubview:self.tableView];
        
        [self.tableView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.left);
            make.top.equalTo(self.view.top);
            make.right.equalTo(self.view.right);
            make.bottom.equalTo(self.view.bottom);
        }];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.title = self.title;
    self.filteredContacts = [self.contactsManager getContactsForType:self.type];
    
    if (self.type == SPContactsTypeInvite) {
        self.filteredContacts = [self.filteredContacts reject:^BOOL(SPContact* contact) {
            for (SPContact* contactToRemove in _contactsToRemove) {
                if ([contactToRemove.uid isEqualToString:contact.uid]) {
                    return YES;
                }
            }
            return NO;
        }];
    }
    
    [self.tableView reloadData];
}

- (void)setType:(SPContactsType)type {
    _type = type;
    switch (type) {
        case SPContactsTypeFavourites:
            self.title = @"Favourites";
            break;
        case SPContactsTypeLocal:
            self.title = @"Local";
            break;
        case SPContactsTypeRegional:
            self.title = @"Regional";
            break;
        case SPContactsTypeInvite:
            self.title = @"Invite";
            break;
    }
}

- (void)filterOutContacts:(NSArray *)contacts {
    for (SPContact* contact in contacts) {
        NSLog(@"%@",contact.title);
    }
    _contactsToRemove = contacts;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.filteredContacts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SPContactTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:[SPContactTableViewCell reuseIdentifier]];
    SPContact* contact = [self.filteredContacts objectAtIndex:indexPath.item];
    [cell setContact:contact];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.f;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SPContact* contact = [self.filteredContacts objectAtIndex:indexPath.item];
    if (self.type == SPContactsTypeInvite) {
        [self.delegate contactsViewController:self didInviteContact:contact];
    } else {
        SPChatViewController* chatViewController = [[SPChatViewController alloc] initWithContact:contact];
        [(SPTabViewController *)self.tabBarController pushViewController:chatViewController animated:YES];
    }
}

@end
