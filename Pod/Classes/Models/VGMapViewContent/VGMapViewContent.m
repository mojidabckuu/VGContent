//
//  VGMapViewContent.m
//  Pods
//
//  Created by vlad gorbenko on 8/24/15.
//
//

#import "VGMapViewContent.h"

@interface VGMapViewContent ()

@property (nonatomic, strong) NSMutableDictionary *annotationViews;

@end

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

#pragma mark - Insert management

- (void)insertItems:(NSArray *)items atIndex:(NSInteger)index animated:(BOOL)animated {
    
}

#pragma mark - Delete management

- (void)deleteItems:(NSArray *)items animated:(BOOL)animated {
    
}

#pragma mark - Select management

- (void)selectItems:(NSArray *)items animated:(BOOL)animated {
    
}

- (void)deselectItem:(id)item animated:(BOOL)animated {
    
}

#pragma mark - Reload management

- (void)reloadItems:(NSArray *)items animated:(BOOL)animated {
    
}

#pragma mark - MKMapView delegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    } else {
        if(!self.annotationViews.count) {
            return nil;
        }
        MKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:self.cellIdentifier];
        if(!annotationView) {
            NSString *annotationClassString = NSStringFromClass(annotation.class);
            NSString *annotationViewClassString = self.annotationBindings[annotationClassString];
            Class annotationViewClass = NSClassFromString(annotationViewClassString);
            annotationView = [[annotationViewClass alloc] initWithAnnotation:annotation reuseIdentifier:self.cellIdentifier];
        } else {
            annotationView.annotation = annotation;
        }
        return annotationView;
    }
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    if([self.delegate respondsToSelector:@selector(content:didSelectItem:)]) {
        [self.delegate content:self didSelectItem:self.annotationViews[view]];
    }
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
    if([self.delegate respondsToSelector:@selector(content:didDeselectItem:)]) {
        [self.delegate content:self didDeselectItem:self.annotationViews[view]];
    }
}

@end
