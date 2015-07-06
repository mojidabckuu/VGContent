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

@property (nonatomic, assign) UICollectionView *collectionView;

- (instancetype)initWithCollectionView:(UICollectionView *)collectionView;

- (void)setupLayout;

@end
