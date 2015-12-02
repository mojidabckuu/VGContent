//
//  VGContent.h
//  VGContent
//
//  Created by Vlad Gorbenko on 5/6/15.
//  Copyright (c) 2015 Vlad Gorbenko. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "VGContentProtocol.h"
#import "VGContentSearchProtocol.h"

@class VGContent;

/**
 `VGContentDelegate` delegates callback for events.
 */
@protocol VGContentDelegate <NSObject>

@optional
/**
 Delegate method that triggered when item selected.
 */
- (void)content:(VGContent *)content didSelectItem:(id)item;

/**
 Delegate method that triggered when item deselected.
 */
- (void)content:(VGContent *)content didDeselectItem:(id)item;

/**
 Delegate method that triggered when item added.
 */
- (void)content:(VGContent *)content addItem:(id)item;
- (void)content:(VGContent *)content didAddItem:(id)item;

/**
 Delegate method that triggered when item deleted.
 */
- (void)content:(VGContent *)content deleteItem:(id)item;
- (void)content:(VGContent *)content didDeleteItem:(id)item;

@end

/**
 `VGContent` is class that manages items and their behaviour.
 */
@interface VGContent :  NSObject <VGContentProtocol, VGContentSearchProtocol> {
    NSMutableArray *_items;
}

/**
 Reference to view.
 */
@property (nonatomic, weak) UIView *view;

/**
 Reference to controller.
 */
@property (nonatomic, weak) UIViewController *viewController;

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
@property (nonatomic, weak) id<VGContentDelegate> delegate;

#pragma mark - Lifecycle
/**
 General method to init VGContent.
 */
- (instancetype)initWithView:(UIView *)view;

/**
 General method to init VGContent.
 */
- (instancetype)initWithView:(UIView *)view controller:(UIViewController *)controller;

#pragma mark - Setup methods
/**
 Setup method for additional customization of content.
 */
- (void)setup;

#pragma mark - Utils
/**
 Utils method
 @return `NSArray` of `NSIndexPath` objects which corresponding to items indexes.
 */
- (NSArray *)indexPathsWithItems:(NSArray *)items;

/**
 Register cells.
 */
- (BOOL)registerCellIdentifier:(NSString *)cellIdentifier;

@end
