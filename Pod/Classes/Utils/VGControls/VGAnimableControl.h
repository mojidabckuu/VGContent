//
//  VGAnimableControl.h
//  Pods
//
//  Created by Vlad Gorbenko on 2/24/16.
//
//

#import <Foundation/Foundation.h>

@protocol VGAnimableControl <NSObject>

@required
@property (nonatomic, assign, readonly) BOOL isAnimating;
@property(nonatomic,getter=isEnabled) BOOL enabled;

- (void)startAnimating;
- (void)stopAnimating;

@end
