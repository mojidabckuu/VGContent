//
//  VGContentSearchProtocol.h
//  Pods
//
//  Created by vlad gorbenko on 8/2/15.
//
//

#import <Foundation/Foundation.h>

@protocol VGContentSearchProtocol <NSObject>

/**
 `NSArray` of original items.
 */
@property (nonatomic, strong) NSMutableArray *originalItems;

/**
 `NSArray` of fildeted items.
 */
@property (nonatomic, strong) NSArray *filteredItems;

/**
 Method to perform search on items.
 @result Result array will be putted to filtered items.
 */
- (void)searchWithString:(NSString *)string;

/**
 Method to perform search on items using keyPath on item.
 @param string Search text.
 @param keyPath Path to property of item.
 */
- (void)searchWithString:(NSString *)string keyPath:(NSString *)keyPath;

/**
 Method to cancel search and remove cached items.
 @property items will point to original array of items.
 */
- (void)cancelSearch;

@end
