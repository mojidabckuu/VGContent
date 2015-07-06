//
//  FTCarouselContent.m
//  VGContent
//
//  Created by Vlad Gorbenko on 5/11/15.
//  Copyright (c) 2015 Vlad Gorbenko. All rights reserved.
//

#import "VGCarouselContent.h"

#import "UIView+Setup.h"

#ifdef ICAROUSEL_H

#import "VGCarouselContentView.h"

@interface VGCarouselContent () <iCarouselDataSource, iCarouselDelegate>

@end

@implementation VGCarouselContent

#pragma mark - VGCarouselContent

- (instancetype)initWithView:(UIView *)view {
    NSAssert([view isKindOfClass:[iCarousel class]], @"You passed not iCarousel view");
    iCarousel *carousel = (iCarousel *)view;
    self = [self initWithCarousel:carousel];
    if(self) {
    }
    return self;
}

- (instancetype)initWithCarousel:(iCarousel *)carousel {
    self = [self initWithCarousel:carousel infinite:NO];
    if(self) {
        self.carousel = carousel;
        self.carousel.delegate = self;
        self.carousel.dataSource = self;
    }
    return self;
}

- (instancetype)initWithCarousel:(iCarousel *)carousel infinite:(BOOL)infinite {
    self = [super init];
    if(self) {
        self.carousel = carousel;
        self.carousel.dataSource = self;
        self.carousel.delegate = self;
    }
    return self;
}

#pragma mark - VGContent management

- (void)reload {
    [self.carousel reloadData];
}

#pragma mark - iCarousel data source

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel {
    return _items.count;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(FTCarouselContentView *)view {
    if (view == nil) {
        view = [[FTCarouselContentView alloc] initWithFrame:carousel.bounds];
        Class class = self.cellIdentifier ? NSClassFromString(self.cellIdentifier) : [UIView class];
        UIView *reuseView = [[class alloc] initWithFrame:self.carousel.bounds];
        reuseView.backgroundColor = [UIColor clearColor];
        view.contentView = reuseView;
    }
    [view.contentView setupWithItem:_items[index]];
    return view;
}

#pragma mark - iCarousel delegate

- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index {
    if([self.delegate respondsToSelector:@selector(content:didSelectItem:)]) {
        [self.delegate content:self didSelectItem:_items[index]];
    }
}

- (void)carouselCurrentItemIndexDidChange:(iCarousel *)carousel {
    if([self.delegate respondsToSelector:@selector(content:didChangeCurrentItem:)]) {
        [self.delegate content:self didChangeCurrentItem:_items[carousel.currentItemIndex]];
    }
}

#pragma mark - Items management

- (id)selectedItem {
    return _items[self.carousel.currentItemIndex];
}

@end

#endif
