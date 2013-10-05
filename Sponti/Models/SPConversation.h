//
//  SPConversation.h
//  Sponti
//
//  Created by Melad Barjel on 26/09/13.
//  Copyright (c) 2013 Sponti. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SPContact, SPMessage;

@interface SPConversation : NSManagedObject

@property (nonatomic, retain) NSString * uid;
@property (nonatomic, retain) NSSet *messages;
@property (nonatomic, retain) NSSet *contacts;
@end

@interface SPConversation (CoreDataGeneratedAccessors)

- (void)addMessagesObject:(SPMessage *)value;
- (void)removeMessagesObject:(SPMessage *)value;
- (void)addMessages:(NSSet *)values;
- (void)removeMessages:(NSSet *)values;

- (void)addContactsObject:(SPContact *)value;
- (void)removeContactsObject:(SPContact *)value;
- (void)addContacts:(NSSet *)values;
- (void)removeContacts:(NSSet *)values;

@end
