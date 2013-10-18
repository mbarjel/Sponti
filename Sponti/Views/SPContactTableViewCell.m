//
//  SPContactTableViewCell.m
//  Sponti
//
//  Created by Melad Barjel on 17/09/13.
//  Copyright (c) 2013 Sponti. All rights reserved.
//

#import "SPContactTableViewCell.h"
#import "SPContactsManager.h"

@interface SPContactTableViewCell ()

@property (nonatomic, strong) UILabel* nameLabel;
@property (nonatomic, strong) UIButton* blockButton;
@property (nonatomic, strong) UIButton* favouriteButton;
@property (nonatomic, strong) UIImageView* contactImageView;

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
        [self.contentView addSubview:self.nameLabel];
        
        [self.nameLabel makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView.centerY);
            make.left.equalTo(@70);
            make.right.equalTo(self.contentView.right).with.offset(-10);
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
    }
    return self;
}

- (void)setContact:(SPContact *)contact {
    _contact = contact;
    [self.contactImageView setImage:[UIImage imageNamed:contact.imageName]];
    self.nameLabel.text = contact.title;
    
    [self updateForBlocked:[contact.blocked boolValue]];
    [self updateForFavourite:[contact.favourite boolValue]];
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
