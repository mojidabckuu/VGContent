//
//  FTTableViewContent.h
//  VGContent
//
//  Created by Vlad Gorbenko on 5/6/15.
//  Copyright (c) 2015 Vlad Gorbenko. All rights reserved.
//

#import "VGURLContent.h"

#import "UITableViewCell+Setup.h"

#import "UIView+Identifier.h"

@interface VGTableViewContent : VGURLContent <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) UITableView *tableView;

#pragma mark - Items management

- (void)insertItem:(id)item atIndex:(NSInteger)index animation:(UITableViewRowAnimation)animation;
- (void)insertItems:(NSArray *)items atIndex:(NSInteger)index animation:(UITableViewRowAnimation)animation;
- (void)deleteItem:(id)item animation:(UITableViewRowAnimation)animation;
- (void)deleteItems:(NSArray *)items animation:(UITableViewRowAnimation)animation;
- (void)reloadItem:(id)item animation:(UITableViewRowAnimation)animation;
- (void)reloadItems:(NSArray *)items animation:(UITableViewRowAnimation)animation;

@end
