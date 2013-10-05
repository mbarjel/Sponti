//
//  SPMessageTableViewCell.h
//  Sponti
//
//  Created by Melad Barjel on 26/09/13.
//  Copyright (c) 2013 Sponti. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    SPMessageTypeReceived,
    SPMessageTypeSent,
} SPMessageType;

@interface SPMessageTableViewCell : UITableViewCell

+ (NSString *)reuseIdentifier;

- (void)setMessageText:(NSString *)messageText withType:(SPMessageType)type;

@end
