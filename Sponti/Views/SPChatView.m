//
//  SPChatView.m
//  Sponti
//
//  Created by Melad Barjel on 18/09/13.
//  Copyright (c) 2013 Sponti. All rights reserved.
//

#import "SPChatView.h"
#import "SPConversation.h"
#import "SPMessage.h"
#import "SPMessageTableViewCell.h"
#import "SPContactsManager.h"

@interface SPChatView () <UITextViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray* messages;

@property (nonatomic, strong) UIView* chatContainerView;
@property (nonatomic, strong) UIScrollView* contactsContainerView;
@property (nonatomic, strong) UIView* menuContainerView;

@property (nonatomic, strong) UILabel* contactNameLabel;
@property (nonatomic, strong) UIView* lineView;
@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) UIView* formView;
@property (nonatomic, strong) UITextView* textView;
@property (nonatomic, strong) UIButton* sendButton;

@property (nonatomic, strong) SPContact* contact;

@end

@implementation SPChatView

- (id)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        self.menuContainerView = [[UIView alloc] init];
        [self addSubview:self.menuContainerView];
        
        [self.menuContainerView makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self).insets(UIEdgeInsetsMake(0, 100, 0, 0));
        }];
        
        self.chatContainerView = [[UIView alloc] init];
        self.chatContainerView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.chatContainerView];
        
        [self.chatContainerView makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        self.contactsContainerView = [[UIScrollView alloc] init];
        self.contactsContainerView.backgroundColor = [UIColor grayColor];
        self.contactsContainerView.frame = CGRectMake(0, 0, 320, 40);
        [self.chatContainerView addSubview:self.contactsContainerView];
        
        self.contactNameLabel = [[UILabel alloc] init];
        self.contactNameLabel.backgroundColor = [UIColor clearColor];
        self.contactNameLabel.font = [UIFont systemFontOfSize:14.f];
        [self.contactsContainerView addSubview:self.contactNameLabel];
        
        [self.contactNameLabel makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contactsContainerView.centerY);
            make.left.equalTo(@50);
            make.right.equalTo(self.right).with.offset(-10);
        }];
        
        self.lineView = [[UIView alloc] init];
        self.lineView.backgroundColor = [UIColor blackColor];
        [self.chatContainerView addSubview:self.lineView];
        self.lineView.frame = CGRectMake(0, 40, 320, 1);
        
        self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        self.tableView.backgroundColor = [UIColor lightGrayColor];
        [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [self.tableView registerClass:[SPMessageTableViewCell class] forCellReuseIdentifier:[SPMessageTableViewCell reuseIdentifier]];
        
        self.tableView.contentSize = CGSizeMake(320, 2000);
        [self.chatContainerView addSubview:self.tableView];
        
        self.formView = [[UIView alloc] init];
        self.formView.backgroundColor = [UIColor whiteColor];
        [self.chatContainerView addSubview:self.formView];
        
        self.textView = [[UITextView alloc] init];
        self.textView.scrollEnabled = NO;
        self.textView.delegate = self;
        self.textView.font = [UIFont systemFontOfSize:14.f];
        [self.formView addSubview:self.textView];
        
        self.sendButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [self.sendButton setTitle:@"Send" forState:UIControlStateNormal];
        [self.sendButton addTarget:self action:@selector(didTapOnSendButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.formView addSubview:self.sendButton];
    }
    return self;
}

- (void)setContact:(SPContact *)contact forGroupChat:(BOOL)groupChat {
    _contact = contact;
    
    _conversation = [[SPContactsManager sharedManager] getConversationForContact:_contact forGroupChat:groupChat];
    if (_conversation.messages.count) {
        _messages = [SPMessage MR_findByAttribute:@"conversation" withValue:_conversation andOrderBy:@"date" ascending:YES];
        [self.tableView reloadData];
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:_messages.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    } else {
        _messages = [NSArray array];
    }
    
    for (SPContact* contactInConversation in [_conversation.contacts allObjects]) {
        UIImageView* imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:contactInConversation.imageName]];
        imageView.frame = CGRectMake([[_conversation.contacts allObjects] indexOfObject:contactInConversation] * 40, 0, 40, 40);
        [self.contactsContainerView addSubview:imageView];
        self.contactsContainerView.contentSize = CGSizeMake(imageView.frame.origin.x + imageView.frame.size.width, 40);
    }
    
    if (_conversation.contacts.count == 1) {
        self.contactNameLabel.text = _contact.title;
    } else {
        self.contactNameLabel.text = @"";
    }
}

- (void)createConversation {
    SPConversation* converstaion = [SPConversation MR_createEntity];
    [converstaion addContactsObject:_contact];
}

- (void)setMenuView:(UIView *)menuView {
    [self.menuContainerView addSubview:menuView];
    [menuView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.menuContainerView);
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.tableView.frame = CGRectMake(0, 41, 320, 346);
    self.formView.frame = CGRectMake(0, self.frame.size.height - 30, self.frame.size.width, 30);
    self.textView.frame = CGRectMake(0, 0, 260, 30);
    self.sendButton.frame = CGRectMake(260, 0, 60, 30);
}

- (void)openMenu:(BOOL)openMenu {
    [self.textView resignFirstResponder];
    CGRect chatContainerViewFrame = self.chatContainerView.frame;
    
    self.tableView.userInteractionEnabled = !openMenu;
    self.sendButton.userInteractionEnabled = !openMenu;
    self.textView.userInteractionEnabled = !openMenu;
    
    if (openMenu) {
        chatContainerViewFrame.origin.x = -220.f;
    } else {
        chatContainerViewFrame.origin.x = 0;
    }
    [UIView animateWithDuration:0.25 animations:^{
        self.chatContainerView.frame = chatContainerViewFrame;
    }];
}

#pragma mark - NSNotification

- (void)keyboardWillShow:(NSNotification *)sender {
    CGRect keyboardBounds;
    [[sender.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardBounds];
    
    CGRect formViewFrame = self.formView.frame;
    formViewFrame.origin.y -= keyboardBounds.size.height;
    
    CGRect tableViewFrame = self.tableView.frame;
    tableViewFrame.size.height -= keyboardBounds.size.height;
    
    [UIView animateWithDuration:0.25 animations:^{
        self.formView.frame = formViewFrame;
        self.tableView.frame = tableViewFrame;
    }];
    
    if (_messages.count) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:_messages.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }
}

- (void)keyboardWillHide:(NSNotification *)sender {
    [UIView animateWithDuration:0.25 animations:^{
        self.tableView.frame = CGRectMake(0, 41, 320, 346);
        self.formView.frame = CGRectMake(0, self.frame.size.height - 30, self.frame.size.width, 30);
    }];
}

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView {
    CGSize newSize = [self.textView.text sizeWithFont:[UIFont systemFontOfSize:14.f] constrainedToSize:CGSizeMake(self.textView.contentSize.width - 15,CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    
    if (self.textView.hasText) {
        if (newSize.height <= 54) {
            [self.textView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
            CGRect textViewFrame = self.textView.frame;
			textViewFrame.size.height = newSize.height + 12;
			self.textView.frame = textViewFrame;
            
            CGRect formViewFrame = self.formView.frame;
            formViewFrame.size.height = newSize.height + 30;
            formViewFrame.origin.y = 170 - (newSize.height - 18);
            self.formView.frame = formViewFrame;
            
			CGRect tableViewFrame = self.tableView.frame;
			tableViewFrame.size.height = 130 - (newSize.height - 18);
			self.tableView.frame = tableViewFrame;
            
            self.sendButton.frame = CGRectMake(260, self.formView.frame.size.height - 48, 60, 30);
        }
        if (newSize.height > 54) {
            self.textView.scrollEnabled = YES;
        }
    }
}

#pragma mark - UIButton

- (void)didTapOnSendButton:(UIButton *)sender {
    if (self.textView.text.length) {
        SPMessage* message = [SPMessage MR_createEntity];
        message.text = self.textView.text;
        message.date = [NSDate date];
        message.contactID = @"0";
        message.conversation = self.conversation;
        
        NSMutableArray* allMessages = [NSMutableArray arrayWithArray:_messages];
        [allMessages addObject:message];
        
        _messages = [NSArray arrayWithArray:allMessages];
        
        NSIndexPath* newIndexPath = [NSIndexPath indexPathForItem:_messages.count-1 inSection:0];
        [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationBottom];
        [self.tableView scrollToRowAtIndexPath:newIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        
        self.textView.text = @"";
        
        [[NSManagedObjectContext MR_contextForCurrentThread] MR_saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
            NSLog(@"ADD MESSAGE");
            NSLog(@"SUCCESS: %@", success ? @"YES" : @"NO");
            NSLog(@"ERROR: %@",error.debugDescription);
        }];
    } else {
        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Cant sent empty message" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _messages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SPMessageTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:[SPMessageTableViewCell reuseIdentifier]];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    SPMessage* message = [_messages objectAtIndex:indexPath.item];
    
    SPMessageType type;
    if ([message.contactID isEqualToString:@"0"]) {
        type = SPMessageTypeSent;
    } else if ([message.contactID isEqualToString:@"invite"]) {
        type = SPMessageTypeInvite;
    } else {
        type = SPMessageTypeReceived;
    }
    
    [cell setMessageText:message.text withType:type];

    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    SPMessage* message = [_messages objectAtIndex:indexPath.item];
    if ([message.contactID isEqualToString:@"invite"]) {
        return 20;
    } else {
        CGSize textSize = [message.text sizeWithFont:[UIFont systemFontOfSize:12.f] constrainedToSize:CGSizeMake(200, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
        return textSize.height + 20;
    }
}

@end
