//
//  SPMessageTableViewCell.m
//  Sponti
//
//  Created by Melad Barjel on 26/09/13.
//  Copyright (c) 2013 Sponti. All rights reserved.
//

#import "SPMessageTableViewCell.h"
#import "SPContact.h"

@interface SPMessageTableViewCell ()

@property (nonatomic, strong) UIView* bubbleView;
@property (nonatomic, strong) UILabel* messageLabel;
@property (nonatomic, strong) UILabel* fromLabel;
@property (nonatomic, strong) UILabel* dateTimeLabel;

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
        
        self.fromLabel = [[UILabel alloc] init];
        self.fromLabel.backgroundColor = [UIColor clearColor];
        self.fromLabel.font = [UIFont boldSystemFontOfSize:10.f];
        self.fromLabel.textColor = [UIColor grayColor];
        [self.bubbleView addSubview:self.fromLabel];
        
        self.dateTimeLabel = [[UILabel alloc] init];
        self.dateTimeLabel.backgroundColor = [UIColor clearColor];
        self.dateTimeLabel.font = [UIFont systemFontOfSize:12.f];
        self.dateTimeLabel.textColor = [UIColor darkGrayColor];
        [self.contentView addSubview:self.dateTimeLabel];
    }
    return self;
}

- (void)setMessage:(SPMessage *)message withType:(SPMessageType)type forGroupChat:(BOOL)groupChat {
    
    CGFloat textSizeWidth;
    CGRect bubbleViewFrame = self.bubbleView.frame;
    
    if (type == SPMessageTypeInvite) {
        textSizeWidth = 310;
        self.messageLabel.frame = CGRectMake(5, 5, 310, 10);
        self.messageLabel.text = message.text;
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
        CGSize textSize = [message.text sizeWithFont:self.messageLabel.font constrainedToSize:CGSizeMake(textSizeWidth, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
        
        self.messageLabel.frame = CGRectMake(5, 5, textSize.width, textSize.height);
        self.messageLabel.text = message.text;
        
        bubbleViewFrame.size = CGSizeMake(textSize.width + 10, textSize.height + ((groupChat && ![message.contactID isEqualToString:@"0"]) ? 24 : 10));
        
        if (type == SPMessageTypeSent) {
            bubbleViewFrame.origin.x = 320 - bubbleViewFrame.size.width - 4;
            self.bubbleView.backgroundColor = [UIColor colorWithRed:155.f/255.f green:241.f/255.f blue:100.f/255.f alpha:1.f];
        } else if (type == SPMessageTypeReceived) {
            bubbleViewFrame.origin.x = 5;
            self.bubbleView.backgroundColor = [UIColor colorWithWhite:220.f/255.f alpha:1.f];
        }
    }
    
    self.bubbleView.frame = bubbleViewFrame;
    
    if (type != SPMessageTypeInvite && groupChat && ![message.contactID isEqualToString:@"0"]) {
        SPContact* contact = [SPContact MR_findFirstByAttribute:@"uid" withValue:message.contactID];
        self.fromLabel.text = [NSString stringWithFormat:@"Message from %@",contact.title];
        
        textSizeWidth = 200;
        CGSize contactNameSize = [self.fromLabel.text sizeWithFont:self.messageLabel.font constrainedToSize:CGSizeMake(textSizeWidth, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
        if (contactNameSize.width > self.messageLabel.frame.size.width) {
            bubbleViewFrame.size = CGSizeMake(contactNameSize.width, contactNameSize.height + 30);
            
            if (type == SPMessageTypeSent) {
                bubbleViewFrame.origin.x = 320 - bubbleViewFrame.size.width - 4;
            }
            self.bubbleView.frame = bubbleViewFrame;
        }
        self.fromLabel.frame = CGRectMake(5, self.bubbleView.frame.size.height - 20, self.bubbleView.frame.size.width, 20);
    }
    
    if (type == SPMessageTypeInvite) {
        self.dateTimeLabel.hidden = YES;
    } else {
        self.dateTimeLabel.hidden = NO;
        
        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
        
        dateFormatter.dateFormat = @"h:mm:ss a MMM dd YYYY";
        self.dateTimeLabel.text = [dateFormatter stringFromDate:message.date];
        
        if (type == SPMessageTypeReceived) {
            self.dateTimeLabel.frame = CGRectMake(8, self.bubbleView.frame.origin.y + self.bubbleView.frame.size.height, 200, 16);
            self.dateTimeLabel.textAlignment = NSTextAlignmentLeft;
        } else {
            self.dateTimeLabel.frame = CGRectMake(120, self.bubbleView.frame.origin.y + self.bubbleView.frame.size.height, 194, 16);
            self.dateTimeLabel.textAlignment = NSTextAlignmentRight;
        }
    }
    
}

- (void)prepareForReuse {
    self.bubbleView.backgroundColor = [UIColor colorWithWhite:170.f/255.f alpha:1.f];
    self.messageLabel.text = @"";
    self.fromLabel.text = @"";
}

@end
