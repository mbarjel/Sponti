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

@property (nonatomic, strong) UIScrollView* contactsContainerView;
@property (nonatomic, strong) UIView* menuContainerView;

@property (nonatomic, strong) UILabel* contactNameLabel;
@property (nonatomic, strong) UIView* lineView;
@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) UIView* formView;
@property (nonatomic, strong) UITextView* textView;
@property (nonatomic, strong) UIButton* sendButton;

@property (nonatomic, assign) BOOL groupChat;

@property (nonatomic, strong) UITapGestureRecognizer* tapGestureRecognizer;
@property (nonatomic, strong) UIPanGestureRecognizer* panGestureRecognizer;

@property (nonatomic, strong) UILabel* blockedLabel;

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
        
        self.panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didPanView:)];
        [self.chatContainerView addGestureRecognizer:self.panGestureRecognizer];
        
        self.blockedView = [[UIView alloc] init];
        self.blockedView.backgroundColor = [UIColor blackColor];
        self.blockedView.alpha = 0.8;
        [self.chatContainerView addSubview:self.blockedView];
        [self.blockedView makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.chatContainerView);
        }];
        
        self.blockedLabel = [[UILabel alloc] init];
        self.blockedLabel.backgroundColor = [UIColor clearColor];
        self.blockedLabel.font = [UIFont boldSystemFontOfSize:20.f];
        self.blockedLabel.textColor = [UIColor whiteColor];
        self.blockedLabel.text = @"This user is blocked";
        self.blockedLabel.textAlignment = NSTextAlignmentCenter;
        [self.blockedView addSubview:self.blockedLabel];
        [self.blockedLabel makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.blockedView.centerX);
            make.centerY.equalTo(self.blockedView.centerY).with.offset(-10);
            make.height.equalTo(@100);
            make.width.equalTo(@200);
        }];
    }
    return self;
}

- (void)setConversation:(SPConversation *)conversation {
    _conversation = conversation;
    _groupChat = (_conversation.contacts.count > 1);
    
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
        SPContact* contact = [_conversation.contacts anyObject];
        self.contactNameLabel.text = contact.title;
    } else {
        self.contactNameLabel.text = @"";
    }
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
        
        if (!self.tapGestureRecognizer) {
            self.tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
        }
        [self.chatContainerView addGestureRecognizer:self.tapGestureRecognizer];
    } else {
        chatContainerViewFrame.origin.x = 0;
        [self.chatContainerView removeGestureRecognizer:self.tapGestureRecognizer];
    }
    [UIView animateWithDuration:0.25 animations:^{
        self.chatContainerView.frame = chatContainerViewFrame;
    }];
}

- (void)hideKeyboard {
    [self.textView resignFirstResponder];
    if (self.chatContainerView.frame.origin.x != 0) {
        [self.delegate chatView:self didOpenMenu:NO];
    }
}

- (void)didPanView:(UIPanGestureRecognizer *)sender {
    CGFloat openValue = -220;
    CGFloat closedValue = 0;
    
    CGRect chatContainerViewFrame = self.chatContainerView.frame;
    
    if (sender.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [sender translationInView:self];
        
        NSLog(@"%f",translation.x);
        
        CGFloat newValue = chatContainerViewFrame.origin.x + translation.x;
        
        if ((openValue < newValue) && (newValue < closedValue)) {
            NSLog(@"in if with value %f",newValue);
            chatContainerViewFrame.origin.x = newValue;
        } else if (newValue < openValue) {
            NSLog(@"in first else if with value %f",newValue);
            chatContainerViewFrame.origin.x = openValue;
        } else if (newValue > closedValue) {
            NSLog(@"in second else if with value %f",newValue);
            chatContainerViewFrame.origin.x = closedValue;
        }
        self.chatContainerView.frame = chatContainerViewFrame;
    }
    
    if (sender.state == UIGestureRecognizerStateEnded) {
        if (chatContainerViewFrame.origin.x < -110) {
            [self.delegate chatView:self didOpenMenu:NO];
        } else {
            [self.delegate chatView:self didOpenMenu:YES];
        }
    }
    
    [sender setTranslation:CGPointZero inView:self];
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
    
    if (!self.tapGestureRecognizer) {
        self.tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    }
    [self.chatContainerView addGestureRecognizer:self.tapGestureRecognizer];
}

- (void)keyboardWillHide:(NSNotification *)sender {
    [UIView animateWithDuration:0.25 animations:^{
        self.tableView.frame = CGRectMake(0, 41, 320, 346);
        self.formView.frame = CGRectMake(0, self.frame.size.height - 30, self.frame.size.width, 30);
    }];
    [self.chatContainerView removeGestureRecognizer:self.tapGestureRecognizer];
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
    
    [cell setMessage:message withType:type forGroupChat:self.groupChat];

    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    SPMessage* message = [_messages objectAtIndex:indexPath.item];
    if ([message.contactID isEqualToString:@"invite"]) {
        return 20;
    } else {
        CGSize textSize = [message.text sizeWithFont:[UIFont systemFontOfSize:12.f] constrainedToSize:CGSizeMake(200, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
        CGFloat height = textSize.height + 30;
        if (self.groupChat && ![message.contactID isEqualToString:@"0"]) {
            height += 34;
        } else {
            height += 20;
        }
        return height;
    }
}

@end
