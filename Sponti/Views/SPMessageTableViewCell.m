//
//  SPMessageTableViewCell.m
//  Sponti
//
//  Created by Melad Barjel on 26/09/13.
//  Copyright (c) 2013 Sponti. All rights reserved.
//

#import "SPMessageTableViewCell.h"

@interface SPMessageTableViewCell ()

@property (nonatomic, strong) UIView* bubbleView;
@property (nonatomic, strong) UILabel* messageLabel;

@end

@implementation SPMessageTableViewCell

+ (NSString *)reuseIdentifier {
    return NSStringFromClass([self class]);
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.bubbleView = [[UIView alloc] init];
        self.bubbleView.layer.cornerRadius = 5.f;
        self.bubbleView.backgroundColor = [UIColor blueColor];
        [self.contentView addSubview:self.bubbleView];
        
        self.bubbleView.frame = CGRectMake(5, 2, 200, 100 - 4);
        
        self.messageLabel = [[UILabel alloc] init];
        self.messageLabel.backgroundColor = [UIColor clearColor];
        self.messageLabel.font = [UIFont systemFontOfSize:12.f];
        self.messageLabel.numberOfLines = CGFLOAT_MAX;
        self.messageLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [self.bubbleView addSubview:self.messageLabel];
    }
    return self;
}

- (void)setMessageText:(NSString *)messageText withType:(SPMessageType)type {
    
    CGFloat textSizeWidth;
    CGRect bubbleViewFrame = self.bubbleView.frame;
    
    if (type == SPMessageTypeInvite) {
        textSizeWidth = 310;
        self.messageLabel.frame = CGRectMake(5, 5, 310, 10);
        self.messageLabel.text = messageText;
        self.messageLabel.textAlignment = NSTextAlignmentCenter;
        
        bubbleViewFrame.origin.x = 5;
        bubbleViewFrame.origin.y = 0;
        bubbleViewFrame.size.width = 310;
        bubbleViewFrame.size.height = 17;
        self.bubbleView.backgroundColor = [UIColor colorWithWhite:170.f/255.f alpha:1.f];
        
    } else {
        self.messageLabel.textAlignment = NSTextAlignmentLeft;
        self.bubbleView.frame = CGRectMake(5, 2, 200, 100 - 4);
        
        textSizeWidth = 200;
        CGSize textSize = [messageText sizeWithFont:self.messageLabel.font constrainedToSize:CGSizeMake(textSizeWidth, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
        
        self.messageLabel.frame = CGRectMake(5, 5, textSize.width, textSize.height);
        self.messageLabel.text = messageText;
        
        bubbleViewFrame.size = CGSizeMake(textSize.width + 10, textSize.height + 10);
        
        if (type == SPMessageTypeSent) {
            bubbleViewFrame.origin.x = 320 - bubbleViewFrame.size.width - 4;
            self.bubbleView.backgroundColor = [UIColor colorWithRed:155.f/255.f green:241.f/255.f blue:100.f/255.f alpha:1.f];
        } else if (type == SPMessageTypeReceived) {
            bubbleViewFrame.origin.x = 5;
            self.bubbleView.backgroundColor = [UIColor colorWithWhite:220.f/255.f alpha:1.f];
        }
    }
    self.bubbleView.frame = bubbleViewFrame;
    
    NSLog(@"%@", NSStringFromCGRect(self.bubbleView.frame));
    NSLog(@"%@",NSStringFromCGRect(self.contentView.frame));
    NSLog(@"%@",NSStringFromCGRect(self.messageLabel.frame));
}

@end
