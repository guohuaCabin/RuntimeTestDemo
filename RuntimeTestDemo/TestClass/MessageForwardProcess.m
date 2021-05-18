//
//  MessageForwardProcess.m
//  RuntimeTestDemo
//
//  Created by guohua on 2021/3/12.
//

#import "MessageForwardProcess.h"

@implementation MessageForwardProcess

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
//    if (aSelector == NSSelectorFromString(@"runMessage")) {
//        return [NSMethodSignature signatureWithObjCTypes:"v@:"];
//    }
//    return [super methodSignatureForSelector:aSelector];
    return [NSMethodSignature signatureWithObjCTypes:"v@::"];
}

-(void)forwardInvocation:(NSInvocation *)anInvocation {
    NSLog(@"没找到方法实现，也没有做任何处理🙍");
    
}

- (void)pushMessage {
    NSLog(@"执行了pushMessage方法");
}

@end
