//
//  VGCarouselContent.m
//  VGContent
//
//  Created by Vlad Gorbenko on 5/11/15.
//  Copyright (c) 2015 Vlad Gorbenko. All rights reserved.
//

#import "VGCarouselContent.h"

#import "VGCarouselContentView.h"
#import "UIView+Identifier.h"

#import "VGXibView.h"

@interface VGCarouselContent () <iCarouselDataSource, iCarouselDelegate>

@property (nonatomic, assign) BOOL nibExists;

@end

@implementation VGCarouselContent

@dynamic delegate;

#pragma mark - VGCarouselContent

- (instancetype)initWithView:(UIView *)view {
    NSAssert([view isKindOfClass:[iCarousel class]], @"You passed not iCarousel view");
    iCarousel *carousel = (iCarousel *)view;
    self = [super initWithView:carousel];
    if(self) {
        [self setupiCarousel];
    }
    return self;
}

#pragma mark - Setup

- (void)setupiCarousel {
    self.carousel.delegate = self;
    self.carousel.dataSource = self;
}

#pragma mark - Modifiers

- (void)setCellIdentifier:(NSString *)cellIdentifier {
    [super setCellIdentifier:cellIdentifier];
    [self registerCellIdentifier:cellIdentifier];
}

- (BOOL)registerCellIdentifier:(NSString *)cellIdentifier {
    self.nibExists = NO;
    NSBundle *bundle = [NSBundle bundleForClass:NSClassFromString(cellIdentifier)];
    if ([bundle pathForResource:cellIdentifier ofType:@"nib"]) {
        //        UINib *nib = [UINib nibWithNibName:cellIdentifier bundle:nil];
        //        if(nib) {
        self.nibExists = YES;
        //        }
    }
    return self.nibExists;
}

#pragma mark - Accessors

- (iCarousel *)carousel {
    return (iCarousel *)self.view;
}

#pragma mark - iCarousel data source

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel {
    return _items.count;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(VGCarouselContentView *)view {
    id item = [self itemAtIndex:index];
    if (view == nil) {
        UIView *contentView = nil;
        if(self.nibExists) {
            contentView = [ClassFromString(self.cellIdentifier) loadFromNib];
            CGRect frame = [self carousel:carousel frameForItem:item view:contentView];
            contentView.frame = frame;
        } else {
            Class class = self.cellIdentifier ? ClassFromString(self.cellIdentifier) : [UIView class];
            contentView = [[class alloc] initWithFrame:self.carousel.bounds];
            contentView.backgroundColor = [UIColor clearColor];
            CGRect viewFrame = [self carousel:carousel frameForItem:item view:contentView];
            contentView.frame = viewFrame;
        }
        view = [[VGCarouselContentView alloc] initWithFrame:contentView.bounds];
        view.contentView = contentView;
    }
    [view.contentView setupWithItem:item];
    return view;
}

#pragma mark - iCarousel delegate

- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index {
    if([self.delegate respondsToSelector:@selector(content:didSelectItem:)]) {
        [self.delegate content:self didSelectItem:[self itemAtIndex:index]];
    }
}

- (void)carouselCurrentItemIndexDidChange:(iCarousel *)carousel {
    if([self.delegate respondsToSelector:@selector(content:didChangeCurrentItem:)]) {
        [self.delegate content:self didChangeCurrentItem:[self itemAtIndex:carousel.currentItemIndex]];
    }
}

#pragma mark - Items management

- (id)selectedItem {
    return [self itemAtIndex:self.carousel.currentItemIndex];
}

#pragma mark - Insert management

- (void)insertItems:(NSArray *)items atIndex:(NSInteger)index animated:(BOOL)animated {
    [self reload];
    for(NSInteger i = 0; i < items.count; i++) {
        NSInteger insertIndex = i + index;
        [_items insertObject:items[i] atIndex:insertIndex];
        [self.carousel insertItemAtIndex:insertIndex animated:animated];
    }
    [super insertItems:items atIndex:index animated:animated];
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
        if(index != NSNotFound) {
            [self.carousel setCurrentItemIndex:index];
        }
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

#pragma mark - Layout

- (CGRect)carousel:(iCarousel *)carousel frameForItem:(id)item view:(UIView *)view {
    return carousel.bounds;
}

@end
