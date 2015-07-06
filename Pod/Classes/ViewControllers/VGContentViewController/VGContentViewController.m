//
//  VGContentViewController.m
//  VGContent
//
//  Created by Vlad Gorbenko on 06.07.15.
//
//

#import "VGContentViewController.h"

@implementation VGContentViewController

@dynamic cellIdentifier;
@dynamic content;
@dynamic contentName;
@dynamic contentView;

#pragma mark - VGContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupContent];
}

#pragma mark - Setup methods

- (void)setupContent {
    if(self.contentName) {
        if(self.cellIdentifier) {
            Class class = NSClassFromString(self.contentName);
            NSAssert(class, @"Content class is not exists %@", self.
                     contentName);
            self.content = [[class alloc] initWithView:self.contentView];
            self.content.cellIdentifier = self.cellIdentifier;
            self.content.delegate = self;
            self.content.dataDelegate = self;
            [self.content refresh];
        }
    }
}

@end
