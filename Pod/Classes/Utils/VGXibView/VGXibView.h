//
//  VGXibView.h
//  Pods
//
//  Created by vlad gorbenko on 10/28/15.
//
//

#import <UIKit/UIKit.h>

@interface VGXibView : UIView

@property (strong, nonatomic) UIView *contentView;

- (NSString*)xibName;
- (id)loadFromXib;
- (id)loadFromXibWithName:(NSString *)xibName numberInXib:(NSInteger)number;

@end
