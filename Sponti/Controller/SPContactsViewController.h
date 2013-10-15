//
//  SPContactsViewController.h
//  Sponti
//
//  Created by Melad Barjel on 17/09/13.
//  Copyright (c) 2013 Sponti. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SPContactsManager.h"

@class SPContactsViewController;

@protocol SPContactsViewControllerDelegate <NSObject>

@optional

- (void)contactsViewController:(SPContactsViewController *)contactsViewController didInviteContact:(SPContact *)contact;

@end

@interface SPContactsViewController : UIViewController

@property (nonatomic, assign) BOOL hideButtons;

@property (nonatomic, weak) id<SPContactsViewControllerDelegate> delegate;

- (id)initWithType:(SPContactsType)type;

- (void)filterOutContacts:(NSArray *)contacts;

@end
