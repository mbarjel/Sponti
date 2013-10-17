//
//  SPAllContactsViewController.m
//  Sponti
//
//  Created by Melad Barjel on 17/10/13.
//  Copyright (c) 2013 Sponti. All rights reserved.
//

#import "SPAllContactsViewController.h"
#import "SPContactTableViewCell.h"
#import "SPContact.h"

@interface SPAllContactsViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) NSArray* contacts;

@property (nonatomic, strong) UISearchBar* searchBar;
@property (nonatomic, strong) NSArray* searchResultContacts;
@property (nonatomic, assign) BOOL displaySearchResults;

@end

@implementation SPAllContactsViewController

- (id)init {
    self = [super init];
    if (self) {
        self.title = @"All Sponti Friends";
        
        self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
        self.searchBar.placeholder = @"Search";
        self.searchBar.delegate = self;
        self.searchBar.showsCancelButton = YES;
        
        _contacts = [SPContact MR_findAll];
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [_tableView registerClass:[SPContactTableViewCell class] forCellReuseIdentifier:[SPContactTableViewCell reuseIdentifier]];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [_tableView setTableHeaderView:_searchBar];
        [self.view addSubview:_tableView];
        
        [_tableView makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
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
    self.tableView.frame = CGRectMake(0, 0, 320, 200);
}

- (void)keyboardWillHide:(id)sender {
    self.tableView.frame = CGRectMake(0, 0, 320, 420);
}

#pragma mark - UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.displaySearchResults) {
        return self.searchResultContacts.count;
    }
    return _contacts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SPContactTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:[SPContactTableViewCell reuseIdentifier]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    SPContact* contact;
    if (self.displaySearchResults) {
        contact = [self.searchResultContacts objectAtIndex:indexPath.item];
    } else {
        contact = [self.contacts objectAtIndex:indexPath.item];
    }
    [cell setContact:contact];
    [cell setHideButtons:YES];
    return cell;
}

#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (![searchBar.text isEqualToString:@""]) {
        self.displaySearchResults = YES;
        NSMutableArray* searchResults = [NSMutableArray array];
        for (SPContact* contact in self.contacts) {
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
