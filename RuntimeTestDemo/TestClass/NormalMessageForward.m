//
//  NormalMessageForward.m
//  RuntimeTestDemo
//
//  Created by guohua on 2021/3/12.
//

#import "NormalMessageForward.h"
#import "TestClass.h"
@implementation NormalMessageForward
//NSInvaocation是命令模式的一种传统实现，它把一个目标、选择器、方法签名(NSMethodSignature)和所有参数都塞进一个对象里，这个对象可以先存储起来，以备将来调用。当NSInvocation被调用时，它会发送消息，Objective-C运行时会找到正确的方法实现来执行。
-(NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    if (aSelector == NSSelectorFromString(@"message")) {
        return [NSMethodSignature signatureWithObjCTypes:"v@:"];
    }
    if (aSelector == NSSelectorFromString(@"pushMessage")) {
        return [NSMethodSignature signatureWithObjCTypes:"v@::"];
    }
    return [super methodSignatureForSelector:aSelector];
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    if (anInvocation.selector == NSSelectorFromString(@"message")) {
        TestClass *test = [TestClass new];
        if ([test respondsToSelector:anInvocation.selector]) {
            [anInvocation invokeWithTarget:test];
        }
    }
    
    if (anInvocation.selector == NSSelectorFromString(@"pushMessage")) {
        TestClass *test = [TestClass new];
        NSString *msg = @"未找到实现方法，通过forwardInvocation进行转发";
        //下标从2开始，0：target， 1： selector
        [anInvocation setArgument:&msg atIndex:2];
        [anInvocation setSelector:@selector(pushMessage:)];
        
        [anInvocation invokeWithTarget:test];
    }
}


@end
