//
//  VGXibView.m
//  Pods
//
//  Created by vlad gorbenko on 10/28/15.
//
//

#import "VGXibView.h"

@implementation VGXibView

- (NSString*)xibName {
    NSString *className = NSStringFromClass([self class]);
    return className;
}

- (id)loadFromXib {
    return [self loadFromXibWithName:[self xibName] numberInXib:0];
}

- (id)loadFromXibWithName:(NSString *)xibName numberInXib:(NSInteger)number {
    NSArray *arr = [[NSBundle mainBundle] loadNibNamed:xibName owner:self options:nil];
    if([arr count] > number) {
        return arr[number];
    }
    return nil;
}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self){
        [self commonInit];
    }
    return self;
}

- (void)commonInit{
    self.contentView = [self loadFromXib];
    if(!CGRectIsEmpty(self.frame)){
        self.contentView.frame = self.bounds;
    }else{
        self.frame = self.contentView.frame;
    }
    self.contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self addSubview:self.contentView];
}

@end
