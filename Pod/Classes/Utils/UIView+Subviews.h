//
//  UIView+Subviews.h
//  Pods
//
//  Created by Vlad Gorbenko on 2/24/16.
//
//

#import <UIKit/UIKit.h>

@interface UIView (Subviews)

- (BOOL)containsViewWithClass:(Class)class;
- (UIView *)subviewWithClass:(Class)class;

@end
