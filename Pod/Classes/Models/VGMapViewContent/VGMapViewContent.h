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

@property (nonatomic, assign) BOOL showUserLocation;
@property (nonatomic, assign) BOOL dropPinAtUpdate;
@property (nonatomic, assign) BOOL allowDragging;

@property (nonatomic, weak) MKMapView *mapView;

@property (nonatomic, assign) Class annotationClass;

/**
 This property is to bind model.class with corresponding annotationView.class.
 */
@property (nonatomic, strong) NSDictionary *annotationBindings;

- (void)zoomToFit;

@end
