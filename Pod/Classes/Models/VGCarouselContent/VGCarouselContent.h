//
//  VGCarouselContent.h
//  VGContent
//
//  Created by Vlad Gorbenko on 5/11/15.
//  Copyright (c) 2015 Vlad Gorbenko. All rights reserved.
//

#import "VGURLContent.h"

#ifdef ICAROUSEL_H

#import "UIView+Setup.h"

#import <iCarousel/iCarousel.h>

@protocol VGCarouselContentDelegate <VGContentDelegate>

@optional
- (void)content:(VGURLContent *)content didChangeCurrentItem:(id)item;

@end

@interface VGCarouselContent : VGURLContent

@property (nonatomic, assign) iCarousel *carousel;
@property (nonatomic, assign) id<VGCarouselContentDelegate> delegate;

- (instancetype)initWithCarousel:(iCarousel *)carousel;
- (instancetype)initWithCarousel:(iCarousel *)carousel infinite:(BOOL)infinite;

@end

#endif
