//
//  SPPopulateCoreData.m
//  Sponti
//
//  Created by Melad Barjel on 25/09/13.
//  Copyright (c) 2013 Sponti. All rights reserved.
//

#import "SPPopulateCoreData.h"
#import "SPContact.h"
#import "SPConversation.h"
#import "SPMessage.h"

@implementation SPPopulateCoreData

+ (instancetype)sharedManager {
    static id _instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

- (void)populateWithDummyData {
    [self populateContactsWithDummyData];
    [self populateConversationsWithDummyData];
    
//    NSArray* contacts = [SPContact MR_findAll];
//    for (SPContact* contact in contacts) {
//        NSLog(@"---- CONTACT ----");
//        NSLog(@"%@",contact.uid);
//        NSLog(@"%@",contact.title);
//        NSLog(@"%@",contact.imageName);
//        NSLog(@"%@",contact.distance);
//        for (SPConversation* conversation in contact.conversations) {
//            NSLog(@"---- CONVERSATION ----");
//            NSLog(@"%@",conversation.uid);
//            for (SPMessage* message in conversation.messages) {
//                NSLog(@"---- MESSAGE ----");
//                NSLog(@"%@",message.uid);
//                NSLog(@"%@",message.text);
//                NSLog(@"%@",message.contactID);
//                NSLog(@"%@",message.date);
//            }
//            
//        }
//    }
}

- (void)populateContactsWithDummyData {
    NSString *configPath = [[NSBundle mainBundle] pathForResource:@"dummyContacts" ofType:@"plist"];
    for (NSDictionary* contactDict in [[NSMutableArray alloc] initWithContentsOfFile:configPath]) {
        SPContact* contact = [SPContact MR_createEntity];
        contact.uid = contactDict[@"uid"];
        contact.title = contactDict[@"name"];
        contact.imageName = contactDict[@"imageName"];
        contact.distance = [contactDict valueForKey:@"distance"];
        contact.blocked = NO;
        contact.favourite = NO;
    }
    
    [[NSManagedObjectContext MR_contextForCurrentThread] MR_saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
        NSLog(@"POPULATE CONTACTS");
        NSLog(@"SUCCESS: %@", success ? @"YES" : @"NO");
        NSLog(@"ERROR: %@",error.debugDescription);
    }];
}

- (void)populateConversationsWithDummyData {
    NSString* conversationsDataPath = [[NSBundle mainBundle] pathForResource:@"conversationsDummyData" ofType:@"json"];
    
    NSData* data = [NSData dataWithContentsOfFile:conversationsDataPath];
    NSDictionary* dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    
    for (NSDictionary* conversationDict in dictionary[@"conversations"]) {
        SPConversation* conversation = [SPConversation MR_createEntity];
        conversation.uid = conversationDict[@"id"];
        
        NSMutableArray* contacts = [NSMutableArray array];
        for (NSString* contactID in conversationDict[@"contacts"]) {
            SPContact* contact = [SPContact MR_findFirstByAttribute:@"uid" withValue:contactID];
            [contacts addObject:contact];
        }
        conversation.contacts = [NSSet setWithArray:contacts];
        
        NSMutableArray* messages = [NSMutableArray array];
        for (NSDictionary* messageDict in conversationDict[@"messages"]) {
            SPMessage* message = [SPMessage MR_createEntity];
            message.text = messageDict[@"text"];
            message.uid = messageDict[@"id"];
            message.contactID = messageDict[@"contactID"];
            
            NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss z"];
            message.date = [dateFormatter dateFromString:messageDict[@"date"]];
            [messages addObject:message];
        }
        conversation.messages = [NSSet setWithArray:messages];
    }
    
    [[NSManagedObjectContext MR_contextForCurrentThread] MR_saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
        NSLog(@"POPULATE CONVERSATIONS");
        NSLog(@"SUCCESS: %@", success ? @"YES" : @"NO");
        NSLog(@"ERROR: %@",error.debugDescription);
    }];
}

@end
