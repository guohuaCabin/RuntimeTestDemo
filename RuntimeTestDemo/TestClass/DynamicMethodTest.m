//
//  DynamicMethodTest.m
//  RuntimeTestDemo
//
//  Created by guohua on 2021/3/10.
//

#import "DynamicMethodTest.h"
#import <objc/runtime.h>

void dynamicMethod() {
    NSLog(@">> 使用了动态方法解析");
}

@implementation DynamicMethodTest

//- (void)message {
//    NSLog(@" >> 调用了 %@ 类的 message方法",NSStringFromClass([self class]));
//}

//- (void)pushMessage {
//    NSLog(@" >> 调用了 %@ 类的 pushMessage方法",NSStringFromClass([self class]));
//}

- (void)replaceMessage {
    NSLog(@" >> 调用了 %@ 类的 replaceMessage方法",NSStringFromClass([self class]));
}

+ (void)replaceMessage2 {
    NSLog(@" >> 调用了 %@ 类的 replaceMessage2方法",NSStringFromClass([self class]));
}

- (void)replaceMessage3 {
    NSLog(@" >> 调用了 %@ 类的 replaceMessage3方法",NSStringFromClass([self class]));
}
//实例方法动态解析
//当message方法找不到的情况下会走该方法，可以在其中添加一个动态解析方法。使程序转发到另一个消息上。
+ (BOOL)resolveInstanceMethod:(SEL)sel {
    NSLog(@"======================================\n");
    NSLog(@">> %@调用了 %@ 类的动态方法解析:resolveInstanceMethod",NSStringFromSelector(sel),NSStringFromClass([self class]));
    
    if (sel == @selector(message)) {
        class_addMethod([self class], sel, (IMP)dynamicMethod, "v@:");
        return YES;
    }
    if (sel == @selector(pushMessage)) {
        //添加动态解析方法，
        class_addMethod([self class], sel, class_getMethodImplementation([self class], @selector(replaceMessage)), "v@:");
        return YES;
    }
    return [super resolveInstanceMethod:sel];
}
//类方法动态解析
+(BOOL)resolveClassMethod:(SEL)sel {
    NSLog(@" >> resolveClassMethod: %@", NSStringFromSelector(sel));
    if (sel == @selector(classMessage)) {
        Method aMethod = class_getClassMethod(self, NSSelectorFromString(@"replaceMessage2"));
        class_addMethod(object_getClass(self), sel, method_getImplementation(aMethod), "v@:");
        return YES;
    }
//    if (sel == @selector(replaceMessage)) {
//        class_addMethod([self class], sel, method_getImplementation(class_getClassMethod([self class], @selector(replaceMessage3))), "v@:");
//        return YES;
//    }
    
    return [super resolveClassMethod:sel];
}

@end
