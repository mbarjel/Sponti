//
//  SPMapViewController.m
//  Sponti
//
//  Created by Melad Barjel on 1/10/13.
//  Copyright (c) 2013 Sponti. All rights reserved.
//

#import "SPMapViewController.h"
#import <MapKit/MapKit.h>
#import "SPAnnotationView.h"

#define METERS_PER_MILE 1609.344

@interface SPMapViewController () <MKMapViewDelegate>

@property (nonatomic, strong) MKMapView* mapView;
@property (nonatomic, strong) SPContact* contact;
@property (nonatomic, strong) UIButton* pinButton;
@property (nonatomic, strong) UIButton* eyeButton;

@property (nonatomic, assign) BOOL visible;

@property (nonatomic, strong) UIImageView* mapOverlayImageView;

@end

@implementation SPMapViewController

- (id)initWithContact:(SPContact *)contact {
    self = [super init];
    if (self) {
        
        self.visible = NO;
        self.contact = contact;
        
        self.title = @"Map";
        self.mapView = [[MKMapView alloc] init];
        self.mapView.delegate = self;
        [self.view addSubview:self.mapView];
        
        [self.mapView makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        
        self.pinButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.pinButton.frame = CGRectMake(10, 370, 48, 40);
        [self.pinButton setImage:[UIImage imageNamed:@"pin_icon.jpg"] forState:UIControlStateNormal];
        [self.pinButton addTarget:self action:@selector(didTapButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.pinButton];
        
        self.eyeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.eyeButton.frame = CGRectMake(68, 370, 40, 40);
        [self.eyeButton setImage:[UIImage imageNamed:@"eye_icon.jpg"] forState:UIControlStateNormal];
        [self.eyeButton addTarget:self action:@selector(didTapButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.eyeButton];
        
        [self displayOverlay];
    }
    return self;
}

- (void)didTapButton:(UIButton *)button {
    if (button == self.pinButton) {
        CLLocationCoordinate2D zoomLocation;
        zoomLocation.latitude = -33.8254667;
        zoomLocation.longitude= 151.1881845;
        MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
        [annotation setTitle:@"restuarant.jpg"];
        [annotation setCoordinate:zoomLocation];
        [self.mapView addAnnotation:annotation];
    } else {
        if (self.visible) {
            [[[UIAlertView alloc] initWithTitle:@"Hidden" message:@"You are now hidden on the map" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        } else {
            [[[UIAlertView alloc] initWithTitle:@"Visible" message:@"You are now visible on the map" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }
        self.visible = !self.visible;
        
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = -33.8204667;
    zoomLocation.longitude= 151.1861845;
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 1*METERS_PER_MILE, 1*METERS_PER_MILE);
    [self.mapView setRegion:viewRegion animated:NO];
    
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    [annotation setTitle:@"maleicon.jpg"];
    [annotation setCoordinate:zoomLocation];
    [self.mapView addAnnotation:annotation];
    
    [self performSelector:@selector(addNewAnnotation) withObject:nil afterDelay:4];
}

- (void)addNewAnnotation {
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    [annotation setTitle:self.contact.imageName];
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = -33.81891327051621;
    zoomLocation.longitude = 151.18341386318207;
    
    [annotation setCoordinate:zoomLocation];
    [self.mapView addAnnotation:annotation];
}

- (void)displayOverlay {
    if(![[NSUserDefaults standardUserDefaults] valueForKey:@"mapOverlay"]) {
        _mapOverlayImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mapOverlay.jpg"]];
        _mapOverlayImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer* tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeOverlay)];
        [_mapOverlayImageView addGestureRecognizer:tapGestureRecognizer];
        _mapOverlayImageView.alpha = 0.75;
        _mapOverlayImageView.frame = CGRectMake(0, 0, 320, 416);
        [self.view addSubview:_mapOverlayImageView];
    }
}

- (void)removeOverlay {
    [[NSUserDefaults standardUserDefaults] setValue:@YES forKey:@"mapOverlay"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [UIView animateWithDuration:0.25 animations:^{
        _mapOverlayImageView.alpha = 0.f;
    } completion:^(BOOL finished) {
        [_mapOverlayImageView removeFromSuperview];
        _mapOverlayImageView = nil;
    }];
}

#pragma mark - MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    NSString* imageName = [(MKPointAnnotation *)annotation title];
    SPAnnotationView* annotationView = [[SPAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"anotationView" imageName:imageName];
    return annotationView;
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id<MKOverlay>)overlay {
    MKOverlayView* overlayView = [[MKOverlayView alloc] initWithOverlay:overlay];
    return overlayView;
}

@end
