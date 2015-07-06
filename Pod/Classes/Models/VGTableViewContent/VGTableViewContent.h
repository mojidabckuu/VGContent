//
//  FTTableViewContent.h
//  VGContent
//
//  Created by Vlad Gorbenko on 5/6/15.
//  Copyright (c) 2015 Vlad Gorbenko. All rights reserved.
//

#import "VGURLContent.h"

#import "UITableViewCell+Setup.h"

@interface VGTableViewContent : VGURLContent <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, assign) UITableView *tableView;

#pragma mark - Init
- (instancetype)initWithTableView:(UITableView *)tableView;
- (instancetype)initWithTableView:(UITableView *)tableView infinite:(BOOL)infinite;

@end
