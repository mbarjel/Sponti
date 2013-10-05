//
//  SPAnnotationView.h
//  Sponti
//
//  Created by Melad Barjel on 1/10/13.
//  Copyright (c) 2013 Sponti. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface SPAnnotationView : MKAnnotationView

- (id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier imageName:(NSString *)imageName;

@end
