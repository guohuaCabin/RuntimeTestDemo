//
//  NSObject+DynamicAnalysis.m
//  RuntimeTestDemo
//
//  Created by guohua on 2021/5/18.
//

#import "NSObject+DynamicAnalysis.h"
#import "NSObject+MethodSwizzling.h"
#import <objc/runtime.h>
@implementation NSObject (DynamicAnalysis)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [NSObject instance_swizzlingMethod:@selector(forwardingTargetForSelector:) method:@selector(gh_forwardingTargetForSelector:) class:[NSObject class]];
        [NSObject class_swizzlingMethod:@selector(forwardingTargetForSelector:) method:@selector(gh_forwardingTargetForSelector:) class:[NSObject class]];
    });
}

- (id)gh_forwardingTargetForSelector:(SEL)aSelector {
    if ([self sameInstanceForwardingMethod]) {
        if ([self sameInstanceMethodSignature]) {
            
            [self pushErrorClassLogWithSelector:aSelector];
            
            return [self dynamicRegisterClassWithSelector:aSelector];
        }
    }
    return [self gh_forwardingTargetForSelector:aSelector];
}

+ (id)gh_forwardingTargetForSelector:(SEL)aSelector {
    if ([self sameClassForwardingMethod]) {
        if ([self sameClassMethodSignature]) {
            
            [self pushErrorClassLogWithSelector:aSelector];
            return [self dynamicRegisterClassWithSelector:aSelector];
        }
    }
    return [self gh_forwardingTargetForSelector:aSelector];
}

// 统一处理实例方法 和 类方法未实现的入口
static NSString* CrashHandle(id slf, SEL selector) {
    return @"未找到实现方法，这里做最后的统一处理";
}
//打印发生错误的类 和 方法
- (void)pushErrorClassLogWithSelector:(SEL)aSelector {
    NSString *errorClassName = NSStringFromClass([self class]);
    NSString *errorSel = NSStringFromSelector(aSelector);
    NSLog(@"%@该类发生错误，出问题的调用方法是：%@", errorClassName, errorSel);
}
//动态添加类和方法
- (Class)dynamicRegisterClassWithSelector:(SEL)aSelector {
    NSString *className = @"CrachClass";
    Class class = NSClassFromString(className);
    if (!class) {
        Class superClass = [NSObject class];
        //初始化
        class = objc_allocateClassPair(superClass, className.UTF8String, 0);
        //注册
        objc_registerClassPair(class);
    }
    
    if (!class_getInstanceMethod(class, aSelector)) {
        class_addMethod(class, aSelector, (IMP)CrashHandle, "@@:@");
    }
    return [[class alloc]init];
}

//当前类的 实例方法的备用接受者 和 根类的 实例方法的备用接收者 是不是同一个
- (BOOL)sameInstanceForwardingMethod {
    SEL forwarding_sel = @selector(forwardingTargetForSelector:);
    Method root_forwardingMethod  = class_getInstanceMethod([NSObject class], forwarding_sel);
    Method cur_forwardingMethod = class_getInstanceMethod([self class], forwarding_sel);
    
    return (method_getImplementation(root_forwardingMethod) == method_getImplementation(cur_forwardingMethod));
}
//当前类的类方法备用接受者 和 根类的类方法备用接收者 是不是同一个
- (BOOL)sameClassForwardingMethod {
    SEL forwarding_sel = @selector(forwardingTargetForSelector:);
    Method root_forwardingMethod  = class_getClassMethod([NSObject class], forwarding_sel);
    Method cur_forwardingMethod = class_getClassMethod([self class], forwarding_sel);
    
    return (method_getImplementation(root_forwardingMethod) == method_getImplementation(cur_forwardingMethod));
}
//当前类的 实例方法的方法签名 和 根类的 实例方法的方法签名 是不是同一个

- (BOOL)sameInstanceMethodSignature {
    SEL methodSignature_sel = @selector(methodSignatureForSelector:);
    Method root_methodSignature = class_getInstanceMethod([NSObject class], methodSignature_sel);
    Method cur_methodSignature = class_getInstanceMethod([self class], methodSignature_sel);
    return (method_getImplementation(root_methodSignature) == method_getImplementation(cur_methodSignature));
}

//当前类的类方法方法签名 和 根类的类方法方法签名 是不是同一个
- (BOOL)sameClassMethodSignature {
    SEL methodSignature_sel = @selector(methodSignatureForSelector:);
    Method root_methodSignature = class_getClassMethod([NSObject class], methodSignature_sel);
    Method cur_methodSignature = class_getClassMethod([self class], methodSignature_sel);
    return (method_getImplementation(root_methodSignature) == method_getImplementation(cur_methodSignature));
}

@end
