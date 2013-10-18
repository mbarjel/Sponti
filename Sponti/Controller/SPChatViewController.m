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

@property (nonatomic, assign) BOOL block;
@property (nonatomic, assign) BOOL favourite;
@property (nonatomic, assign) BOOL invite;
@property (nonatomic, assign) BOOL map;
@property (nonatomic, assign) BOOL call;

@end

@implementation SPChatViewController

- (id)initWithConversation:(SPConversation *)conversation {
    self = [super init];
    if (self) {
        self.title = @"Chat";
        self.conversation = conversation;
        self.groupChat = (self.conversation.contacts.count > 1);
        
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
    [self.chatView setConversation:self.conversation];
    
    self.chatView.blockedView.hidden = (self.groupChat || ![self.contact.blocked boolValue]);
    
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
    CGFloat originX = self.chatView.chatContainerView.frame.origin.x;
    if ((originX > -100.f && originX != 0) || originX == -220.f) {
        self.menuIsOpen = NO;
    } else {
        self.menuIsOpen = YES;
    }
    [self.chatView openMenu:self.menuIsOpen];
}

- (void)keyboardWillShow:(NSNotification *)sender {
    [self.chatView keyboardWillShow:sender];
}

- (void)keyboardWillHide:(NSNotification *)sender {
    [self.chatView keyboardWillHide:sender];
    
}

#pragma mark - SPChatMenuViewControllerDelegate

- (void)didTapOnBlockInChatMenuViewController:(SPChatMenuViewController *)chatMenuViewController {
    if (self.chatView.conversation.contacts.count > 1) {
        _block = YES;
        _favourite = NO;
        _invite = NO;
        _map = NO;
        _call = NO;
        
        NSMutableArray* contacts = [[SPContact MR_findAll] mutableCopy];
        for (SPContact* contact in [self.conversation.contacts allObjects]) {
            [contacts removeObject:contact];
        }
        
        SPContactsViewController* contactsViewController = [[SPContactsViewController alloc] initWithType:SPContactsTypeInvite];
        contactsViewController.delegate = self;
        [contactsViewController filterOutContacts:contacts];
        [contactsViewController setHideButtons:YES];
        [self.navigationController pushViewController:contactsViewController animated:YES];
        
    } else {
        self.contact.blocked = [NSNumber numberWithBool:![self.contact.blocked boolValue]];
        self.chatView.blockedView.hidden = ![self.contact.blocked boolValue];
        [self didTapOnMenuBarButtonItem];
    }
}

- (void)didTapOnFavouriteInChatMenuViewController:(SPChatMenuViewController *)chatMenuViewController {
    if (self.chatView.conversation.contacts.count > 1) {
        _block = NO;
        _favourite = YES;
        _invite = NO;
        _map = NO;
        _call = NO;
        
        NSMutableArray* contacts = [[SPContact MR_findAll] mutableCopy];
        for (SPContact* contact in [self.conversation.contacts allObjects]) {
            [contacts removeObject:contact];
        }
        
        SPContactsViewController* contactsViewController = [[SPContactsViewController alloc] initWithType:SPContactsTypeInvite];
        contactsViewController.delegate = self;
        [contactsViewController filterOutContacts:contacts];
        [contactsViewController setHideButtons:YES];
        [self.navigationController pushViewController:contactsViewController animated:YES];
        
    } else {
        self.contact.favourite = [NSNumber numberWithBool:![self.contact.favourite boolValue]];
        [self didTapOnMenuBarButtonItem];
        
        SPMessage* message = [SPMessage MR_createEntity];
        message.contactID = @"invite";
        message.text = [NSString stringWithFormat:@"%@ %@ favourites",self.contact.title,[self.contact.favourite boolValue] ? @"added to" : @"removed from"];
        message.date = [NSDate date];
        [self.chatView.conversation addMessagesObject:message];
        
        [[NSManagedObjectContext MR_contextForCurrentThread] MR_saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
            [self.chatView setConversation:self.conversation];
            NSLog(@"Add CONTACT TO CONVERSATIONS");
            NSLog(@"SUCCESS: %@", success ? @"YES" : @"NO");
            NSLog(@"ERROR: %@",error.debugDescription);
        }];
    }
}

- (void)didTapOnInviteInChatMenuViewController:(SPChatMenuViewController *)chatMenuViewController {
    _block = NO;
    _favourite = NO;
    _invite = YES;
    _map = NO;
    _call = NO;
    SPContactsViewController* contactsViewController = [[SPContactsViewController alloc] initWithType:SPContactsTypeInvite];
    contactsViewController.delegate = self;
    [contactsViewController filterOutContacts:[self.chatView.conversation.contacts allObjects]];
    [contactsViewController setHideButtons:YES];
    [self.navigationController pushViewController:contactsViewController animated:YES];
}

- (void)didTapOnMapInChatMenuViewController:(SPChatMenuViewController *)chatMenuViewController {
    if (self.chatView.conversation.contacts.count > 1) {
        _block = NO;
        _favourite = NO;
        _invite = NO;
        _map = YES;
        _call = NO;
        
        NSMutableArray* contacts = [[SPContact MR_findAll] mutableCopy];
        for (SPContact* contact in [self.conversation.contacts allObjects]) {
            [contacts removeObject:contact];
        }
        
        SPContactsViewController* contactsViewController = [[SPContactsViewController alloc] initWithType:SPContactsTypeInvite];
        contactsViewController.delegate = self;
        [contactsViewController filterOutContacts:contacts];
        [contactsViewController setHideButtons:YES];
        [self.navigationController pushViewController:contactsViewController animated:YES];
    } else {
        SPMapViewController* mapViewController = [[SPMapViewController alloc] initWithContact:[self.conversation.contacts anyObject]];
        [self.navigationController pushViewController:mapViewController animated:YES];
    }
}

- (void)didTapOnCallInChatMenuViewController:(SPChatMenuViewController *)chatMenuViewController {
    if (self.chatView.conversation.contacts.count > 1) {
        _block = NO;
        _favourite = NO;
        _invite = NO;
        _map = NO;
        _call = YES;
        
        NSMutableArray* contacts = [[SPContact MR_findAll] mutableCopy];
        for (SPContact* contact in [self.conversation.contacts allObjects]) {
            [contacts removeObject:contact];
        }
        
        SPContactsViewController* contactsViewController = [[SPContactsViewController alloc] initWithType:SPContactsTypeInvite];
        contactsViewController.delegate = self;
        [contactsViewController filterOutContacts:contacts];
        [contactsViewController setHideButtons:YES];
        [self.navigationController pushViewController:contactsViewController animated:YES];
    } else {
        SPCallViewController* callViewController = [[SPCallViewController alloc] initWithContact:[self.conversation.contacts anyObject]];
        [self.navigationController pushViewController:callViewController animated:YES];
    }
}

#pragma mark - SPContactsViewControllerDelegate

- (void)contactsViewController:(SPContactsViewController *)contactsViewController didChooseContact:(SPContact *)contact {
    if (_invite) {
        [self.chatView.conversation addContactsObject:contact];
        
        SPMessage* message = [SPMessage MR_createEntity];
        message.contactID = @"invite";
        message.text = [NSString stringWithFormat:@"%@ added to conversation",contact.title];
        message.date = [NSDate date];
        [self.chatView.conversation addMessagesObject:message];
        
        [[NSManagedObjectContext MR_contextForCurrentThread] MR_saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
            [self.chatView setConversation:self.conversation];
            NSLog(@"Add CONTACT TO CONVERSATIONS");
            NSLog(@"SUCCESS: %@", success ? @"YES" : @"NO");
            NSLog(@"ERROR: %@",error.debugDescription);
        }];
        
        [self.navigationController popViewControllerAnimated:YES];
        [self didTapOnMenuBarButtonItem];
    } else if (_favourite) {
        contact.favourite = [NSNumber numberWithBool:![contact.favourite boolValue]];
        [self didTapOnMenuBarButtonItem];
        
        SPMessage* message = [SPMessage MR_createEntity];
        message.contactID = @"invite";
        message.text = [NSString stringWithFormat:@"%@ %@ favourites",self.contact.title,[contact.favourite boolValue] ? @"added to" : @"removed from"];
        message.date = [NSDate date];
        [self.chatView.conversation addMessagesObject:message];
        
        [[NSManagedObjectContext MR_contextForCurrentThread] MR_saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
            [self.chatView setConversation:self.conversation];
            NSLog(@"Add CONTACT TO CONVERSATIONS");
            NSLog(@"SUCCESS: %@", success ? @"YES" : @"NO");
            NSLog(@"ERROR: %@",error.debugDescription);
        }];
        [self.navigationController popViewControllerAnimated:YES];
    } else if (_block) {
        contact.blocked = [NSNumber numberWithBool:![contact.blocked boolValue]];
        self.chatView.blockedView.hidden = YES;//![contact.blocked boolValue];
        [self didTapOnMenuBarButtonItem];
        [self.navigationController popViewControllerAnimated:YES];
    } else if (_map) {
        SPMapViewController* mapViewController = [[SPMapViewController alloc] initWithContact:contact];
        [self.navigationController pushViewController:mapViewController animated:YES];
    } else {
        SPCallViewController* callViewController = [[SPCallViewController alloc] initWithContact:contact];
        [self.navigationController pushViewController:callViewController animated:YES];
    }
}

#pragma mark - SPChatViewDelegate

- (void)chatView:(SPChatView *)chatView didOpenMenu:(BOOL)openMenu {
    [self didTapOnMenuBarButtonItem];
}

@end
