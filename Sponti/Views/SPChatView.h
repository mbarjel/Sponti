//
//  SPChatView.h
//  Sponti
//
//  Created by Melad Barjel on 18/09/13.
//  Copyright (c) 2013 Sponti. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SPContact.h"


@class SPChatView;

@protocol SPChatViewDelagate <NSObject>

- (void)chatView:(SPChatView *)chatView didOpenMenu:(BOOL)openMenu;

@end

@interface SPChatView : UIView

@property (nonatomic, strong) UIView* chatContainerView;
@property (nonatomic, strong) SPConversation* conversation;
@property (nonatomic, strong) UIView* blockedView;
@property (nonatomic, assign) id<SPChatViewDelagate> delegate;

- (void)keyboardWillShow:(NSNotification *)sender;
- (void)keyboardWillHide:(NSNotification *)sender;

- (void)setMenuView:(UIView *)menuView;
- (void)openMenu:(BOOL)openMenu;

//- (void)setContact:(SPContact *)contact forGroupChat:(BOOL)groupChat;

@end
