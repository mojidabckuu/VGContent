//
//  UIView+Identifier.m
//  CGContent
//
//  Created by Vlad Gorbenko on 6/18/15.
//  Copyright (c) 2015 Vlad Gorbenko. All rights reserved.
//

#import "UIView+Identifier.h"

@implementation UIView (Identifier)

// Swift realisation NSStringFromClass() returns module name separated by '.'
+ (NSString*)identifier {
    NSString *className = NSStringFromClass([self class]);
    return [[className componentsSeparatedByString:@"."] lastObject];
}

@end
