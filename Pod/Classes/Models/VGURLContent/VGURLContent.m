//
//  VGURLContent.m
//  VGContent
//
//  Created by Vlad Gorbenko on 05.07.15.
//  Copyright (c) 2015 Vlad Gorbenko. All rights reserved.
//

#import "VGURLContent.h"

#import "VGControls.h"

#import "UIView+Subviews.h"
#import "UIView+Identifier.h"

#import "VGContentConfiguration.h"

#import <objc/runtime.h>

NSString *const VGAnimatedRefresh = @"VGAnimatedRefresh";
NSString *const VGReloadOnRefresh = @"VGReloadOnRefresh";

NSString *const VGPullToRefreshControlClass = @"VGPullToRefreshControlClass";
NSString *const VGInfiniteControlClass = @"VGInfiniteControlClass";

Class NSClassFromAnyObject(id anyObject) {
    if(class_isMetaClass(object_getClass(anyObject))) {
        return anyObject;
    }
    if([anyObject isKindOfClass:[NSString class]]) {
        return ClassFromString(anyObject);
    }
    return nil;
}

@interface VGURLContent ()

@property (nonatomic, readonly, assign) UIScrollView *scrollView;

@end

@implementation VGURLContent

@synthesize isRefreshing = _isRefreshing;
@synthesize isAllLoaded = _isAllLoaded;
@synthesize isLoading = _isLoading;

@synthesize offset = _offset;

#pragma mark - Setup methods

- (void)setup {
    self.isAllLoaded = NO;
    _offset = @0;
    [super setup];
    [self setupControls];
}

- (void)setupControls {
    if(self.configuration[VGPullToRefreshControlClass]) {
        id UIRefreshControlClass = self.configuration[VGPullToRefreshControlClass];
        Class realClass = NSClassFromAnyObject(UIRefreshControlClass);
        NSAssert(realClass, @"Pull to refresh class doesn't exist");
        if(![self.scrollView containsViewWithClass:realClass] && !(realClass == NSClassFromString(@"UIRefreshControl") && ![self.view isKindOfClass:[UITableView class]])) {
            UIControl<VGAnimableControl> *pullToRefreshControl = [[realClass alloc] init];
            NSAssert([pullToRefreshControl conformsToProtocol:@protocol(VGAnimableControl)], @"Control should respond to VGAnimable protocol");
            pullToRefreshControl.tintColor = self.configuration[VGRefreshControlTintColor];
            [self.scrollView addSubview:pullToRefreshControl];
            [pullToRefreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
        }
    }
    if(self.configuration[VGInfiniteControlClass]) {
        id UIInfiniteControl = self.configuration[VGInfiniteControlClass];
        Class realClass = NSClassFromAnyObject(UIInfiniteControl);
        NSAssert(realClass, @"Infinte control class doesn't exist");
        if(![self.scrollView containsViewWithClass:realClass]) {
            UIControl *infiniteControl = [[realClass alloc] init];
            NSAssert([infiniteControl conformsToProtocol:@protocol(VGAnimableControl)], @"Control should respond to VGAnimable protocol");
            infiniteControl.tintColor = self.configuration[VGInfiniteControlTintColor];
            [self.scrollView addSubview:infiniteControl];
            [infiniteControl addTarget:self action:@selector(loadMoreItems) forControlEvents:UIControlEventValueChanged];
        }
    }
}

#pragma mark - Accessors

- (id)offset {
    if(!_offset) {
        id item = [_items lastObject];
        NSNumber *offset = nil;
        if([item respondsToSelector:@selector(identifier)]) {
            offset = [item valueForKeyPath:@"identifier"];
        }
        return _isRefreshing ? nil : offset;
    }
    return _offset;
}

- (NSNumber *)length {
    return @20;
}

- (NSArray *)criterias {
    return _criterias ?: @[];
}

- (BOOL)isRefreshing {
    return _isRefreshing;
}

- (UIScrollView *)scrollView {
    return (UIScrollView *)self.view;
}

- (id <VGAnimableControl>)refreshControl {
    if(self.configuration[VGPullToRefreshControlClass]) {
        return (id <VGAnimableControl>)[self.scrollView subviewWithClass:NSClassFromAnyObject(self.configuration[VGPullToRefreshControlClass])];
    }
    return nil;
}

- (id <VGAnimableControl>)infiniteControl {
    if(self.configuration[VGInfiniteControlClass]) {
        return (id <VGAnimableControl>)[self.scrollView subviewWithClass:NSClassFromAnyObject(self.configuration[VGInfiniteControlClass])];
    }
    return nil;
}

#pragma mark - Modifiers

- (void)setIsAllLoaded:(BOOL)isAllLoaded {
    _isAllLoaded = isAllLoaded;
    // TODO: think about this
    // iCarousel is not UIScrollView child;
    [[self infiniteControl] setEnabled:!isAllLoaded];
}

- (void)setOffset:(id)offset {
    _offset = offset;
}

#pragma mark - VGURLContent management

- (void)loadItems {
}

- (void)refresh {
    if (_isRefreshing) {
        return;
    }
    _canceled = NO;
    _isRefreshing = YES;
    if(!self.items.count) {
        [[self infiniteControl] startAnimating];
    }
    [self notifyWillLoad];
    [self loadItems];
}

- (void)loadMoreItems {
    if(_isLoading) {
        return;
    }
    _canceled = NO;
    _isLoading = YES;
    [self notifyWillLoad];
    [self loadItems];
}

- (void)cancel {
    [[self infiniteControl] stopAnimating];
    [[self refreshControl] stopAnimating];
    _canceled = YES;
}

#pragma mark - URL fetching management

- (void)fetchLoadedItems:(NSArray *)items error:(NSError *)error {
    if(error) {
        [self notifyDidFailWithError:error];
        [[self refreshControl] stopAnimating];
        [[self infiniteControl] stopAnimating];
        self.isAllLoaded = true;
        self.isAllLoaded = false;
        _isRefreshing = NO;
        _isLoading = NO;
        return;
    }
    if (_isRefreshing && !_canceled) { // TODO: handle situations when can infinite scroll with search string.
        [[self infiniteControl] stopAnimating];
        if([self.configuration[VGAnimatedRefresh] boolValue]) {
            if(!_canceled) {
                _offset = nil;
                [self deleteItems:_items animated:YES];
                [self insertItems:items atIndex:_items.count animated:YES];
            }
        } else {
            if(!_canceled) {
                [_items removeAllObjects];
                _offset = nil;
                if([self.configuration[VGReloadOnRefresh] boolValue]) {
                    [_items addObjectsFromArray:items];
                    [self reload];
                } else {
                    [self reload];
                    [self insertItems:items atIndex:_items.count animated:NO];
                }
            }
        }
        [[self refreshControl] stopAnimating];
    } else {
        [[self infiniteControl] stopAnimating];
        if(!_canceled) {
            [self insertItems:items atIndex:_items.count animated:YES];
        }
    }
    if(!_canceled) {
        [self notifyDidLoadWithItems:items];
    }
    _isRefreshing = NO;
    _isLoading = NO;
}

- (void)fetchLoadedItems:(NSArray *)items pageSize:(NSInteger)pageSize error:(NSError *)error {
    self.filteredItems = nil;
    [self fetchLoadedItems:items error:error];
    self.isAllLoaded = _canceled ? self.isAllLoaded : items.count < pageSize;
}

#pragma mark - Notifiers

- (void)notifyDidFailWithError:(NSError *)error {
    if ([self.dataDelegate respondsToSelector:@selector (content:didFailLoadingWithError:)]) {
        [self.dataDelegate content:self didFailLoadingWithError:error];
    }
}

- (void)notifyDidLoadWithItems:(NSArray *)items {
    if ([self.dataDelegate respondsToSelector:@selector (content:didFinishLoadingWithItems:)]) {
        [self.dataDelegate content:self didFinishLoadingWithItems:items];
    }
}

- (void)notifyWillLoad {
    if ([self.dataDelegate respondsToSelector:@selector (contentWillLoadItems:)]) {
        [self.dataDelegate contentWillLoadItems:self];
    }
}

@end
