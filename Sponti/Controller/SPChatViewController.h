//
//  SPChatViewController.h
//  Sponti
//
//  Created by Melad Barjel on 18/09/13.
//  Copyright (c) 2013 Sponti. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SPContact.h"
#import "SPConversation.h"

@interface SPChatViewController : UIViewController

- (id)initWithConversation:(SPConversation *)conversation;

@end
