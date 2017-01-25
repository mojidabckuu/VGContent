//
//  VGURLContent.m
//  VGContent
//
//  Created by Vlad Gorbenko on 05.07.15.
//  Copyright (c) 2015 Vlad Gorbenko. All rights reserved.
//

#import "VGURLContent.h"

#import <UIScrollView_InfiniteScroll/UIScrollView+InfiniteScroll.h>

NSString *const VGAnimatedRefresh = @"VGAnimatedRefresh";
NSString *const VGReloadOnRefresh = @"VGReloadOnRefresh";

@interface VGURLContent ()

@property (nonatomic, readonly, assign) UIScrollView *scrollView;

@end

@implementation VGURLContent

@synthesize isRefreshing = _isRefreshing;
@synthesize isAllLoaded = _isAllLoaded;
@synthesize isLoading = _isLoading;

#pragma mark - Setup methods

- (void)setup {
    self.isAllLoaded = NO;
    [super setup];
}

- (void)initialize {
    [self setIsAllLoaded:self.isAllLoaded];
}

#pragma mark - Accessors

- (id)offset {
    if(!_offset) {
        id item = [_items lastObject];
        NSNumber *offset = @0;
        if([item respondsToSelector:@selector(identifier)]) {
            offset = [item valueForKeyPath:@"identifier"];
        }
        return _isRefreshing ? @0 : offset;
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

- (void)setIsAllLoaded:(BOOL)isAllLoaded {
    _isAllLoaded = isAllLoaded;
    // TODO: think about this
    // iCarousel is not UIScrollView child;
    if(isAllLoaded) {
        if([self.scrollView respondsToSelector:@selector(addInfiniteScrollWithHandler:)]) {
            [self.scrollView finishInfiniteScroll];
            [self.scrollView removeInfiniteScroll];
        }
    } else {
        if([self.scrollView respondsToSelector:@selector(addInfiniteScrollWithHandler:)]) {
            if(!self.isAllLoaded) {
                [self.scrollView addInfiniteScrollWithHandler:^(id scrollView) {
                    [self loadMoreItems];
                }];
            }
        }
    }
}

#pragma mark - VGURLContent management

- (void)loadItems {
}

- (void)refresh {
    _isRefreshing = YES;
    [self notifyWillLoad];
    [self loadItems];
}

- (void)loadMoreItems {
    _isLoading = YES;
    [self notifyWillLoad];
    [self loadItems];
}

- (void)cancel {
}

#pragma mark - URL fetching management

- (void)fetchLoadedItems:(NSArray *)items error:(NSError *)error {
    if(error) {
        [self notifyDidFailWithError:error];
        return;
    }
    if (_isRefreshing) { // TODO: handle situations when can infinite scroll with search string.
        self.originalItems = [NSMutableArray arrayWithArray:items];
        if([self.settings[VGAnimatedRefresh] boolValue]) {
            _offset = nil;
            [self deleteItems:_items animated:YES];
            [self insertItems:items atIndex:_items.count animated:YES];
        } else {
            [_items removeAllObjects];
            _offset = nil;
            if([self.settings[VGReloadOnRefresh] boolValue]) {
                [_items addObjectsFromArray:items];
                [self reload];
            } else {
                [self reload];
                [self insertItems:items atIndex:_items.count animated:NO];
            }
        }
    } else {
        [self insertItems:items atIndex:_items.count animated:YES];
    }
    [self notifyDidLoadWithItems:items];
    _isRefreshing = NO;
    _isLoading = NO;
    if([self.scrollView respondsToSelector:@selector(finishInfiniteScroll)]) {
        [self.scrollView finishInfiniteScroll];
    }
}

- (void)fetchLoadedItems:(NSArray *)items pageSize:(NSInteger)pageSize error:(NSError *)error {
    self.filteredItems = nil;
    [self fetchLoadedItems:items error:error];
    self.isAllLoaded = items.count < pageSize;
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
