//
//  VGMapViewContent.m
//  Pods
//
//  Created by vlad gorbenko on 8/24/15.
//
//

#import "VGMapViewContent.h"

@implementation VGMapViewContent

#pragma mark - VGMapViewContent lifecycle

- (instancetype)initWithView:(UIView *)view {
    NSAssert([view isKindOfClass:[MKMapView class]], @"You passed not UITableView view");
    MKMapView *mapView = (MKMapView *)mapView;
    self = [super initWithView:mapView];
    if(self) {
        self.mapView = mapView;
        [self setupMapView];
    }
    return self;
}

#pragma mark - Setup

- (void)setupMapView {
    self.mapView.delegate = self;
}

@end
