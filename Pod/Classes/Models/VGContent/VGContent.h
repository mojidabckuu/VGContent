//
//  VGContent.h
//  VGContent
//
//  Created by Vlad Gorbenko on 5/6/15.
//  Copyright (c) 2015 Vlad Gorbenko. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VGContent;

/**
 `VGContentProtocol` protocol that describes basic functionality for items.
 */
@protocol VGContentProtocol <NSObject>

@required
- (void)setItems:(NSArray *)items;
- (id)itemAtIndex:(NSInteger)index;
- (NSInteger)indexOfItem:(id)item;

@optional

@property (nonatomic, assign, readonly) id selectedItem;

- (void)insertItem:(id)item atIndex:(NSInteger)index;
- (void)insertItem:(id)item atIndex:(NSInteger)index animated:(BOOL)animated;
- (void)insertItems:(NSArray *)items atIndex:(NSInteger)index;
- (void)insertItems:(NSArray *)items atIndex:(NSInteger)index animated:(BOOL)animated;

- (void)deleteItem:(id)item;
- (void)deleteItem:(id)item animated:(BOOL)animated;
- (void)deleteItems:(NSArray *)items;
- (void)deleteItems:(NSArray *)items animated:(BOOL)animated;

- (void)selectItem:(id)item;
- (void)selectItem:(id)item animated:(BOOL)animated;

- (void)deselectItem:(id)item;
- (void)deselectItem:(id)item animated:(BOOL)animated;

- (void)reloadItem:(id)item;
- (void)reloadItem:(id)item animated:(BOOL)animated;
- (void)reloadItems:(NSArray *)items;
- (void)reloadItems:(NSArray *)items animated:(BOOL)animated;

- (void)reload;

@end

/**
 `VGContentDelegate` delegates callback for events.
 */
@protocol VGContentDelegate <NSObject>

@optional
- (void)content:(VGContent *)content didSelectItem:(id)item;
- (void)content:(VGContent *)content didDeselectItem:(id)item;

@end

/**
 `VGContent` is class that manages items and their behaviour.
 */
@interface VGContent :  NSObject <VGContentProtocol> {
    NSMutableArray *_items;
}

/**
 Array of items.
 */
@property (nonatomic, strong, readonly) NSArray *items;

/**
 UIView that represents model reuse identifier.
 */
@property (nonatomic, strong) NSString *cellIdentifier;

/**
 An object which responds to `VGContentDelegate`.
 */
@property (nonatomic, assign) id<VGContentDelegate> delegate;

#pragma mark - Lifecycle
/**
 General method to init VGContent.
 */
- (instancetype)initWithView:(UIView *)view;

#pragma mark - Setup methods
- (void)setup;

#pragma mark - Utils
- (NSArray *)indexPathsWithItems:(NSArray *)items;

@end
