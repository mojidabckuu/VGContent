//
//  VGContentProtocol.h
//  Pods
//
//  Created by vlad gorbenko on 8/2/15.
//
//

#import <Foundation/Foundation.h>

/**
 `VGContentProtocol` protocol that describes basic functionality for items.
 */
@protocol VGContentProtocol <NSObject>

@required
/**
 Accessor method for items.
 Fill _items array and reload corresponding view.
 */
- (void)setItems:(NSArray *)items;

/**
 Accessor method to obtain item by index.
 @param index Index of item.
 @return item Item by index.
 */
- (id)itemAtIndex:(NSInteger)index;

/**
 Accessor method to obtrain index by item.
 @param item Item to obtain index.
 @return index Index of item.
 */
- (NSInteger)indexOfItem:(id)item;

@optional

@property (nonatomic, assign, readonly) id selectedItem;
@property (nonatomic, assign, readonly) id selectedItems;

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
- (void)selectItem:(id)item animated:(BOOL)animated delegate:(BOOL)delegate;
- (void)selectItems:(NSArray *)items;
- (void)selectItems:(NSArray *)items animated:(BOOL)animated;
- (void)selectItems:(NSArray *)items animated:(BOOL)animated delegate:(BOOL)delegate;

- (void)deselectItem:(id)item;
- (void)deselectItem:(id)item animated:(BOOL)animated;

- (void)reloadItem:(id)item;
- (void)reloadItem:(id)item animated:(BOOL)animated;
- (void)reloadItems:(NSArray *)items;
- (void)reloadItems:(NSArray *)items animated:(BOOL)animated;

- (void)reload;

@end
