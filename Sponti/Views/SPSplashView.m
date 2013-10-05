//
//  SPSplashView.m
//  Sponti
//
//  Created by Melad Barjel on 16/09/13.
//  Copyright (c) 2013 Sponti. All rights reserved.
//

#import "SPSplashView.h"

@implementation SPSplashView

- (id)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        UIActivityIndicatorView* activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [activityIndicatorView startAnimating];
        [self addSubview:activityIndicatorView];
        
        [activityIndicatorView makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.centerX);
            make.centerY.equalTo(self.centerY);
        }];
        
        UILabel* loadingLabel = [[UILabel alloc] init];
        loadingLabel.font = [UIFont systemFontOfSize:16.f];
        loadingLabel.text = @"Loading...";
        [self addSubview:loadingLabel];
        
        [loadingLabel makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.centerX);
            make.top.equalTo(activityIndicatorView.bottom).with.offset(10);
        }];
    }
    return self;
}

@end
