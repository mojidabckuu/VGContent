//
//  VGCarouselContentView.m
//  VGContent
//
//  Created by Vlad Gorbenko on 5/12/15.
//  Copyright (c) 2015 Vlad Gorbenko. All rights reserved.
//

#import "VGCarouselContentView.h"

@implementation VGCarouselContentView

#pragma mark - Layout

- (void)layoutSubviews {
    [super layoutSubviews];
    self.contentView.frame = self.bounds;
}

#pragma mark - Mutators

- (void)setContentView:(UIView *)contentView {
    _contentView = contentView;
    [self addSubview:_contentView];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
