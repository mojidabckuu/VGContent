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

/**
 This property is to bind model.class with corresponding annotationView.class.
 */
@property (nonatomic, strong) NSDictionary *annotationBindings;

@end
