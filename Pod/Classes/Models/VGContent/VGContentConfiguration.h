//
//  VGContentConfiguration.h
//  Pods
//
//  Created by Vlad Gorbenko on 2/24/16.
//
//

#import <Foundation/Foundation.h>

extern NSString *const VGRefreshControlTintColor;
extern NSString *const VGInfiniteControlTintColor;

@interface VGContentConfiguration : NSObject

@property (nonatomic, strong) NSDictionary *contentDefaults;

+ (instancetype)sharedInstance;

@end
