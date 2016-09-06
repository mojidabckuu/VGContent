//
//  VGCarouselContent.h
//  VGContent
//
//  Created by Vlad Gorbenko on 5/11/15.
//  Copyright (c) 2015 Vlad Gorbenko. All rights reserved.
//

#import "VGURLContent.h"

#import "UIView+Setup.h"

#import <iCarousel/iCarousel.h>

@protocol VGCarouselContentDelegate <VGContentDelegate>

@optional
- (void)content:(VGURLContent *)content didChangeCurrentItem:(id)item;

@end

@interface VGCarouselContent : VGURLContent<iCarouselDelegate, iCarouselDataSource>

@property (nonatomic, weak, readonly) iCarousel *carousel;
@property (nonatomic, assign) id<VGCarouselContentDelegate> delegate;

- (CGRect)carousel:(iCarousel *)carousel frameForItem:(id)item view:(UIView *)view;

@end
