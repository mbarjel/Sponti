//
//  SPMessageTableViewCell.h
//  Sponti
//
//  Created by Melad Barjel on 26/09/13.
//  Copyright (c) 2013 Sponti. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SPMessage.h"

typedef enum {
    SPMessageTypeReceived,
    SPMessageTypeSent,
    SPMessageTypeInvite
} SPMessageType;

@interface SPMessageTableViewCell : UITableViewCell

+ (NSString *)reuseIdentifier;

- (void)setMessage:(SPMessage *)message withType:(SPMessageType)type forGroupChat:(BOOL)groupChat;

@end
