//
//  VGMapViewContent.h
//  Pods
//
//  Created by vlad gorbenko on 8/24/15.
//
//

#import "VGURLContent.h"
#import <VGContent/VGContent.h>
#import <MapKit/MapKit.h>

@protocol VGMapViewContentDelegate <VGContentDelegate>

@optional
- (void)content:(VGContent *)content didDragItem:(id)item;

@end

@interface VGMapViewContent : VGContent <MKMapViewDelegate>

@property (nonatomic, assign) BOOL showUserLocation;
@property (nonatomic, assign) BOOL dropPinAtUpdate;
@property (nonatomic, assign) BOOL allowDragging;
@property (nonatomic, assign) BOOL canShowCallout;

@property (nonatomic, weak) MKMapView *mapView;
@property (nonatomic, assign) id<VGMapViewContentDelegate> delegate;

@property (nonatomic, assign) Class annotationClass;

/**
 This property is to bind model.class with corresponding annotationView.class.
 */
@property (nonatomic, strong) NSDictionary *annotationBindings;

- (void)zoomToFit;

@end
