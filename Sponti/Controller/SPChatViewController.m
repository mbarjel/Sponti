//
//  SPChatViewController.m
//  Sponti
//
//  Created by Melad Barjel on 18/09/13.
//  Copyright (c) 2013 Sponti. All rights reserved.
//

#import "SPChatViewController.h"
#import "SPChatView.h"

#import "SPChatMenuViewController.h"
#import "SPContactsViewController.h"
#import "SPMapViewController.h"
#import "SPCallViewController.h"

#import "SPConversation.h"
#import "SPMessage.h"

@interface SPChatViewController () <SPChatMenuViewControllerDelegate, SPContactsViewControllerDelegate, SPChatViewDelagate>

@property (nonatomic, strong) SPContact* contact;
@property (nonatomic, strong) SPConversation* conversation;
@property (nonatomic, strong) SPChatView* chatView;

@property (nonatomic, strong) SPChatMenuViewController* menuViewController;

@property (nonatomic, assign) BOOL menuIsOpen;
@property (nonatomic, assign) BOOL groupChat;

@property (nonatomic, strong) UIImageView* chatOverlayImageView;

@end

@implementation SPChatViewController

- (id)initWithContact:(SPContact *)contact {
    self = [super init];
    if (self) {
        self.title = contact.title;
        self.groupChat = NO;
        self.contact = contact;
        UIBarButtonItem* menuBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStylePlain target:self action:@selector(didTapOnMenuBarButtonItem)];
        self.navigationItem.rightBarButtonItem = menuBarButtonItem;
        
        self.menuViewController = [[SPChatMenuViewController alloc] initWithContact:self.contact];
        self.menuViewController.delegate = self;
        [self addChildViewController:self.menuViewController];
        [self.menuViewController didMoveToParentViewController:self];
    }
    return self;
}

- (id)initWithConversation:(SPConversation *)conversation {
    self = [super init];
    if (self) {
        self.title = @"Chat";
        self.conversation = conversation;
        self.groupChat = (self.conversation.contacts.count > 1);
        
        self.contact = [self.conversation.contacts anyObject];
        
        UIBarButtonItem* menuBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStylePlain target:self action:@selector(didTapOnMenuBarButtonItem)];
        self.navigationItem.rightBarButtonItem = menuBarButtonItem;
        
        self.menuViewController = [[SPChatMenuViewController alloc] initWithContact:[self.conversation.contacts anyObject]];
        self.menuViewController.delegate = self;
        [self addChildViewController:self.menuViewController];
        [self.menuViewController didMoveToParentViewController:self];
    }
    return self;
}

- (void)loadView {
    self.chatView = [[SPChatView alloc] init];
    self.chatView.delegate = self;
    [self.chatView setContact:self.contact forGroupChat:self.groupChat];
    
    [self.chatView setMenuView:self.menuViewController.view];
    
    self.view = self.chatView;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    self.menuIsOpen = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didTapOnMenuBarButtonItem {
    [self.chatView openMenu:!self.menuIsOpen];
    self.menuIsOpen = !self.menuIsOpen;
}

- (void)keyboardWillShow:(NSNotification *)sender {
    [self.chatView keyboardWillShow:sender];
}

- (void)keyboardWillHide:(NSNotification *)sender {
    [self.chatView keyboardWillHide:sender];
    
}

#pragma mark - SPChatMenuViewControllerDelegate

- (void)didTapOnBlockInChatMenuViewController:(SPChatMenuViewController *)chatMenuViewController {
    self.contact.blocked = [NSNumber numberWithBool:![self.contact.blocked boolValue]];
    [self didTapOnMenuBarButtonItem];
}

- (void)didTapOnFavouriteInChatMenuViewController:(SPChatMenuViewController *)chatMenuViewController {
    self.contact.favourite = [NSNumber numberWithBool:![self.contact.favourite boolValue]];
    [self didTapOnMenuBarButtonItem];
}

- (void)didTapOnInviteInChatMenuViewController:(SPChatMenuViewController *)chatMenuViewController {
    SPContactsViewController* contactsViewController = [[SPContactsViewController alloc] initWithType:SPContactsTypeInvite];
    contactsViewController.delegate = self;
    [contactsViewController filterOutContacts:[self.chatView.conversation.contacts allObjects]];
    [self.navigationController pushViewController:contactsViewController animated:YES];
}

- (void)didTapOnMapInChatMenuViewController:(SPChatMenuViewController *)chatMenuViewController {
    SPMapViewController* mapViewController = [[SPMapViewController alloc] initWithContact:[self.chatView.conversation.contacts anyObject]];
    [self.navigationController pushViewController:mapViewController animated:YES];
}

- (void)didTapOnCallInChatMenuViewController:(SPChatMenuViewController *)chatMenuViewController {
    SPCallViewController* callViewController = [[SPCallViewController alloc] initWithContact:[self.chatView.conversation.contacts anyObject]];
    [self.navigationController pushViewController:callViewController animated:YES];
    
}

#pragma mark - SPContactsViewControllerDelegate

- (void)contactsViewController:(SPContactsViewController *)contactsViewController didInviteContact:(SPContact *)contact {
    [self.chatView.conversation addContactsObject:contact];
    
    SPMessage* message = [SPMessage MR_createEntity];
    message.contactID = @"invite";
    message.text = [NSString stringWithFormat:@"%@ added to conversation",contact.title];
    message.date = [NSDate date];
    [self.chatView.conversation addMessagesObject:message];
    
    [[NSManagedObjectContext MR_contextForCurrentThread] MR_saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
        [self.chatView setContact:contact forGroupChat:YES];
        NSLog(@"Add CONTACT TO CONVERSATIONS");
        NSLog(@"SUCCESS: %@", success ? @"YES" : @"NO");
        NSLog(@"ERROR: %@",error.debugDescription);
    }];
    
    [self.navigationController popViewControllerAnimated:YES];
    [self didTapOnMenuBarButtonItem];
}

#pragma mark - SPChatViewDelegate

- (void)didCloseMenuInChatView:(SPChatView *)chatView {
    [self didTapOnMenuBarButtonItem];
}

@end
