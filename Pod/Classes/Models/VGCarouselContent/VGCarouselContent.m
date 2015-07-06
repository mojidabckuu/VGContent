//
//  VGCarouselContent.m
//  VGContent
//
//  Created by Vlad Gorbenko on 5/11/15.
//  Copyright (c) 2015 Vlad Gorbenko. All rights reserved.
//

#import "VGCarouselContent.h"

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

#pragma mark - iCarousel data source

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel {
    return _items.count;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(VGCarouselContentView *)view {
    if (view == nil) {
        view = [[VGCarouselContentView alloc] initWithFrame:carousel.bounds];
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

#pragma mark - Insert management

- (void)insertItems:(NSArray *)items atIndex:(NSInteger)index animated:(BOOL)animated {
    for(NSInteger i = 0; i < items.count; i++) {
        NSInteger insertIndex = i + index;
        [_items insertObject:items atIndex:insertIndex];
        [self.carousel insertItemAtIndex:insertIndex animated:animated];
    }
}

#pragma mark - Delete management

- (void)deleteItems:(NSArray *)items animated:(BOOL)animated {
    NSArray *indexPathsToDelete = [self indexPathsWithItems:items];
    for(NSInteger i = 0; i < indexPathsToDelete.count; i++) {
        NSIndexPath *indexPath = indexPathsToDelete[i];
        [_items removeObjectAtIndex:indexPath.row];
        [self.carousel removeItemAtIndex:indexPath.row animated:animated];
    }
}

#pragma mark - Selection management

- (void)selectItem:(id)item animated:(BOOL)animated {
    if(item) {
        NSInteger index = [_items indexOfObject:item];
        [self.carousel setCurrentItemIndex:index];
    }
}

- (void)deselectItem:(id)item animated:(BOOL)animated {
}

#pragma mark - Reload management

- (void)reloadItems:(NSArray *)items animated:(BOOL)animated {
    [self reload];
}

- (void)reload {
    [self.carousel reloadData];
}

@end

#endif
