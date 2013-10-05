//
//  SPLoginView.h
//  Sponti
//
//  Created by Melad Barjel on 16/09/13.
//  Copyright (c) 2013 Sponti. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SPLoginView;

@protocol SPLoginViewDelegate <NSObject>

- (void)didPressLoginWithloginView:(SPLoginView *)loginView;

@end

@interface SPLoginView : UIView

@property (nonatomic, weak) id<SPLoginViewDelegate> delegate;

@end
