//
//  SPChatMenuViewController.h
//  Sponti
//
//  Created by Melad Barjel on 20/09/13.
//  Copyright (c) 2013 Sponti. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SPContact.h"

@class SPChatMenuViewController;

@protocol SPChatMenuViewControllerDelegate <NSObject>

- (void)didTapOnBlockInChatMenuViewController:(SPChatMenuViewController *)chatMenuViewController;
- (void)didTapOnFavouriteInChatMenuViewController:(SPChatMenuViewController *)chatMenuViewController;
- (void)didTapOnInviteInChatMenuViewController:(SPChatMenuViewController *)chatMenuViewController;
- (void)didTapOnMapInChatMenuViewController:(SPChatMenuViewController *)chatMenuViewController;
- (void)didTapOnCallInChatMenuViewController:(SPChatMenuViewController *)chatMenuViewController;

@end

@interface SPChatMenuViewController : UIViewController

@property (nonatomic, weak) id<SPChatMenuViewControllerDelegate> delegate;

- (id)initWithContact:(SPContact *)contact;

@end
