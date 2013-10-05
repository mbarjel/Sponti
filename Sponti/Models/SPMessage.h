//
//  SPMessage.h
//  Sponti
//
//  Created by Melad Barjel on 26/09/13.
//  Copyright (c) 2013 Sponti. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SPConversation;

@interface SPMessage : NSManagedObject

@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * contactID;
@property (nonatomic, retain) NSString * uid;
@property (nonatomic, retain) SPConversation *conversation;

@end
