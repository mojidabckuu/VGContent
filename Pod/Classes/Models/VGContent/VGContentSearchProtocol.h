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
@property (nonatomic, strong) NSMutableArray *filteredItems;

/**
 Method to perform search on items.
 @result Result array will be putted to filtered items.
 */
- (void)searchWithString:(NSString *)string;
- (void)cancelSearch;

@end
