//
//  SPPopulateCoreData.h
//  Sponti
//
//  Created by Melad Barjel on 25/09/13.
//  Copyright (c) 2013 Sponti. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SPPopulateCoreData : NSObject

+ (instancetype)sharedManager;
- (void)populateWithDummyData;

@end
