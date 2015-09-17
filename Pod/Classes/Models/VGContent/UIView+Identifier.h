//
//  UIView+Identifier.h
//  VGContent
//
//  Created by Vlad Gorbenko on 6/18/15.
//  Copyright (c) 2015 Vlad Gorbenko. All rights reserved.
//

#import <UIKit/UIKit.h>

Class ClassFromString(NSString *className);

@interface UIView (Identifier)

+ (NSString*)identifier;

@end
