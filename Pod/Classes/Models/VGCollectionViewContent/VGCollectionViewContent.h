//
//  VGCollectionViewContent.h
//  VGContent
//
//  Created by Vlad Gorbenko on 5/6/15.
//  Copyright (c) 2015 Vlad Gorbenko. All rights reserved.
//

#import "VGURLContent.h"

#import "UICollectionViewCell+Setup.h"

#import "UIView+Identifier.h"

@interface VGCollectionViewContent : VGURLContent <UICollectionViewDataSource, UICollectionViewDelegate>

/**
 Reference on UICollectionView object.
 */
@property (nonatomic, weak) UICollectionView *collectionView;

- (instancetype)initWithCollectionView:(UICollectionView *)collectionView;

/**
 Setup method for UICollectionViewLayout.
 */
- (void)setupLayout;

@end
