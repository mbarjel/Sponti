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

@interface SPContactsViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property (nonatomic, strong) SPContactsManager* contactsManager;
@property (nonatomic, assign) SPContactsType type;
@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) NSArray* filteredContacts;
@property (nonatomic, strong) NSArray* searchResultContacts;

@property (nonatomic, strong) UISearchBar* searchBar;
@property (nonatomic, assign) BOOL displaySearchResults;

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
        
        self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
        self.searchBar.placeholder = @"Search";
        self.searchBar.delegate = self;
        self.searchBar.showsCancelButton = YES;
        
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 368) style:UITableViewStylePlain];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        [self.tableView registerClass:[SPContactTableViewCell class] forCellReuseIdentifier:[SPContactTableViewCell reuseIdentifier]];
        [self.tableView setTableHeaderView:self.searchBar];
        [self.view addSubview:self.tableView];
        self.hideButtons = NO;
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
    _contactsToRemove = contacts;
}

- (void)setHideButtons:(BOOL)hideButtons {
    _hideButtons = hideButtons;
}

#pragma mark - UIKeyboardNotification

- (void)keyboardDidShow:(id)sender {
    self.tableView.frame = CGRectMake(0, 0, 320, 200);
}

- (void)keyboardWillHide:(id)sender {
    self.tableView.frame = CGRectMake(0, 0, 320, 368);
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.displaySearchResults) {
        return self.searchResultContacts.count;
    }
    return self.filteredContacts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SPContactTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:[SPContactTableViewCell reuseIdentifier]];
    SPContact* contact;
    if (self.displaySearchResults) {
        contact = [self.searchResultContacts objectAtIndex:indexPath.item];
    } else {
        contact = [self.filteredContacts objectAtIndex:indexPath.item];
    }
    [cell setContact:contact];
    [cell setHideButtons:_hideButtons];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.f;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SPContact* contact;
    if (self.displaySearchResults) {
        contact = [self.searchResultContacts objectAtIndex:indexPath.item];
    } else {
        contact = [self.filteredContacts objectAtIndex:indexPath.item];
    }
    if (self.type == SPContactsTypeInvite) {
        [self.delegate contactsViewController:self didChooseContact:contact];
    } else {
        if (![contact.blocked boolValue]) {
            SPChatViewController* chatViewController = [[SPChatViewController alloc] initWithConversation:[[SPContactsManager sharedManager] getConversationForContact:contact forGroupChat:NO]];
            [(SPTabViewController *)self.tabBarController pushViewController:chatViewController animated:YES];
        } else {
            [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Cannot begin conversation with blocked user" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
        }
    }
}

#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (![searchBar.text isEqualToString:@""]) {
        self.displaySearchResults = YES;
        NSMutableArray* searchResults = [NSMutableArray array];
        for (SPContact* contact in self.filteredContacts) {
            if ([[contact.title lowercaseString] rangeOfString:[searchText lowercaseString]].location != NSNotFound) {
                [searchResults addObject:contact];
            }
        }
        self.searchResultContacts = [NSArray arrayWithArray:searchResults];
    } else {
        self.displaySearchResults = NO;
        [self.searchBar resignFirstResponder];
    }
    [self.tableView reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    if (![searchBar.text isEqualToString:@""]) {
        self.displaySearchResults = YES;
    } else {
        self.displaySearchResults = NO;
    }
    [self.tableView reloadData];
    [self.searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    self.searchBar.text = @"";
    [self.searchBar resignFirstResponder];
    self.displaySearchResults = NO;
    [self.tableView reloadData];
}

@end
