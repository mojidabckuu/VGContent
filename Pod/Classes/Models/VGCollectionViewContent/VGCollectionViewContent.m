//
//  VGCollectionViewContent.m
//  VGContent
//
//  Created by Vlad Gorbenko on 5/6/15.
//  Copyright (c) 2015 Vlad Gorbenko. All rights reserved.
//

#import "VGCollectionViewContent.h"

@implementation VGCollectionViewContent

#pragma mark - VGCollectionViewContent lifecycle

- (instancetype)initWithView:(UIView *)view {
    NSAssert([view isKindOfClass:[UICollectionView class]], @"You passed not UICollectionView view");
    UICollectionView *collectionView = (UICollectionView *)view;
    self = [self initWithCollectionView:collectionView];
    if(self) {
    }
    return self;
}

- (instancetype)initWithCollectionView:(UICollectionView *)collectionView {
    self = [self init];
    if(self) {
        self.collectionView = collectionView;
        [self setupLayout];
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
    }
    return self;
}

#pragma mark - Setup methods

- (void)setupLayout {
    
}

#pragma mark - Items management

- (void)insertItem:(id)item atIndex:(NSInteger)index {
    if(![_items containsObject:item]) {
        [_items insertObject:item atIndex:0];
        if(_items.count == 1) {
            [self.collectionView reloadData];
        } else {
            [self.collectionView performBatchUpdates:^{
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
                [self.collectionView insertItemsAtIndexPaths:@[indexPath]];
            } completion:nil];
        }
    }
}

- (void)insertItems:(NSArray *)items {
    BOOL reload = !_items.count;
    NSMutableArray *indexPathToInsert = [NSMutableArray array];
    for(id item in items) {
        if(![_items containsObject:item]) {
            [_items addObject:item];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_items.count - 1 inSection:0];
            [indexPathToInsert addObject:indexPath];
        }
    }
    if(reload) {
        [self.collectionView reloadData];
    } else {
        if(indexPathToInsert.count) {
            [self.collectionView performBatchUpdates:^{
                [self.collectionView insertItemsAtIndexPaths:indexPathToInsert];
            } completion:nil];
        }
    }
}

- (void)setItems:(NSArray *)items {
    _items = [[NSMutableArray alloc] initWithArray:items];
    [self.collectionView reloadData];
}

- (id)selectedItem {
    NSIndexPath *indexPath = self.collectionView.indexPathsForSelectedItems.firstObject;
    if (indexPath) {
        return _items[indexPath.row];
    }
    return nil;
}

#pragma mark - UICollectionView data source

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _items.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if(self.cellIdentifier) {
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:self.cellIdentifier forIndexPath:indexPath];
        [cell setupWithItem:_items[indexPath.row]];
        return cell;
    } else {
        return nil;
    }
}

#pragma mark - UICollectionView delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if([self.delegate respondsToSelector:@selector(content:didSelectItem:)]) {
        [self.delegate content:self didSelectItem:_items[indexPath.row]];
    }
}

@end
