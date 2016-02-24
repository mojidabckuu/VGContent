//
//  UIRefreshControl+Animable.m
//  Pods
//
//  Created by Vlad Gorbenko on 2/24/16.
//
//

#import "UIRefreshControl+Animable.h"

@implementation UIRefreshControl (Animable)

#pragma mark - Accessors

- (BOOL)isAnimating {
    return self.isRefreshing;
}

#pragma mark - Animation management

- (void)startAnimating {
    [self beginRefreshing];
}

- (void)stopAnimating {
    [self endRefreshing];
}

@end
