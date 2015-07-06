//
//  VGTableViewContent.m
//  VGContent
//
//  Created by Vlad Gorbenko on 5/6/15.
//  Copyright (c) 2015 Vlad Gorbenko. All rights reserved.
//

#import "VGTableViewContent.h"

@interface VGTableViewContent ()

@property (nonatomic, readonly, strong) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) UIView *tableFooterView;

@end

@implementation VGTableViewContent

#pragma mark - VGTableViewContent lifecycle

- (instancetype)initWithView:(UIView *)view {
    NSAssert([view isKindOfClass:[UITableView class]], @"You passed not UITableView view");
    UITableView *tableView = (UITableView *)view;
    self = [self initWithTableView:tableView];
    if(self) {
    }
    return self;
}

- (instancetype)initWithTableView:(UITableView *)tableView {
    self = [self initWithTableView:tableView infinite:NO];
    if(self) {
    }
    return self;
}

- (instancetype)initWithTableView:(UITableView *)tableView infinite:(BOOL)infinite {
    self = [self init];
    if(self) {
        self.tableView = tableView;
        if(infinite) {
            self.tableView.tableFooterView = self.tableFooterView;
        }
        self.isAllLoaded = !infinite;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
    }
    return self;
}

- (void)dealloc {
    self.tableView.dataSource = nil;
    self.tableView.delegate = nil;
    self.tableView = nil;
}

#pragma mark - Accessors

- (UIView *)tableFooterView {
    if(!_tableFooterView) {
        CGRect frame = CGRectMake(0, 0, self.tableView.frame.size.width, 44);
        UIView *tableFooterView = [[UIView alloc] initWithFrame:frame];
        _activityIndicator = [[UIActivityIndicatorView alloc] init];
        [tableFooterView addSubview:self.activityIndicator];
        _tableFooterView = tableFooterView;
    }
    return _tableFooterView;
}

- (id)selectedItem {
    NSIndexPath *indexPath = self.tableView.indexPathForSelectedRow;
    if(indexPath) {
        return _items[indexPath.row];
    }
    return nil;
}

- (void)setItems:(NSArray *)items {
    [_items removeAllObjects];
    [_items addObjectsFromArray:items];
    [self.tableView reloadData];
}

#pragma mark - UITableView data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = self.cellIdentifier ?: [UITableViewCell identifier];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        Class class = NSClassFromString(identifier);
        cell = [[class alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setupWithItem:_items[indexPath.row]];
    if(!self.cellIdentifier) {
        cell.textLabel.text = [NSString stringWithFormat:@"%ld", (long)indexPath.row];
    }
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return nil;
}

#pragma mark - UITableView delegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row == _items.count - 1) {
        if(!self.isAllLoaded && !self.isLoading) {
            self.showLoading = YES;
            [self loadMoreItems];
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if([self.delegate respondsToSelector:@selector(content:didSelectItem:)]) {
        [self.delegate content:self didSelectItem:_items[indexPath.row]];
    }
}

#pragma mark - VGContent management

- (void)reload {
    [self.tableView reloadData];
}

#pragma mark - Items management

- (void)insertItem:(id)item atIndex:(NSInteger)index {
    [self insertItem:item atIndex:index section:0];
}

- (void)insertItems:(NSArray *)items {
    if(_isRefreshing) {
        [_items removeAllObjects];
        [self.tableView reloadData];
        [_items addObjectsFromArray:items];
    }
    NSArray *indexesToInsert = [self insertIndexPathsWithItems:items];
    [self.tableView insertRowsAtIndexPaths:indexesToInsert withRowAnimation:UITableViewRowAnimationAutomatic];
    if(items.count) {
        self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    }
}

- (void)deleteItem:(id)item {
    NSInteger index = [_items indexOfObject:item];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [_items removeObject:item];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)deleteItems:(NSArray *)items {
    NSArray *indexPathsToDelete = [self deleteIndexPathsWithItems:items];
    [_items removeObjectsInArray:items];
    [self.tableView deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)insertItem:(id)item atIndex:(NSInteger)index section:(NSInteger)section {
    [_items insertObject:item atIndex:index];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:section];
    [self.tableView insertRowsAtIndexPaths:@[ indexPath ] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)selectItem:(id)item animated:(BOOL)animated {
    if(item) {
        NSInteger index = [_items indexOfObject:item];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        [self.tableView selectRowAtIndexPath:indexPath animated:animated scrollPosition:UITableViewScrollPositionNone];
    }
}

- (void)selectItem:(id)item {
    [self selectItem:item animated:NO];
}

- (void)deselectItem:(id)item animated:(BOOL)animated {
    if(item) {
        NSInteger index = [_items indexOfObject:item];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        [self.tableView deselectRowAtIndexPath:indexPath animated:animated];
    }
}

- (void)deselectItem:(id)item {
    [self deselectItem:item animated:NO];
}

- (void)reloadItem:(id)item {
    if(item && [_items containsObject:item]) {
        NSInteger index = [_items indexOfObject:item];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
}

@end
