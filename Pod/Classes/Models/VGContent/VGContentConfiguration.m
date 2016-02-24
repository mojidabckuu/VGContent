//
//  VGContentConfiguration.m
//  Pods
//
//  Created by Vlad Gorbenko on 2/24/16.
//
//

#import "VGContentConfiguration.h"

NSString *const VGRefreshControlTintColor = @"VGRefreshControlTintColor";
NSString *const VGInfiniteControlTintColor = @"VGInfiniteControlTintColor";

@implementation VGContentConfiguration

#pragma mark - Singleton

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static id sharedInstance = nil;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

#pragma mark - Lifecycle

- (instancetype)init {
    self = [super init];
    if(self) {
        [self setup];
    }
    return self;
}

#pragma mark - Setup

- (void)setup {
    _contentDefaults = @{};
}

@end
