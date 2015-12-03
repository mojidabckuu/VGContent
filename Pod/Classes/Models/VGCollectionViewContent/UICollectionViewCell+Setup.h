//
//  UICollectionViewCell+Setup.h
//  VGContent
//
//  Created by Vlad Gorbenko on 5/7/15.
//  Copyright (c) 2015 Vlad Gorbenko. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VGContent;

@interface UICollectionViewCell (Setup)

@property (nonatomic, weak) VGContent *content;

- (void)setupWithItem:(id)item;

@end
