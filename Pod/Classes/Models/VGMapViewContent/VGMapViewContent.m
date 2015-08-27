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
    MKMapView *mapView = (MKMapView *)view;
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

- (void)setItems:(NSArray *)items {
    [_items removeAllObjects];
    [self insertItems:items atIndex:0 animated:YES];
    [self reload];
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
    NSArray *deleteAnnotations = [self annotationsForItems:items];
    [self.annotationsBindings removeObjectsForKeys:[items valueForKeyPath:@"hash"]];
    [self.mapView removeAnnotations:deleteAnnotations];
}

#pragma mark - Select management

- (void)selectItems:(NSArray *)items animated:(BOOL)animated {
    NSLog(@"WARNING: MKMapView knows how to select only latest annotation in default behaviour. But select will be called on each");
    
    NSArray *annotations = [self annotationsForItems:items];
    for(id<MKAnnotation> annotation in annotations) {
        [self.mapView selectAnnotation:annotation animated:animated];
    }
}

- (void)deselectItem:(id)item animated:(BOOL)animated {
    NSLog(@"WARNING: MKMapView knows how to deselect only latest annotation in default behaviour. But select will be called on each");
    
    NSArray *annotations = [self annotationsForItems:@[item]];
    for(id<MKAnnotation> annotation in annotations) {
        [self.mapView deselectAnnotation:annotation animated:animated];
    }
}

#pragma mark - Reload management

- (void)reloadItems:(NSArray *)items animated:(BOOL)animated {
    NSArray *annotations = [self annotationsForItems:items];
    [self.mapView removeAnnotations:annotations];
    [self.mapView addAnnotations:annotations];
}

- (void)reload {
    [self.mapView clearAllAnnotationsExceptUsers];
    NSArray *annotations = [self annotationsForItems:_items];
    if(annotations.count) {
        [self.mapView addAnnotations:annotations];
    }
}

#pragma mark - MKMapView delegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    } else {
        if(!self.annotationBindings.count) {
            return nil;
        }
        MKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:self.cellIdentifier];
        if(!annotationView) {
            NSString *annotationClassString = NSStringFromClass(annotation.class);
            NSAssert(self.annotationBindings[annotationClassString] != nil, @"You haven't corresponding annotation view class from this annotation.");
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
        id<MKAnnotation> annotation = view.annotation;
        id item = [[self.annotationsBindings allKeysForObject:annotation] firstObject];
        [self.delegate content:self didSelectItem:item];
    }
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
    if([self.delegate respondsToSelector:@selector(content:didDeselectItem:)]) {
        id<MKAnnotation> annotation = view.annotation;
        id item = [[self.annotationsBindings allKeysForObject:annotation] firstObject];
        [self.delegate content:self didDeselectItem:item];
    }
}

#pragma mark - Utils

- (NSMutableArray *)convertModelsToAnnotations:(NSArray *)models {
    NSAssert(self.annotationClass != nil, @"Annotation class can't be nil value");
    NSMutableArray *annotations = [NSMutableArray array];
    for(id model in models) {
        id annotation = [[self.annotationClass alloc] init];
        SEL selector = NSSelectorFromString(@"setupWithItem:");
        if([annotation respondsToSelector:selector]) {
            [annotation performSelector:selector withObject:model];
        }
        [annotations addObject:annotation];
        [self.annotationsBindings setObject:annotation forKey:[model valueForKey:@"hash"]];
    }
    return annotations;
}

- (NSArray *)keysForItems:(NSArray *)items {
    NSArray *keys = [items valueForKey:@"hash"];
    return keys;
}

- (NSArray *)annotationsForItems:(NSArray *)items {
    NSMutableArray *annotations = [NSMutableArray array];
    NSArray *keys = [self keysForItems:items];
    for(id key in keys) {
        id annotation = self.annotationsBindings[key];
        if(annotation) {
            [annotations addObject:annotation];
        }
    }
    return annotations;
}

- (void)zoomToFit {
    [self.mapView showAnnotations:self.mapView.annotations animated:YES];
}

@end
