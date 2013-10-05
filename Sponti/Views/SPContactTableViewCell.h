//
//  SPContactTableViewCell.h
//  Sponti
//
//  Created by Melad Barjel on 17/09/13.
//  Copyright (c) 2013 Sponti. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SPContact.h"
#import "SPConversation.h"

@interface SPContactTableViewCell : UITableViewCell

@property (nonatomic, strong) SPContact* contact;
@property (nonatomic, strong) SPConversation* conversation;

+ (NSString *)reuseIdentifier;

@end
