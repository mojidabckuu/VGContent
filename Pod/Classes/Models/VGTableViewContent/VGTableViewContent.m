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
    self = [super initWithView:view];
    if(self) {
        self.tableView = tableView;
        [self setupTableVIew];
    }
    return self;
}

- (void)dealloc {
    self.tableView.dataSource = nil;
    self.tableView.delegate = nil;
    self.tableView = nil;
}

#pragma mark - Setup

- (void)setupTableVIew {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
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

#pragma mark - Modifiers

- (void)setCellIdentifier:(NSString *)cellIdentifier {
    [super setCellIdentifier:cellIdentifier];
    
    id cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell) {
        return;
    }
    
    BOOL registered = NO;
    NSBundle *bundle = [NSBundle bundleForClass:NSClassFromString(cellIdentifier)];
    if ([bundle pathForResource:cellIdentifier ofType:@"nib"]) {
        UINib *nib = [[bundle loadNibNamed:cellIdentifier owner:nil options:nil] firstObject];
        if(nib) {
            [self.tableView registerNib:nib forCellReuseIdentifier:cellIdentifier];
            registered = YES;
        }
    }
    if(!registered) {
        Class class = NSClassFromString(cellIdentifier);
        if(!class) {
            class = [UITableViewCell class];
        }
        [self.tableView registerClass:class forCellReuseIdentifier:cellIdentifier];
    }
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if([self.delegate respondsToSelector:@selector(content:didSelectItem:)]) {
        [self.delegate content:self didSelectItem:_items[indexPath.row]];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    if([self.delegate respondsToSelector:@selector(content:didDeselectItem:)]) {
        [self.delegate content:self didDeselectItem:_items[indexPath.row]];
    }
}

#pragma mark - Insert management

- (void)insertItem:(id)item atIndex:(NSInteger)index animation:(UITableViewRowAnimation)animation {
    if(item) {
        [self insertItems:@[item] atIndex:index animation:animation];
    }
}

- (void)insertItems:(NSArray *)items atIndex:(NSInteger)index animated:(BOOL)animated {
    UITableViewRowAnimation animation = animated ? UITableViewRowAnimationAutomatic : UITableViewRowAnimationNone;
    [self insertItems:items atIndex:index animation:animation];
}

- (void)insertItems:(NSArray *)items atIndex:(NSInteger)index animation:(UITableViewRowAnimation)animation {
    if(self.isRefreshing) {
        [_items removeAllObjects];
        //TODO: refreshing animation
        [self.tableView reloadData];
    }
    for(NSInteger i = 0; i < items.count; i++) {
        [_items insertObject:items[i] atIndex:i + index];
    }
    NSArray *indexesToInsert = [self indexPathsWithItems:items];
    [self.tableView insertRowsAtIndexPaths:indexesToInsert withRowAnimation:animation];
}

#pragma mark - Delete management

- (void)deleteItem:(id)item animation:(UITableViewRowAnimation)animation {
    if(item) {
        [self deleteItems:@[item] animation:animation];
    }
}

- (void)deleteItems:(NSArray *)items animated:(BOOL)animated {
    UITableViewRowAnimation animation = animated ? UITableViewRowAnimationAutomatic : UITableViewRowAnimationNone;
    [self deleteItems:items animation:animation];
}

- (void)deleteItems:(NSArray *)items animation:(UITableViewRowAnimation)animation {
    NSArray *indexesToDelete = [self indexPathsWithItems:items];
    [_items removeObjectsInArray:items];
    [self.tableView deleteRowsAtIndexPaths:indexesToDelete withRowAnimation:animation];
}

#pragma mark - Selection managemtn

- (void)selectItem:(id)item animated:(BOOL)animated {
    if([_items containsObject:item]) {
        NSInteger index = [_items indexOfObject:item];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        [self.tableView selectRowAtIndexPath:indexPath animated:animated scrollPosition:UITableViewScrollPositionNone];
    }
}

- (void)deselectItem:(id)item animated:(BOOL)animated {
    if([_items containsObject:item]) {
        NSInteger index = [_items indexOfObject:item];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        [self.tableView deselectRowAtIndexPath:indexPath animated:animated];
    }
}

#pragma mark - Reload management

- (void)reloadItem:(id)item animation:(UITableViewRowAnimation)animation {
    if(item) {
        [self reloadItems:@[item] animation:animation];
    }
}

- (void)reloadItems:(NSArray *)items animated:(BOOL)animated {
    UITableViewRowAnimation animation = animated ? UITableViewRowAnimationAutomatic : UITableViewRowAnimationNone;
    [self reloadItems:items animation:animation];
}

- (void)reloadItems:(NSArray *)items animation:(UITableViewRowAnimation)animation {
    if(items.count) {
        NSArray *indexPathsToReload = [self indexPathsWithItems:items];
        [self.tableView reloadRowsAtIndexPaths:indexPathsToReload withRowAnimation:animation];
    }
}

- (void)reload {
    [self.tableView reloadData];
}

@end
