//
//  SPChatsViewController.m
//  Sponti
//
//  Created by Melad Barjel on 17/09/13.
//  Copyright (c) 2013 Sponti. All rights reserved.
//

#import "SPChatsViewController.h"
#import "SPContactTableViewCell.h"
#import "SPConversation.h"
#import "SPChatViewController.h"
#import "SPTabViewController.h"

@interface SPChatsViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) NSArray* conversations;

@property (nonatomic, strong) NSArray* searchResultConversations;

@property (nonatomic, strong) UISearchBar* searchBar;
@property (nonatomic, assign) BOOL displaySearchResults;

@end

@implementation SPChatsViewController

- (id)init {
    self = [super init];
    if (self) {
        self.title = @"Chats";
        self.view.backgroundColor = [UIColor whiteColor];
        
        self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
        self.searchBar.placeholder = @"Search";
        self.searchBar.delegate = self;
        self.searchBar.showsCancelButton = YES;
        
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 368) style:UITableViewStylePlain];
        [self.tableView registerClass:[SPContactTableViewCell class] forCellReuseIdentifier:[SPContactTableViewCell reuseIdentifier]];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        [self.tableView setTableHeaderView:self.searchBar];
        [self.view addSubview:self.tableView];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.title = self.title;
    
    self.conversations = [SPConversation MR_findAll];
    
    [self.tableView reloadData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
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
        return self.searchResultConversations.count;
    }
    return self.conversations.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SPContactTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:[SPContactTableViewCell reuseIdentifier]];
    SPConversation* conversation;
    if (self.displaySearchResults) {
        conversation = [self.searchResultConversations objectAtIndex:indexPath.item];
    } else {
        conversation = [self.conversations objectAtIndex:indexPath.item];
    }
    
    [cell setConversation:conversation];
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SPConversation* conversation;
    if (self.displaySearchResults) {
        conversation = [self.searchResultConversations objectAtIndex:indexPath.item];
    } else {
        conversation = [self.conversations objectAtIndex:indexPath.item];
    }
    SPChatViewController* chatViewController = [[SPChatViewController alloc] initWithConversation:conversation];
    [(SPTabViewController *)self.tabBarController pushViewController:chatViewController animated:YES];
}

#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (![searchBar.text isEqualToString:@""]) {
        self.displaySearchResults = YES;
        NSMutableArray* searchResults = [NSMutableArray array];
        for (SPConversation* conversation in self.conversations) {
            BOOL foundMatch = NO;
            for (SPContact* contact in [conversation.contacts allObjects]) {
                if ([[contact.title lowercaseString] rangeOfString:[searchText lowercaseString]].location != NSNotFound) {
                    foundMatch = YES;
                }
            }
            if (foundMatch) {
                [searchResults addObject:conversation];
            }
        }
        self.searchResultConversations = [NSArray arrayWithArray:searchResults];
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
