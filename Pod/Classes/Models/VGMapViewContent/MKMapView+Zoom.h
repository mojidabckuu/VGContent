//
//  MKMapView+Zoom.h
//  Pods
//
//  Created by vlad gorbenko on 8/26/15.
//
//

#import <MapKit/MapKit.h>

@interface MKMapView (Zoom)

- (void)zoomFitRegionWithSpanDelta:(float)delta animated:(BOOL)animated;

@end
