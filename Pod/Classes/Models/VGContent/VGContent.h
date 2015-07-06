//
//  VGContent.h
//  VGContent
//
//  Created by Vlad Gorbenko on 5/6/15.
//  Copyright (c) 2015 Vlad Gorbenko. All rights reserved.
//

#import <Foundation/Foundation.h>

@class VGContent;

@protocol VGContentDelegate <NSObject>

@optional
- (void)content:(VGContent *)content didSelectItem:(id)item;
- (void)content:(VGContent *)content didDeselectItem:(id)item;

@end

@interface VGContent :  NSObject {
    NSMutableArray *_items;
}

@property (nonatomic, assign) id<VGContentDelegate> delegate;

@property (nonatomic, assign, readonly) NSInteger itemsCount;
@property (nonatomic, assign, readonly) NSArray *items;

@property (nonatomic, assign, readonly) id selectedItem;

@property (nonatomic, strong) NSString *cellIdentifier;

#pragma mark - Lifecycle
- (instancetype)initWithView:(UIView *)view;

#pragma mark - Setup methods
- (void)setup;

#pragma mark - UI items management
- (void)setItems:(NSArray *)items;
- (id)itemAtIndex:(NSInteger)index;
- (NSInteger)indexOfItem:(id)item;
- (void)insertItem:(id)item atIndex:(NSInteger)index;
- (void)insertItems:(NSArray *)items;
- (void)deleteItem:(id)item;
- (void)deleteItems:(NSArray *)items;
- (void)insertItem:(id)item atIndex:(NSInteger)index section:(NSInteger)section;
- (void)selectItem:(id)item animated:(BOOL)animated;
- (void)selectItem:(id)item;
- (void)deselectItem:(id)item animated:(BOOL)animated;
- (void)deselectItem:(id)item;
- (void)reloadItem:(id)item;

#pragma mark - Utils
- (NSArray *)insertIndexPathsWithItems:(NSArray *)items;
- (NSArray *)deleteIndexPathsWithItems:(NSArray *)items;

@end
