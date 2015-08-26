//
//  VGMapViewContent.m
//  Pods
//
//  Created by vlad gorbenko on 8/24/15.
//
//

#import "VGMapViewContent.h"

#import "MKMapView+Clear.h"
#import "MKMapView+Zoom.h"

@interface VGMapViewContent ()

@property (nonatomic, strong) NSMutableDictionary *annotationsBindings;

@end

@implementation VGMapViewContent

#pragma mark - VGMapViewContent lifecycle

- (instancetype)initWithView:(UIView *)view {
    NSAssert([view isKindOfClass:[MKMapView class]], @"You passed not MKMapView view");
    MKMapView *mapView = (MKMapView *)mapView;
    self = [super initWithView:mapView];
    if(self) {
        self.mapView = mapView;
        [self setupMapView];
    }
    return self;
}

- (void)dealloc {
    [self.annotationsBindings removeAllObjects];
}

#pragma mark - Setup

- (void)setupMapView {
    self.mapView.delegate = self;
}

- (void)setup {
    [super setup];
    self.annotationsBindings  = [NSMutableDictionary dictionary];
}

#pragma mark - Modifiers

- (void)setShowUserLocation:(BOOL)showUserLocation {
    _showUserLocation = showUserLocation;
    self.mapView.showsUserLocation = showUserLocation;
}

#pragma mark - Insert management

- (void)insertItems:(NSArray *)items atIndex:(NSInteger)index animated:(BOOL)animated {
    [_items addObjectsFromArray:items];
    NSArray *insertAnnotations = [self convertModelsToAnnotations:items];
    [self.mapView addAnnotations:insertAnnotations];
}

#pragma mark - Delete manag ement

- (void)deleteItems:(NSArray *)items animated:(BOOL)animated {
    [_items removeObjectsInArray:items];
    [self.annotationsBindings removeObjectsForKeys:items];
    NSArray *deleteAnnotations = [self convertModelsToAnnotations:items];
    [self.mapView removeAnnotations:deleteAnnotations];
}

#pragma mark - Select management

- (void)selectItems:(NSArray *)items animated:(BOOL)animated {
    NSLog(@"WARNING: MKMapView knows how to select only latest annotation in default behaviour. But select will be called on each");

    NSArray *annotations = [self.annotationsBindings objectsForKeys:items notFoundMarker:nil];
    for(id<MKAnnotation> annotation in annotations) {
        [self.mapView selectAnnotation:annotation animated:animated];
    }
}

- (void)deselectItem:(id)item animated:(BOOL)animated {
    NSLog(@"WARNING: MKMapView knows how to deselect only latest annotation in default behaviour. But select will be called on each");
    
    NSArray *annotations = [self.annotationsBindings objectsForKeys:items notFoundMarker:nil];
    for(id<MKAnnotation> annotation in annotations) {
        [self.mapView deselectAnnotation:annotation animated:animated];
    }
}

#pragma mark - Reload management

- (void)reloadItems:(NSArray *)items animated:(BOOL)animated {
    NSArray *annotations = [self.annotationsBindings objectsForKeys:items notFoundMarker:nil];
    [self.mapView removeAnnotations:annotations];
    [self.mapView addAnnotations:[self convertModelsToAnnotations:items]];
}

- (void)reload {
    [self.mapView clearAllAnnotationsExceptUsers];
    [self.mapView addAnnotations:[self convertModelsToAnnotations:self.items]];
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
            NSAssert(self.annotationBindings[annotationClassString] = nil, @"You haven't corresponding annotation view class from this annotation.");
            NSString *annotationViewClassString = self.annotationBindings[annotationClassString];
            Class annotationViewClass = NSClassFromString(annotationViewClassString);
            annotationView = [[annotationViewClass alloc] initWithAnnotation:annotation reuseIdentifier:self.cellIdentifier];
        } else {
            annotationView.annotation = annotation;
        }
        [self.annotationViews setObject:annotation forKey:annotationView];
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

#pragma mark - Utils

- (NSMutableArray *)convertModelsToAnnotations:(NSArray *)models {
    NSAssert(self.annotationClass = nil, @"Annotation class can't be nil value");
    NSMutableArray *annotations = [NSMutableArray array];
    for(id model in models) {
        id annotation = [[self.annotationClass alloc] init];
        SEL selector = NSSelectorFromString(@"setupWithItem:");
        if([annotation respondsToSelector:selector]) {
            [annotation performSelector:selector withObject:model];
        }
        [annotations addObject:annotation];
        [self.annotationsBindings setObject:annotation forKey:model];
    }
    return annotations;
}

- (void)zoomToFit {
    [self.mapView showAnnotations:self.mapView.annotations animated:YES];
}

@end
