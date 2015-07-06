//
//  VGContent.m
//  VGContent
//
//  Created by Vlad Gorbenko on 5/6/15.
//  Copyright (c) 2015 Vlad Gorbenko. All rights reserved.
//

#import "VGContent.h"

@implementation VGContent

#pragma mark - VGContent lifecycle

- (instancetype)init {
    self = [super init];
    if (self) {
        _items = [[NSMutableArray alloc] init];
        [self setup];
    }
    return self;
}

- (instancetype)initWithView:(UIView *)view {
    self = [super init];
    if(self) {
        [self setup];
    }
    return self;
}

- (void)dealloc {
    _items = nil;
}

#pragma mark - Setup methods

- (void)setup {
}

#pragma mark - Accessors

- (NSInteger)itemsCount {
    return _items.count;
}

- (id)selectedItem {
    return nil;
}

- (void)setItems:(NSArray *)items {
    [_items removeAllObjects];
    [_items addObjectsFromArray:items];
}

- (NSArray *)items {
    return _items;
}

#pragma mark - Items management

- (id)itemAtIndex:(NSInteger)index {
    if (index >= 0 && index < _items.count) {
        return _items[index];
    }
    return nil;
}

- (NSInteger)indexOfItem:(id)item {
    return [_items indexOfObject:item];
}

- (void)insertItem:(id)item atIndex:(NSInteger)index {
}

- (void)insertItems:(NSArray *)items {
}

- (void)insertItem:(id)item atIndex:(NSInteger)index section:(NSInteger)section {
}

- (void)deleteItem:(id)item {
}

- (void)deleteItems:(NSArray *)items {
}

- (void)selectItem:(id)item animated:(BOOL)animated {
}

- (void)selectItem:(id)item {
}

- (void)deselectItem:(id)item animated:(BOOL)animated {
}

- (void)deselectItem:(id)item {
}

- (void)reloadItem:(id)item {
}

#pragma mark - Utils

- (NSArray *)insertIndexPathsWithItems:(NSArray *)items {
    return [self indexPathsWithItems:items];
}

- (NSArray *)deleteIndexPathsWithItems:(NSArray *)items {
    return [self indexPathsWithItems:items];
}

- (NSArray *)indexPathsWithItems:(NSArray *)items {
    NSMutableArray *indexPaths = [NSMutableArray array];
    for (id item in items) {
        NSInteger index = [_items indexOfObject:item];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        [indexPaths addObject:indexPath];
    }
    return [NSArray arrayWithArray:indexPaths];
}

@end
