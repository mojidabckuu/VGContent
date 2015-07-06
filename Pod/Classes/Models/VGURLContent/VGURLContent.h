//
//  VGURLContent.h
//  VGContent
//
//  Created by Vlad Gorbenko on 05.07.15.
//  Copyright (c) 2015 Vlad Gorbenko. All rights reserved.
//

#import "VGContent.h"

@class VGURLContent;

@protocol VGURLContentDataDelegate <NSObject>

@optional

@optional
- (void)content:(VGURLContent *)content didFinishLoadingWithItems:(NSArray *)items;
- (void)content:(VGURLContent *)content didFailLoadingItemsWithError:(NSError *)error;
- (void)contentWillLoaded:(VGURLContent *)content;

@end

@interface VGURLContent : VGContent {
    BOOL _isRefreshing;
    BOOL _isLoading;
    BOOL _isAllLoaded;
}

@property (nonatomic, assign) id<VGURLContentDataDelegate> dataDelegate;

@property (nonatomic, assign) BOOL showLoading;
@property (nonatomic, assign, readonly, getter=loading) BOOL isLoading;
@property (nonatomic, assign, readonly) BOOL isRefreshing;
@property (nonatomic, assign) BOOL isAllLoaded;

@property (nonatomic, assign, readonly) NSInteger offset;

#pragma mark - VGURLContent management
- (void)loadItems;
- (void)refresh;
- (void)loadMoreItems;
- (void)cancel;
- (void)reload;

#pragma mark - URL fetching management
- (void)fetchLoadedItems:(NSArray *)items;
- (void)fetchLoadedItems:(NSArray *)items pageSize:(NSInteger)pageSize;

#pragma mark - Notifiers
- (void)notifyWithError:(NSError *)error;
- (void)notifyDidLoadedWithItems:(NSArray *)items;
- (void)notifyWillLoaded;

@end
