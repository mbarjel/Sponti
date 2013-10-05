//
//  SPUserManager.h
//  Sponti
//
//  Created by Melad Barjel on 16/09/13.
//  Copyright (c) 2013 Sponti. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SPUserManager : NSObject

+ (instancetype)sharedManager;

- (BOOL)userExists;
- (void)saveUser;

@end
