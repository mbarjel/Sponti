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
@property (nonatomic, strong) NSArray* imageViews;

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
        [self.contentView addSubview:self.blockButton];
        
        [self.blockButton makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView.centerY);
            make.left.equalTo(self.contentView.right).with.offset(-80);
            make.height.equalTo(@30);
            make.width.equalTo(@28);
        }];
        
        self.favouriteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.favouriteButton addTarget:self action:@selector(didTapButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.favouriteButton];
        
        [self.favouriteButton makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.centerY);
            make.left.equalTo(self.blockButton.right).with.offset(10);
            make.height.equalTo(@30);
            make.width.equalTo(@28);
        }];
        _imageViews = [NSArray array];
    }
    return self;
}

- (void)setContact:(SPContact *)contact {
    _contact = contact;
    UIImageView* imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:contact.imageName]];
    imageView.frame = CGRectMake(0, 0, 60, 60);
    [self.contentView addSubview:imageView];
    self.nameLabel.text = contact.title;
    _imageViews = @[imageView];
    
    [self updateForBlocked:[contact.blocked boolValue]];
    [self updateForFavourite:[contact.favourite boolValue]];
}

- (void)setConversation:(SPConversation *)conversation {
    _conversation = conversation;
    self.blockButton.hidden = YES;
    self.favouriteButton.hidden = YES;
    
    NSArray* contactsArray = [_conversation.contacts allObjects];
    NSMutableArray* imageViews = [NSMutableArray array];
    for (SPContact* contact in contactsArray) {
        int indexOfContact = [contactsArray indexOfObject:contact];
        UIImageView* imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:contact.imageName]];
        imageView.frame = CGRectMake(indexOfContact * 60, 0, 60, 60);
        [self.contentView addSubview:imageView];
        [imageViews addObject:imageView];
    }
    self.imageViews = [NSArray arrayWithArray:imageViews];
    
    if (_conversation.contacts.count == 1) {
        SPContact* contact = [_conversation.contacts anyObject];
        self.nameLabel.text = contact.title;
    } else {
        self.nameLabel.text = @"";
    }
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

#pragma mark - prepare for reuse

- (void)prepareForReuse {
    for (UIImageView* imageView in self.imageViews) {
        [imageView removeFromSuperview];
    }
}

@end
