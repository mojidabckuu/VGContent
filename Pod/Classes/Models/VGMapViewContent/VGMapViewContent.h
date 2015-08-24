//
//  VGMapViewContent.h
//  Pods
//
//  Created by vlad gorbenko on 8/24/15.
//
//

#import <VGContent/VGContent.h>

#import <MapKit/MapKit.h>

@interface VGMapViewContent : VGContent <MKMapViewDelegate>

@property (nonatomic, weak) MKMapView *mapView;

@end
