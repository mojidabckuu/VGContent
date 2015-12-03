//
//  UITableViewCell+Setup.h
//  ALJ
//
//  Created by vlad gorbenko on 5/7/15.
//  Copyright (c) 2015 Alex Zdorovets. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VGContent;

@interface UITableViewCell (Setup)

@property (nonatomic, weak) VGContent *content;

- (void)setupWithItem:(id)item;

@end
