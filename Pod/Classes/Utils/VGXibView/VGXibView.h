//
//  VGXibView.h
//  Pods
//
//  Created by vlad gorbenko on 10/28/15.
//
//

#import <UIKit/UIKit.h>

@interface VGXibView : UIView

+ (instancetype)loadFromNib;
+ (instancetype)loadFromNibNamed:(NSString*)nibName;

@end
