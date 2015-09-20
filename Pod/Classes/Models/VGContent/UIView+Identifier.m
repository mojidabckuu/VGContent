//
//  UIView+Identifier.m
//  CGContent
//
//  Created by Vlad Gorbenko on 6/18/15.
//  Copyright (c) 2015 Vlad Gorbenko. All rights reserved.
//

#import "UIView+Identifier.h"

//Swift realisation NSClassFromString:
Class ClassFromString(NSString *className) {
    Class cls = NSClassFromString(className);
    if (cls == nil) {
        NSString *appName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleExecutable"];
        className = [NSString stringWithFormat:@"%@.%@", appName, className];
        cls = NSClassFromString(className);
    }
    return cls;
}

@implementation UIView (Identifier)

// Swift realisation NSStringFromClass() returns module name separated by '.'
+ (NSString*)identifier {
    NSString *className = NSStringFromClass([self class]);
    return [[className componentsSeparatedByString:@"."] lastObject];
}

@end
