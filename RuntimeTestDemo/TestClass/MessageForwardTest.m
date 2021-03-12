//
//  MessageForwardTest.m
//  RuntimeTestDemo
//
//  Created by guohua on 2021/3/10.
//

#import "MessageForwardTest.h"
#import "TestClass.h"
#import "DynamicMethodTest.h"
@implementation MessageForwardTest


- (id)forwardingTargetForSelector:(SEL)aSelector {
    NSLog(@"在%@类中调用%@方法执行了消息转发",NSStringFromClass([self class]),NSStringFromSelector(aSelector));
    if (aSelector == @selector(message)) {
        return [[TestClass alloc]init];
    }
    if (aSelector == @selector(pushMessage)) {
        return [[DynamicMethodTest alloc]init];
    }
    return [super forwardingTargetForSelector:aSelector];
}

+ (void)transfer {
    NSLog(@"中转消息");
}

@end
