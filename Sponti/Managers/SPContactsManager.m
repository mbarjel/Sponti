//
//  SPContactsManager.m
//  Sponti
//
//  Created by Melad Barjel on 17/09/13.
//  Copyright (c) 2013 Sponti. All rights reserved.
//

#import "SPContactsManager.h"

#import "NSArray+SPFunctional.h"

@interface SPContactsManager ()

@end

@implementation SPContactsManager

+ (instancetype)sharedManager {
    static id _instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

- (NSArray *)getContactsForType:(SPContactsType)type {
    if (type == SPContactsTypeFavourites) {
        NSPredicate* predicate = [NSPredicate predicateWithFormat:@"favourite == YES"];
        return [SPContact MR_findAllSortedBy:@"title" ascending:YES withPredicate:predicate];
    } else if (type == SPContactsTypeLocal) {
        NSPredicate* predicate = [NSPredicate predicateWithFormat:@"distance <= 5"];
        return [SPContact MR_findAllSortedBy:@"title" ascending:YES withPredicate:predicate];
    } else if (type == SPContactsTypeRegional) {
        NSPredicate* predicate = [NSPredicate predicateWithFormat:@"distance > 5"];
        return [SPContact MR_findAllSortedBy:@"title" ascending:YES withPredicate:predicate];
    } else {
        return [SPContact MR_findAllSortedBy:@"title" ascending:YES];
    }
}

- (void)updateContact:(SPContact *)contact asFavourite:(BOOL)favourite {
    contact.favourite = [NSNumber numberWithBool:favourite];
    [[NSManagedObjectContext MR_contextForCurrentThread] MR_saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
        NSLog(@"update Favourite");
        NSLog(@"ERROR: %@",error ? error.debugDescription : @"No Errors");
        NSLog(@"SUCCESS : %@", success ? @"YES" : @"NO");
    }];
}

- (void)updateContact:(SPContact *)contact asBlocked:(BOOL)blocked {
    contact.blocked = [NSNumber numberWithBool:blocked];
    [[NSManagedObjectContext MR_contextForCurrentThread] MR_saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
        NSLog(@"update Blocked");
        NSLog(@"ERROR: %@",error ? error.debugDescription : @"No Errors");
        NSLog(@"SUCCESS : %@", success ? @"YES" : @"NO");
    }];
}

- (SPConversation *)getConversationForContact:(SPContact *)contact forGroupChat:(BOOL)groupChat {
    SPConversation* conversation;
    for (SPConversation* contactConversation in [contact.conversations allObjects]) {
        if (groupChat) {
            if (contactConversation.contacts.count > 1) {
                conversation = contactConversation;
            }
        } else {
            if (contactConversation.contacts.count == 1) {
                conversation = contactConversation;
            }
        }
    }
    if (!conversation) {
        conversation = [SPConversation MR_createEntity];
        [conversation addContactsObject:contact];
        
        [[NSManagedObjectContext MR_contextForCurrentThread] MR_saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
            NSLog(@"CREATE CONVERSATION");
            NSLog(@"ERROR: %@",error ? error.debugDescription : @"No Errors");
            NSLog(@"SUCCESS : %@", success ? @"YES" : @"NO");
        }];
        
    }
    return conversation;
}

@end
