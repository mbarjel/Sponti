//
//  SPContact.h
//  Sponti
//
//  Created by Melad Barjel on 26/09/13.
//  Copyright (c) 2013 Sponti. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SPConversation;

@interface SPContact : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * uid;
@property (nonatomic, retain) NSString * imageName;
@property (nonatomic, retain) NSNumber * favourite;
@property (nonatomic, retain) NSNumber * blocked;
@property (nonatomic, retain) NSNumber * distance;
@property (nonatomic, retain) NSSet *conversations;
@end

@interface SPContact (CoreDataGeneratedAccessors)

- (void)addConversationsObject:(SPConversation *)value;
- (void)removeConversationsObject:(SPConversation *)value;
- (void)addConversations:(NSSet *)values;
- (void)removeConversations:(NSSet *)values;

@end
