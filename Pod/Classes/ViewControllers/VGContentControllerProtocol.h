//
//  VGContentControllerProtocol.h
//  Pods
//
//  Created by Vlad Gorbenko on 06.07.15.
//
//

#import <Foundation/Foundation.h>

#import "VGURLContent.h"

@protocol VGContentControllerProtocol <NSObject, VGContentDelegate, VGURLContentDataDelegate>

@required
@property (nonatomic, weak) IBOutlet UIView *contentView;

@property (nonatomic, strong) VGURLContent *content;

@property (nonatomic, strong) IBInspectable NSString *contentName;
@property (nonatomic, strong) IBInspectable NSString *cellIdentifier;

- (void)contentAwakeFromNib;
- (BOOL)contentShouldRefresh;

@end
