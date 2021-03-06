//
//  SPChatMenuViewController.m
//  Sponti
//
//  Created by Melad Barjel on 20/09/13.
//  Copyright (c) 2013 Sponti. All rights reserved.
//

#import "SPChatMenuViewController.h"

@interface SPChatMenuViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) SPConversation* conversation;

@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) NSArray* items;

@end

@implementation SPChatMenuViewController

- (id)initWithConversation:(SPConversation *)conversation {
    if (self) {
        self.view.backgroundColor = [UIColor blackColor];
        
        self.conversation = conversation;
        
        if (self.conversation.contacts.count > 1) {
            self.items = @[@"Block",@"Favourite",@"Invite Friend",@"Map",@"Call"];
        } else {
            SPContact* contact = [self.conversation.contacts anyObject];
            self.items = @[[contact.blocked boolValue] ? @"Unblock" : @"Block",[contact.favourite boolValue] ? @"Unfavourite" : @"Favourite",@"Invite Friend",@"Map",@"Call"];
        }
        
        self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        self.tableView.backgroundColor = [UIColor blackColor];
        self.tableView.scrollEnabled = NO;
        [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"tableViewCellReuseIdentifier"];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [self.view addSubview:self.tableView];
        
        [self.tableView makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    return self;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"tableViewCellReuseIdentifier"];
    cell.contentView.backgroundColor = [UIColor blackColor];
    cell.textLabel.text = [self.items objectAtIndex:indexPath.item];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor whiteColor];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.item) {
        case 0:
            [self.delegate didTapOnBlockInChatMenuViewController:self];
            break;
        case 1:
            [self.delegate didTapOnFavouriteInChatMenuViewController:self];
            break;
        case 2:
            [self.delegate didTapOnInviteInChatMenuViewController:self];
            break;
        case 3:
            [self.delegate didTapOnMapInChatMenuViewController:self];
            break;
        case 4:
            [self.delegate didTapOnCallInChatMenuViewController:self];
            break;
        default:
            break;
    }
    
    if (!(self.conversation.contacts.count > 1)) {
        SPContact* contact = [self.conversation.contacts anyObject];
        self.items = @[[contact.blocked boolValue] ? @"Unblock" : @"Block",[contact.favourite boolValue] ? @"Unfavourite" : @"Favourite",@"Invite Contact",@"Map",@"Call"];
        [self.tableView reloadData];
    }
}

@end
