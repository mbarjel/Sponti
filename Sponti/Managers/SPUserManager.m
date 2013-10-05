//
//  SPUserManager.m
//  Sponti
//
//  Created by Melad Barjel on 16/09/13.
//  Copyright (c) 2013 Sponti. All rights reserved.
//

#import "SPUserManager.h"

@implementation SPUserManager

+ (instancetype)sharedManager {
    static id _instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

- (BOOL)userExists {
    BOOL userExists = [[[NSUserDefaults standardUserDefaults] valueForKey:@"userExists"] boolValue];
    return userExists;
}

- (void)saveUser {
    [[NSUserDefaults standardUserDefaults] setValue:@YES forKey:@"userExists"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
