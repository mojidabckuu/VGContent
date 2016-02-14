//
//  Swizzling.m
//  Pods
//
//  Created by Vlad Gorbenko on 2/14/16.
//
//

#import "Swizzling.h"

#import <objc/runtime.h>

void VGSwizzleMethodsFrom(Class onClass, SEL fromMethod, Class fromClass, SEL toMethod) {
    Method originalMethod = class_getInstanceMethod(onClass, fromMethod);
    Method swizzledMethod = class_getInstanceMethod(fromClass, toMethod);
    
    BOOL didAddMethod = class_addMethod(onClass, fromMethod, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        class_replaceMethod(onClass, toMethod, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}
