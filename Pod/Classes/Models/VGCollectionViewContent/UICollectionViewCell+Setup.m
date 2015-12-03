//
//  UICollectionViewCell+Setup.m
//  ALJ
//
//  Created by vlad gorbenko on 5/7/15.
//  Copyright (c) 2015 Alex Zdorovets. All rights reserved.
//

#import "UICollectionViewCell+Setup.h"

#import <objc/runtime.h>

@implementation UICollectionViewCell (Setup)

#pragma mark - Setup

- (void)setupWithItem:(id)item {
}

#pragma mark - Accessors

- (VGContent *)content {
    return objc_getAssociatedObject(self, @selector(content));
}

#pragma mark - Modifiers

- (void)setContent:(VGContent *)content {
    objc_setAssociatedObject(self, @selector(content), content, OBJC_ASSOCIATION_ASSIGN);
}

@end
