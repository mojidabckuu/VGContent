//
//  VGContentViewController.h
//  VGContent
//
//  Created by Vlad Gorbenko on 06.07.15.
//
//

#import <UIKit/UIKit.h>

#import "VGURLContent.h"

@interface VGContentViewController : UIViewController <VGContentDelegate, VGURLContentDataDelegate>

@property (nonatomic, weak) IBOutlet UIView *contentView;

@property (nonatomic, strong) VGURLContent *content;

@property (nonatomic, strong) IBInspectable NSString *contentName;
@property (nonatomic, strong) IBInspectable NSString *cellIdentifier;

@end
