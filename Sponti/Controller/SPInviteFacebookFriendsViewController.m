//
//  SPInviteFacebookFriendsViewController.m
//  Sponti
//
//  Created by Melad Barjel on 17/10/13.
//  Copyright (c) 2013 Sponti. All rights reserved.
//

#import "SPInviteFacebookFriendsViewController.h"
#import "SPContactTableViewCell.h"
#import "SPContact.h"

@interface SPInviteFacebookFriendsViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property (nonatomic, strong) UISearchBar* searchBar;
@property (nonatomic, strong) UIButton* selectAllButton;
@property (nonatomic, strong) UIButton* deselectAllButton;
@property (nonatomic, strong) UIButton* inviteButton;
@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) NSArray* facebookFriends;
@property (nonatomic, strong) NSMutableArray* friendsToInvite;

@property (nonatomic, strong) NSArray* searchResultContacts;
@property (nonatomic, assign) BOOL displaySearchResults;

@end

@implementation SPInviteFacebookFriendsViewController

- (id)init {
    self = [super init];
    if (self) {
        
        self.searchBar = [[UISearchBar alloc] init];
        self.searchBar.placeholder = @"Search";
        self.searchBar.delegate = self;
        self.searchBar.showsCancelButton = YES;
        [self.view addSubview:self.searchBar];
        [self.searchBar makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.left);
            make.top.equalTo(self.view.top);
            make.width.equalTo(self.view.width);
            make.height.equalTo(@44);
        }];
        
        _facebookFriends = [SPContact MR_findAll];
        _friendsToInvite = [NSMutableArray array];
        
        self.title = @"Invite";
        self.view.backgroundColor = [UIColor whiteColor];
        
        _selectAllButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_selectAllButton setTitle:@"Select All" forState:UIControlStateNormal];
        [_selectAllButton addTarget:self action:@selector(didTapButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_selectAllButton];
        
        _deselectAllButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_deselectAllButton setTitle:@"Deselect All" forState:UIControlStateNormal];
        [_deselectAllButton addTarget:self action:@selector(didTapButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_deselectAllButton];
        
        _inviteButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_inviteButton setTitle:@"Invite" forState:UIControlStateNormal];
        [_inviteButton addTarget:self action:@selector(didTapButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_inviteButton];
        
        [_selectAllButton makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.left).with.offset(1);
            make.top.equalTo(_searchBar.bottom).with.offset(1);
            make.height.equalTo(@44);
            make.width.equalTo(@105);
        }];
        
        [_deselectAllButton makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_selectAllButton.right).with.offset(1);
            make.top.equalTo(_searchBar.bottom).with.offset(1);
            make.height.equalTo(@44);
            make.width.equalTo(@105);
        }];
        
        [_inviteButton makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_deselectAllButton.right).with.offset(1);
            make.top.equalTo(_searchBar.bottom).with.offset(1);
            make.height.equalTo(@44);
            make.width.equalTo(@105);
        }];
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[SPContactTableViewCell class] forCellReuseIdentifier:[SPContactTableViewCell reuseIdentifier]];
        [self.view addSubview:_tableView];
        
        [_tableView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.left);
            make.top.equalTo(_inviteButton.bottom).with.offset(1);
            make.right.equalTo(self.view.right);
            make.bottom.equalTo(self.view.bottom);
        }];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - UIKeyboardNotification

- (void)keyboardDidShow:(id)sender {
    self.tableView.frame = CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y, 320, 112);
}

- (void)keyboardWillHide:(id)sender {
    self.tableView.frame = CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y, 320, 324);
}

#pragma mark - UIButton

- (void)didTapButton:(UIButton *)sender {
    if (sender == _selectAllButton) {
        if (self.displaySearchResults) {
            for (SPContact* contact in _searchResultContacts) {
                if (![_friendsToInvite containsObject:contact]) {
                    [_friendsToInvite addObject:contact];
                }
            }
        } else {
            _friendsToInvite = [NSMutableArray arrayWithArray:_facebookFriends];
        }
        [self.tableView reloadData];
    } else if (sender == _deselectAllButton) {
        if (self.displaySearchResults) {
            for (SPContact* contact in _searchResultContacts) {
                if (![_friendsToInvite containsObject:contact]) {
                    [_friendsToInvite removeObject:contact];
                }
            }
        } else {
            _friendsToInvite = [NSMutableArray array];
        }
        [self.tableView reloadData];
    } else {
        if (_friendsToInvite.count > 0) {
            [[[UIAlertView alloc] initWithTitle:@"Invited" message:@"Invite has been sent!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        } else {
            [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Need to select at least one friend to send invite" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }
    }
}

#pragma mark - UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.displaySearchResults) {
        return self.searchResultContacts.count;
    }
    return _facebookFriends.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SPContactTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:[SPContactTableViewCell reuseIdentifier]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    SPContact* contact;
    if (self.displaySearchResults) {
        contact = [self.searchResultContacts objectAtIndex:indexPath.item];
    } else {
        contact = [_facebookFriends objectAtIndex:indexPath.item];
    }
    [cell setHideButtons:YES];
    [cell setContact:contact];
    
    if ([_friendsToInvite containsObject:contact]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SPContact* contact;
    if (self.displaySearchResults) {
        contact = [self.searchResultContacts objectAtIndex:indexPath.item];
    } else {
        contact = [_facebookFriends objectAtIndex:indexPath.item];
    }
    SPContactTableViewCell* cell = (SPContactTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        [_friendsToInvite removeObject:contact];
    } else {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [_friendsToInvite addObject:contact];
    }
}

#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (![searchBar.text isEqualToString:@""]) {
        self.displaySearchResults = YES;
        NSMutableArray* searchResults = [NSMutableArray array];
        for (SPContact* contact in self.facebookFriends) {
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
