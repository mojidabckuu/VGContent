//
//  VGXibView.m
//  Pods
//
//  Created by vlad gorbenko on 10/28/15.
//
//

#import "VGXibView.h"

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

@interface EPPZViewInstantiator : NSObject
@property (nonatomic, strong) IBOutlet UIView *view;
+(id)viewFromNibNamed:(NSString*) nibName;
@property (nonatomic, strong) NSMutableDictionary *values;
@end

@implementation EPPZViewInstantiator

- (instancetype)init {
    self = [super init];
    if(self) {
        self.values = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (NSString *)capFirst:(NSString *)string {
    NSRange range = NSMakeRange(0, 1);
    NSString *letter = [string substringWithRange:range];
    return [string stringByReplacingCharactersInRange:range withString:[letter capitalizedString]];
}

- (void)bindValues {
    for(NSString *key in self.values) {
        NSString *selectorString = [NSString stringWithFormat:@"set%@:", [self capFirst:key]];
        SEL selector = NSSelectorFromString(selectorString);
        if([self.view respondsToSelector:selector]) {
            [self.view performSelector:selector withObject:self.values[key]];
        }
    }
}

+(id)viewFromNibNamed:(NSString*) nibName
{
    EPPZViewInstantiator *instantiator = [self new];
    instantiator.view = [[[NSBundle mainBundle] loadNibNamed:nibName owner:instantiator options:nil] lastObject];
    [instantiator bindValues];
    return instantiator.view;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    [self.values setObject:value forKey:key];
}

@end

@implementation VGXibView

+ (instancetype)loadFromNibNamed:(NSString*)nibName {
    return [EPPZViewInstantiator viewFromNibNamed:nibName];
}

+ (instancetype)loadFromNib {
    return [self loadFromNibNamed:[self xibName]];
}

// Swift realisation NSStringFromClass() returns module name separated by '.'
+ (NSString*)xibName {
    NSString *className = NSStringFromClass([self class]);
    return [[className componentsSeparatedByString:@"."] lastObject];
}

@end
