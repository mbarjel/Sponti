//
//  SPContactTableViewCell.m
//  Sponti
//
//  Created by Melad Barjel on 17/09/13.
//  Copyright (c) 2013 Sponti. All rights reserved.
//

#import "SPContactTableViewCell.h"
#import "SPContactsManager.h"
#import "SPMessage.h"

@interface SPContactTableViewCell ()

@property (nonatomic, strong) UILabel* nameLabel;
@property (nonatomic, strong) UIButton* blockButton;
@property (nonatomic, strong) UIButton* favouriteButton;
@property (nonatomic, strong) UIImageView* contactImageView;

@property (nonatomic, strong) UILabel* lastMessageLabel;
@property (nonatomic, strong) UILabel* lastMessageDateLabel;

@property (nonatomic, strong) id<MASConstraint> nameLabelConstraint;

@end

@implementation SPContactTableViewCell

+ (NSString *)reuseIdentifier {
    return NSStringFromClass([self class]);
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.nameLabel = [[UILabel alloc] init];
        self.nameLabel.backgroundColor = [UIColor clearColor];
        self.nameLabel.font = [UIFont systemFontOfSize:14.f];
        self.nameLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
        [self.contentView addSubview:self.nameLabel];
        
        [self.nameLabel makeConstraints:^(MASConstraintMaker *make) {
            _nameLabelConstraint = make.top.equalTo(@20);
            make.height.equalTo(@20);
            make.left.equalTo(@64);
            make.right.equalTo(self.contentView.right).with.offset(-68);
        }];
        
        self.blockButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.blockButton addTarget:self action:@selector(didTapButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.blockButton setImageEdgeInsets:UIEdgeInsetsMake(15, 5, 15, 5)];
        [self.contentView addSubview:self.blockButton];
        
        [self.blockButton makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView.centerY);
            make.left.equalTo(self.contentView.right).with.offset(-80);
            make.height.equalTo(self.contentView.height);
            make.width.equalTo(@40);
        }];
        
        self.favouriteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.favouriteButton addTarget:self action:@selector(didTapButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.favouriteButton setImageEdgeInsets:UIEdgeInsetsMake(15, 5, 15, 5)];
        [self.contentView addSubview:self.favouriteButton];
        
        [self.favouriteButton makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.centerY);
            make.left.equalTo(self.blockButton.right);
            make.height.equalTo(self.contentView.height);
            make.width.equalTo(@40);
        }];
        
        self.contactImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:self.contactImageView];
        [self.contactImageView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.left);
            make.top.equalTo(self.contentView.top);
            make.bottom.equalTo(self.contentView.bottom);
            make.width.equalTo(self.contentView.height);
        }];
        
        _lastMessageDateLabel = [[UILabel alloc] init];
        _lastMessageDateLabel.backgroundColor = [UIColor clearColor];
        _lastMessageDateLabel.textAlignment = NSTextAlignmentRight;
        _lastMessageDateLabel.textColor = [UIColor darkGrayColor];
        _lastMessageDateLabel.font = [UIFont systemFontOfSize:12.f];
        _lastMessageDateLabel.numberOfLines = 2;
        _lastMessageDateLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [self.contentView addSubview:_lastMessageDateLabel];
        
        [_lastMessageDateLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.right).with.offset(-80);
            make.top.equalTo(self.contentView.top);
            make.bottom.equalTo(self.contentView.bottom);
            make.right.equalTo(self.contentView.right).with.offset(-2);
        }];
        
        _lastMessageLabel = [[UILabel alloc] init];
        _lastMessageLabel.backgroundColor = [UIColor clearColor];
        _lastMessageLabel.textColor = [UIColor lightGrayColor];
        _lastMessageLabel.font = [UIFont systemFontOfSize:12.f];
        _lastMessageLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [self.contentView addSubview:_lastMessageLabel];
        
        [_lastMessageLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.top).with.offset(20);
            make.left.equalTo(self.contentView.left).with.offset(64);
            make.right.equalTo(self.contentView.right).with.offset(-60);
            make.bottom.equalTo(self.contentView.bottom);
        }];
        
    }
    return self;
}

- (void)setContact:(SPContact *)contact {
    _contact = contact;
    [self.contactImageView setImage:[UIImage imageNamed:contact.imageName]];
    self.nameLabel.text = contact.title;
    
    [self updateForBlocked:[contact.blocked boolValue]];
    [self updateForFavourite:[contact.favourite boolValue]];
    
    _lastMessageDateLabel.hidden = YES;
    _lastMessageLabel.hidden = YES;
    
    [_nameLabelConstraint uninstall];
    [_nameLabel makeConstraints:^(MASConstraintMaker *make) {
        _nameLabelConstraint = make.top.equalTo(self.contentView.top).with.offset(20);
    }];
}

- (void)setConversation:(SPConversation *)conversation {
    _conversation = conversation;
    self.blockButton.hidden = YES;
    self.favouriteButton.hidden = YES;
    
    SPContact* contact = [_conversation.contacts anyObject];
    
    [self.contactImageView setImage:[UIImage imageNamed:contact.imageName]];
    
    
    if (_conversation.contacts.count == 1) {
        self.nameLabel.text = contact.title;
    } else {
        self.nameLabel.text = [NSString stringWithFormat:@"%@ + %d other%@",contact.title,_conversation.contacts.count - 1,(_conversation.contacts.count == 2) ? @"" : @"s"];
    }
    
    SPMessage* latestMessage;
    NSDate* currentLatestDate;
    
    for (SPMessage* message in [_conversation.messages allObjects]) {
        if (!latestMessage && ![message.contactID isEqualToString:@"invite"]) {
            latestMessage = message;
            currentLatestDate = message.date;
        } else {
            if (![message.contactID isEqualToString:@"invite"]) {
                NSComparisonResult result = [currentLatestDate compare:message.date];
                if (result == NSOrderedAscending) {
                    currentLatestDate = message.date;
                    latestMessage = message;
                }
            }
        }
    }
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"h:mm:ss a MMM dd YYYY";
    
    _lastMessageDateLabel.text = [dateFormatter stringFromDate:latestMessage.date];
    _lastMessageLabel.text = latestMessage.text;
    
    [_nameLabelConstraint uninstall];
    [_nameLabel makeConstraints:^(MASConstraintMaker *make) {
        _nameLabelConstraint = make.top.equalTo(self.contentView.top).with.offset(10);
    }];
}

- (void)setHideButtons:(BOOL)hideButtons {
    _hideButtons = hideButtons;
    self.favouriteButton.hidden = _hideButtons;
    self.blockButton.hidden = _hideButtons;
}

- (void)updateForBlocked:(BOOL)blocked {
    if (blocked) {
        self.contentView.alpha = 0.5;
        [self.blockButton setImage:[UIImage imageNamed:@"blocked"] forState:UIControlStateNormal];
    } else {
        self.contentView.alpha = 1;
        [self.blockButton setImage:[UIImage imageNamed:@"unblocked"] forState:UIControlStateNormal];
    }
}

- (void)updateForFavourite:(BOOL)favourite {
    if (favourite) {
        [self.favouriteButton setImage:[UIImage imageNamed:@"star_on"] forState:UIControlStateNormal];
    } else {
        [self.favouriteButton setImage:[UIImage imageNamed:@"star_off"] forState:UIControlStateNormal];
    }
}

#pragma mark - UIButton

- (void)didTapButton:(UIButton *)sender {
    if (sender == self.blockButton) {
        [self updateForBlocked:![_contact.blocked boolValue]];
        [[SPContactsManager sharedManager] updateContact:_contact asBlocked:![_contact.blocked boolValue]];
    } else {
        [self updateForFavourite:![_contact.favourite boolValue]];
        [[SPContactsManager sharedManager] updateContact:_contact asFavourite:![_contact.favourite boolValue]];
    }
}

@end
