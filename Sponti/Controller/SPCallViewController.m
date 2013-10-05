//
//  SPCallViewController.m
//  Sponti
//
//  Created by Melad Barjel on 5/10/13.
//  Copyright (c) 2013 Sponti. All rights reserved.
//

#import "SPCallViewController.h"

@interface SPCallViewController ()

@property (nonatomic, strong) UILabel* contactNameLabel;
@property (nonatomic, strong) UILabel* statusLabel;
@property (nonatomic, strong) UIImageView* contactImageView;
@property (nonatomic, strong) UIImageView* endCallImageView;

@end

@implementation SPCallViewController

- (id)initWithContact:(SPContact *)contact {
    self = [super init];
    if (self) {
        self.view.backgroundColor = [UIColor blackColor];
        self.contactNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 34)];
        self.contactNameLabel.backgroundColor = [UIColor clearColor];
        self.contactNameLabel.text = contact.title;
        self.contactNameLabel.textAlignment = NSTextAlignmentCenter;
        self.contactNameLabel.font = [UIFont boldSystemFontOfSize:20.f];
        self.contactNameLabel.textColor = [UIColor whiteColor];
        [self.view addSubview:self.contactNameLabel];
        
        self.statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 34, 320, 30)];
        self.statusLabel.backgroundColor = [UIColor clearColor];
        self.statusLabel.text = @"calling mobile...";
        self.statusLabel.textAlignment = NSTextAlignmentCenter;
        self.statusLabel.font = [UIFont systemFontOfSize:14.f];
        self.statusLabel.textColor = [UIColor whiteColor];
        [self.view addSubview:self.statusLabel];
        
        self.contactImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, 320, 256)];
        [self.contactImageView setImage:[UIImage imageNamed:contact.imageName]];
        [self.view addSubview:self.contactImageView];
        
        self.endCallImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 320, 320, 100)];
        self.endCallImageView.userInteractionEnabled = YES;
        [self.endCallImageView setImage:[UIImage imageNamed:@"endCall.png"]];
        [self.view addSubview:self.endCallImageView];
        
        UITapGestureRecognizer* tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endCall)];
        [self.endCallImageView addGestureRecognizer:tapGestureRecognizer];
    }
    return self;
}

- (void)endCall {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
