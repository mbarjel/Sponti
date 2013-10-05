//
//  SPLoginView.m
//  Sponti
//
//  Created by Melad Barjel on 16/09/13.
//  Copyright (c) 2013 Sponti. All rights reserved.
//

#import "SPLoginView.h"

@interface SPLoginView ()

@property (nonatomic, strong) UIButton* loginButton;

@end

@implementation SPLoginView

- (id)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        self.loginButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [self.loginButton setTitle:@"Login with Facebook" forState:UIControlStateNormal];
        [self.loginButton addTarget:self action:@selector(loginButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.loginButton];
        
        [self.loginButton makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@150);
            make.centerX.equalTo(self.centerX);
            make.centerY.equalTo(self.centerY);
        }];
    }
    return self;
}

- (void)loginButtonPressed {
    [self.delegate didPressLoginWithloginView:self];
}

@end
