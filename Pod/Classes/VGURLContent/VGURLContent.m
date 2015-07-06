//
//  VGURLContent.m
//  VGContent
//
//  Created by Vlad Gorbenko on 05.07.15.
//  Copyright (c) 2015 Vlad Gorbenko. All rights reserved.
//

#import "VGURLContent.h"

@implementation VGURLContent

#pragma mark - Accessors

- (NSInteger)offset {
    return _isRefreshing ? 0 : self.itemsCount;
}

- (BOOL)isRefreshing {
    return _isRefreshing;
}

#pragma mark - VGURLContent management

- (void)loadItems {
}

- (void)refresh {
    _isRefreshing = YES;
    [self notifyWillLoaded];
    [self loadItems];
}

- (void)loadMoreItems {
    _isLoading = YES;
    [self notifyWillLoaded];
    [self loadItems];
}

- (void)cancel {
}

- (void)reload {
}

#pragma mark - URL fetching management

- (void)fetchLoadedItems:(NSArray *)items {
    if (_isRefreshing) {
        _items = [NSMutableArray arrayWithArray:items];
    } else {
        [_items addObjectsFromArray:items];
    }
    [self notifyDidLoadedWithItems:items];
    _isRefreshing = NO;
    _isLoading = NO;
    self.showLoading = !_isAllLoaded;
}

- (void)fetchLoadedItems:(NSArray *)items pageSize:(NSInteger)pageSize {
    _isAllLoaded = items.count < pageSize;
    [self fetchLoadedItems:items];
}

#pragma mark - Notifiers

- (void)notifyWithError:(NSError *)error {
    if ([self.dataDelegate respondsToSelector:@selector (content:didFailLoadingItemsWithError:)]) {
        [self.dataDelegate content:self didFailLoadingItemsWithError:error];
    }
}

- (void)notifyDidLoadedWithItems:(NSArray *)items {
    if ([self.dataDelegate respondsToSelector:@selector (content:didFinishLoadingWithItems:)]) {
        [self.dataDelegate content:self didFinishLoadingWithItems:items];
    }
}

- (void)notifyWillLoaded {
    if ([self.dataDelegate respondsToSelector:@selector (contentWillLoaded:)]) {
        [self.dataDelegate contentWillLoaded:self];
    }
}

@end
