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

@interface SPChatViewController () <SPChatMenuViewControllerDelegate, SPContactsViewControllerDelegate>

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
        
        self.menuIsOpen = NO;
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
        
        self.menuIsOpen = NO;
    }
    return self;
}

- (void)loadView {
    self.chatView = [[SPChatView alloc] init];
    [self.chatView setContact:self.contact forGroupChat:self.groupChat];
    
    [self.chatView setMenuView:self.menuViewController.view];
    
    self.view = self.chatView;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [self displayOverlay];
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

- (void)displayOverlay {
    if(![[NSUserDefaults standardUserDefaults] valueForKey:@"chatOverlay"]) {
        _chatOverlayImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"chatOverlay.jpg"]];
        _chatOverlayImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer* tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeOverlay)];
        [_chatOverlayImageView addGestureRecognizer:tapGestureRecognizer];
        _chatOverlayImageView.alpha = 0.75;
        _chatOverlayImageView.frame = CGRectMake(0, 0, 320, 416);
        [self.view addSubview:_chatOverlayImageView];
    }
}

- (void)removeOverlay {
    [[NSUserDefaults standardUserDefaults] setValue:@YES forKey:@"chatOverlay"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [UIView animateWithDuration:0.25 animations:^{
        _chatOverlayImageView.alpha = 0.f;
    } completion:^(BOOL finished) {
        [_chatOverlayImageView removeFromSuperview];
        _chatOverlayImageView = nil;
    }];
}

#pragma mark - SPChatMenuViewControllerDelegate

- (void)didTapOnBlockInChatMenuViewController:(SPChatMenuViewController *)chatMenuViewController {
    self.contact.blocked = [NSNumber numberWithBool:![self.contact.blocked boolValue]];
}

- (void)didTapOnFavouriteInChatMenuViewController:(SPChatMenuViewController *)chatMenuViewController {
    self.contact.favourite = [NSNumber numberWithBool:![self.contact.favourite boolValue]];
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
    
    [[NSManagedObjectContext MR_contextForCurrentThread] MR_saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
        [self.chatView setContact:contact forGroupChat:YES];
        NSLog(@"Add CONTACT TO CONVERSATIONS");
        NSLog(@"SUCCESS: %@", success ? @"YES" : @"NO");
        NSLog(@"ERROR: %@",error.debugDescription);
    }];
    
    [self.navigationController popViewControllerAnimated:YES];
    [self didTapOnMenuBarButtonItem];
}

@end
