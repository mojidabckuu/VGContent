//
//  VGContent.m
//  VGContent
//
//  Created by Vlad Gorbenko on 5/6/15.
//  Copyright (c) 2015 Vlad Gorbenko. All rights reserved.
//

#import "VGContent.h"

@implementation VGContent

@synthesize filteredItems = _filteredItems;
@synthesize originalItems = _originalItems;

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
        _items = [[NSMutableArray alloc] init];
        self.view = view;
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

- (id)selectedItems {
    return nil;
}

- (void)setItems:(NSArray *)items {
    [_items removeAllObjects];
    [_items addObjectsFromArray:items];
    _originalItems = _items;
    [self reload];
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

#pragma mark - Insert management

- (void)insertItem:(id)item atIndex:(NSInteger)index {
    [self insertItem:item atIndex:index animated:NO];
}

- (void)insertItem:(id)item atIndex:(NSInteger)index animated:(BOOL)animated {
    if(item) {
        [self insertItems:@[item] atIndex:index animated:animated];
    }
}

- (void)insertItems:(NSArray *)items atIndex:(NSInteger)index {
    [self insertItems:items atIndex:index animated:NO];
}

- (void)insertItems:(NSArray *)items atIndex:(NSInteger)index animated:(BOOL)animated {
    if([self.delegate respondsToSelector:@selector(content:didAddItem:)]) {
        for (id item in items) {
            [self.delegate content:self didAddItem:item];
        }
    }
}

#pragma mark - Delete management

- (void)deleteItem:(id)item {
    [self deleteItem:item animated:NO];
}

- (void)deleteItem:(id)item animated:(BOOL)animated {
    if(item) {
        [self deleteItems:@[item] animated:animated];
    }
}

- (void)deleteItems:(NSArray *)items {
    [self deleteItems:items animated:NO];
}

- (void)deleteItems:(NSArray *)items animated:(BOOL)animated {
    @throw [NSException exceptionWithName:@"Unimplemented method" reason:@"This method is not overriden" userInfo:nil];
}

#pragma mark - Selection managemtn

- (void)selectItem:(id)item {
    [self selectItem:item animated:NO];
}

- (void)selectItem:(id)item animated:(BOOL)animated {
    @throw [NSException exceptionWithName:@"Unimplemented method" reason:@"This method is not overriden" userInfo:nil];
}

- (void)selectItems:(NSArray *)items {
    [self selectItems:items animated:NO];
}

- (void)selectItems:(NSArray *)items animated:(BOOL)animated {
    @throw [NSException exceptionWithName:@"Unimplemented method" reason:@"This method is not overriden" userInfo:nil];
}

- (void)deselectItem:(id)item {
    [self deselectItem:item animated:NO];
}

- (void)deselectItem:(id)item animated:(BOOL)animated {
    @throw [NSException exceptionWithName:@"Unimplemented method" reason:@"This method is not overriden" userInfo:nil];
}

#pragma mark - Reload management

- (void)reloadItem:(id)item {
    [self reloadItem:item animated:NO];
}

- (void)reloadItem:(id)item animated:(BOOL)animated {
    if(item) {
        [self reloadItems:@[item] animated:animated];
    }
}

- (void)reloadItems:(NSArray *)items {
    [self reloadItems:items animated:NO];
}

- (void)reloadItems:(NSArray *)items animated:(BOOL)animated {
    @throw [NSException exceptionWithName:@"Unimplemented method" reason:@"This method is not overriden" userInfo:nil];
}

- (void)reload {
    @throw [NSException exceptionWithName:@"Unimplemented method" reason:@"This method is not overriden" userInfo:nil];
}

#pragma mark - VGContentSearch protocol

- (void)searchWithString:(NSString *)string {
    _items = [NSMutableArray arrayWithArray:self.filteredItems];
}

- (void)searchWithString:(NSString *)string keyPath:(NSString *)keyPath {
    if(string.length) {
        NSPredicate *predicate = nil;
        if (keyPath) {
            predicate = [NSPredicate predicateWithFormat:@"self.%K contains[cd] %@", keyPath, string];
        }
        else {
            predicate = [NSPredicate predicateWithFormat:@"self contains[c] %@", string];
        }
        self.filteredItems = [self.originalItems filteredArrayUsingPredicate:predicate];
        _items = [NSMutableArray arrayWithArray:self.filteredItems];
    } else {
        self.filteredItems = nil;
        _items = self.originalItems;
    }
}

- (void)cancelSearch {
    self.filteredItems = nil;
}

#pragma mark - Utils

- (NSArray *)indexPathsWithItems:(NSArray *)items {
    NSMutableArray *indexPaths = [NSMutableArray array];
    for (id item in items) {
        NSInteger index = [_items indexOfObject:item];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        [indexPaths addObject:indexPath];
    }
    return [NSArray arrayWithArray:indexPaths];
}

- (BOOL)registerCellIdentifier:(NSString *)cellIdentifier {
    return FALSE;
}

@end
