//
//  Swizzling.h
//  Pods
//
//  Created by Vlad Gorbenko on 2/14/16.
//
//

#import <UIKit/UIKit.h>

void VGSwizzleMethodsFrom(Class onClass, SEL fromMethod, Class fromClass, SEL toMethod);