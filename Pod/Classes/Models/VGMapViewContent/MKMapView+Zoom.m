//
//  MKMapView+Zoom.m
//  Pods
//
//  Created by vlad gorbenko on 8/26/15.
//
//

static CGFloat const MKLatitudeEdge = 90;
static CGFloat const MKLongitudeEdge = 180;


#import "MKMapView+Zoom.h"

@implementation MKMapView (Zoom)

- (void)zoomFitRegionWithSpanDelta:(float)delta animated:(BOOL)animated {
    if(![self.annotations count]) {
        return;
    }
    
    CLLocationCoordinate2D topLeftCoord = CLLocationCoordinate2DMake(-MKLatitudeEdge, MKLongitudeEdge);
    CLLocationCoordinate2D bottomRightCoord = CLLocationCoordinate2DMake(MKLatitudeEdge, -MKLongitudeEdge);
    
    for(id<MKAnnotation> annotation in self.annotations) {
        topLeftCoord.longitude = fmin(topLeftCoord.longitude, annotation.coordinate.longitude);
        topLeftCoord.latitude = fmax(topLeftCoord.latitude, annotation.coordinate.latitude);
        
        bottomRightCoord.longitude = fmax(bottomRightCoord.longitude, annotation.coordinate.longitude);
        bottomRightCoord.latitude = fmin(bottomRightCoord.latitude, annotation.coordinate.latitude);
    }
    
    MKCoordinateRegion region;
    region.center.latitude = topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude) * 0.5;
    region.center.longitude = topLeftCoord.longitude + (bottomRightCoord.longitude - topLeftCoord.longitude) * 0.5;
    region.span.latitudeDelta = fabs(topLeftCoord.latitude - bottomRightCoord.latitude) * delta;
    region.span.longitudeDelta = fabs(bottomRightCoord.longitude - topLeftCoord.longitude) * delta;
    if(region.span.latitudeDelta == 0) {
        region.span.latitudeDelta = topLeftCoord.latitude * delta;
    }
    if(region.span.longitudeDelta == 0) {
        region.span.longitudeDelta = topLeftCoord.longitude * delta;
    }
    
    [self setRegion:region animated:animated];
}

@end
