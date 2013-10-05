//
//  SPContactsManager.h
//  Sponti
//
//  Created by Melad Barjel on 17/09/13.
//  Copyright (c) 2013 Sponti. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SPContact.h"
#import "SPConversation.h"

typedef enum {
    SPContactsTypeFavourites,
    SPContactsTypeLocal,
    SPContactsTypeRegional,
    SPContactsTypeInvite
} SPContactsType;

@interface SPContactsManager : NSObject

+ (instancetype)sharedManager;

- (NSArray *)getContactsForType:(SPContactsType)type;

- (void)updateContact:(SPContact *)contact asFavourite:(BOOL)favourite;
- (void)updateContact:(SPContact *)contact asBlocked:(BOOL)blocked;

- (SPConversation *)getConversationForContact:(SPContact *)contact forGroupChat:(BOOL)groupChat;

@end
