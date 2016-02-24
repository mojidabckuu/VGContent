//
//  UIView+Subviews.m
//  Pods
//
//  Created by Vlad Gorbenko on 2/24/16.
//
//

#import "UIView+Subviews.h"

@implementation UIView (Subviews)

- (BOOL)containsViewWithClass:(Class)class {
    return [self subviewWithClass:class] != nil;
}

- (UIView *)subviewWithClass:(Class)class {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self isKindOfClass: %@", class];
    return [[self.subviews filteredArrayUsingPredicate:predicate] firstObject];
}

@end
