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
    self = [super initWithView:collectionView];
    if(self) {
        [self setupCollectionView];
    }
    return self;
}

#pragma mark - Setup methods

- (void)setupLayout {
}

- (void)setupCollectionView {
    [self setupLayout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
}

#pragma mark - Accessors

- (UICollectionView *)collectionView {
    return (UICollectionView *)self.view;
}

#pragma mark - Insert management

- (void)insertItems:(NSArray *)items atIndex:(NSInteger)index animated:(BOOL)animated {
    for(NSInteger i = 0; i < items.count; i++) {
        [_items insertObject:items[i] atIndex:i + index];
    }
    NSArray *indexPathsToInsert = [self indexPathsWithItems:items];
    if(_items.count == 1) {
        [self.collectionView reloadData];
    } else {
        [self.collectionView performBatchUpdates:^{
            [self.collectionView insertItemsAtIndexPaths:indexPathsToInsert];
        } completion:nil];
    }
}

#pragma mark - Delete management

- (void)deleteItems:(NSArray *)items animated:(BOOL)animated {
    NSArray *indexesToDelete = [self indexPathsWithItems:items];
    [_items removeObjectsInArray:items];
    [self.collectionView performBatchUpdates:^{
        [self.collectionView deleteItemsAtIndexPaths:indexesToDelete];
    } completion:nil];
}

#pragma mark - Selection management

- (void)selectItem:(id)item animated:(BOOL)animated {
    if(item && [_items containsObject:item]) {
        NSIndexPath *indexPath = [self indexPathsWithItems:@[item]].firstObject;
        [self.collectionView selectItemAtIndexPath:indexPath animated:animated scrollPosition:UICollectionViewScrollPositionNone];
    }
}

- (void)selectItems:(NSArray *)items animated:(BOOL)animated {
    for(id item in items) {
        [self selectItem:item animated:animated];
    }
}

- (void)deselectItem:(id)item animated:(BOOL)animated {
    if(item && [_items containsObject:item]) {
        NSIndexPath *indexPath = [self indexPathsWithItems:@[item]].firstObject;
        [self.collectionView deselectItemAtIndexPath:indexPath animated:animated];
    }
}

#pragma mark - Reload management

- (void)reloadItems:(NSArray *)items animated:(BOOL)animated {
    NSArray *indexPathsToReload = [self indexPathsWithItems:items];
    [self.collectionView performBatchUpdates:^{
        [self.collectionView reloadItemsAtIndexPaths:indexPathsToReload];
    } completion:nil];
}

- (void)reload {
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

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    if([self.delegate respondsToSelector:@selector(content:didDeselectItem:)]) {
        [self.delegate content:self didDeselectItem:_items[indexPath.row]];
    }
}

#pragma mark - Utils

- (BOOL)registerCellIdentifier:(NSString *)cellIdentifier {
    BOOL registered = NO;
    NSBundle *bundle = [NSBundle bundleForClass:NSClassFromString(cellIdentifier)];
    if ([bundle pathForResource:cellIdentifier ofType:@"nib"]) {
        UINib *nib = [UINib nibWithNibName:cellIdentifier bundle:nil];
        if(nib) {
            [self.collectionView registerNib:nib forCellWithReuseIdentifier:cellIdentifier];
            registered = YES;
        }
    }
    if(!registered) {
        Class class = NSClassFromString(cellIdentifier);
        if(!class) {
            class = [UITableViewCell class];
        }
        [self.collectionView registerClass:class forCellWithReuseIdentifier:cellIdentifier];
        registered = YES;
    }
    return registered;
}


@end
