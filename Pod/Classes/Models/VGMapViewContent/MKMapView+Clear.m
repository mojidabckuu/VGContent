//
//  MKMapView+Clear.m
//  Pods
//
//  Created by vlad gorbenko on 8/26/15.
//
//

#import "MKMapView+Clear.h"

@implementation MKMapView (Clear)

- (void)clearAllAnnotationsExceptUsers {
    NSMutableArray *annotations = [NSMutableArray array];
    for (id <MKAnnotation> annotation in self.annotations) {
        if (![annotation isKindOfClass:[MKUserLocation class]]) {
            [annotations addObject:annotation];
        }
    }
    [self removeAnnotations:annotations];
}

@end
