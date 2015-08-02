//
//  VGContentTableViewController.m
//  Pods
//
//  Created by Vlad Gorbenko on 06.07.15.
//
//

#import "VGContentTableViewController.h"

@implementation VGContentTableViewController

#pragma mark - VGContentTableViewController lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self contentAwakeFromNib];
    self.content.delegate = self;
    self.content.dataDelegate = self;
    
    BOOL shouldRefresh = [self contentShouldRefresh];
    if(shouldRefresh) {
        [self.content refresh];
    }
}

#pragma mark - Setup methods

#pragma mark - Setup methods

- (void)contentAwakeFromNib {
    if(self.contentName) {
        Class class = NSClassFromString(self.contentName);
        NSAssert(class, @"Content class is not exists %@", self.
                 contentName);
        self.content = [[class alloc] initWithView:self.contentView];
        if(self.cellIdentifier) {
            self.content.cellIdentifier = self.cellIdentifier;
        }
    }
}

- (BOOL)contentShouldRefresh {
    return YES;
}

@end
