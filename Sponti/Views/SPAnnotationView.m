//
//  SPAnnotationView.m
//  Sponti
//
//  Created by Melad Barjel on 1/10/13.
//  Copyright (c) 2013 Sponti. All rights reserved.
//

#import "SPAnnotationView.h"

@interface SPAnnotationView ()

@property (nonatomic, strong) UIImageView* pinImageView;
@property (nonatomic, strong) UIImageView* contactImageView;

@end

@implementation SPAnnotationView

- (id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier imageName:(NSString *)imageName {
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        self.pinImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pin"]];
        [self addSubview:self.pinImageView];
        
        self.contactImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
        [self.pinImageView addSubview:self.contactImageView];
        
    }
    return self;
}

- (void)layoutSubviews {
    self.pinImageView.frame = self.bounds;
    self.contactImageView.frame = CGRectMake(5, 5, 40, 36);
}

- (void)setAnnotation:(id<MKAnnotation>)annotation {
    [super setAnnotation:annotation];
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, 50, 63);
	[self setNeedsDisplay];
}

@end
