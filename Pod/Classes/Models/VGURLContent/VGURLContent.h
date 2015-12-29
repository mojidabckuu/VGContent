//
//  VGURLContent.h
//  VGContent
//
//  Created by Vlad Gorbenko on 05.07.15.
//  Copyright (c) 2015 Vlad Gorbenko. All rights reserved.
//

#import "VGContent.h"

extern NSString *const VGAnimatedRefresh;
extern NSString *const VGReloadOnRefresh;

@class VGURLContent;

/**
 `VGURLContentDataDelegate` is protocol that defines behaviour of URL fetching.
 */
@protocol VGURLContentDataDelegate <NSObject>

@optional
/**
 Delegate method that will be called at end of fetching data.
 @param content Reference to content.
 @param items Array of fetched items.
 */
- (void)content:(VGURLContent *)content didFinishLoadingWithItems:(NSArray *)items;

/**
 Delegate method that will be called at end of fetching data if error occured.
 @param content Reference to content.
 @param error Error that occured.
 */
- (void)content:(VGURLContent *)content didFailLoadingWithError:(NSError *)error;

/**
 Delegate method that will be called when content starts loading process.
 @param content Reference to content.
 */
- (void)contentWillLoadItems:(VGURLContent *)content;

@end

/**
 `VGURLContent` gives flexible managing of your data with high level of abstraction.
 Inherited from `VGContent` class.
 */

@interface VGURLContent : VGContent

/**
 List of criterias
 */
@property (nonatomic, strong) NSArray *criterias;

/**
 An object who responds to data delegate methods `VGURLContentDelegate`.
 */
@property (nonatomic, assign) id<VGURLContentDataDelegate> dataDelegate;

/**
 Indicator shows that content is loading data.
 */
@property (nonatomic, assign, readonly, getter=loading) BOOL isLoading;

/**
 Indicator shows that content refreshing data.
 End of refresh process and fetch will remove all previous data.
 */
@property (nonatomic, assign, readonly) BOOL isRefreshing;

/**
 Indicator shows that content did load all the data.
 */
@property (nonatomic, assign) BOOL isAllLoaded;

/**
 Current content offset.
 */
@property (nonatomic, strong) id offset;

/**
 Length helper. Default is 20
 */
@property (nonatomic, strong) NSNumber *length;

/**
 Content settings.
 */
@property (nonatomic, strong) NSDictionary *settings;

///---------------------
/// @name Loading management
///---------------------

#pragma mark - VGURLContent management
/**
 Method that start refresh process.
 Raise notification that will load items.
 Call `loadItems`.
 */
- (void)refresh;

/**
 Method that start load more items process.
 Raise notification that will load items.
 Call `loadItems`
 */
- (void)loadMoreItems;

/**
 Maethod that defines behaviour of loading items.
 @warning Abstract method must be overriden.
 */
- (void)loadItems;

/**
 Cancel loading.
 */
- (void)cancel;

///---------------------
/// @name Fetching management
///---------------------

#pragma mark - URL fetching management
/**
 Method to fetch new items. 
 In case of refreshing remove all old items.
 In case of loading append new items to the end.
 @param items Array of items.
 @param error Error
 */
- (void)fetchLoadedItems:(NSArray *)items error:(NSError *)error;

/**
 Method to fetch new items.
 In case of refreshing remove all old items.
 In case of loading append new items to the end.
 @param items Array of items.
 @param pageSize Number of expected items. If pageSize > items.count then all items are loaded.
 @param error Error
 */
- (void)fetchLoadedItems:(NSArray *)items pageSize:(NSInteger)pageSize error:(NSError *)error;

@end
