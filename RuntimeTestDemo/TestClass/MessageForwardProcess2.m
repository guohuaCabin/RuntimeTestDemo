//
//  MessageForwardProcess2.m
//  RuntimeTestDemo
//
//  Created by guohua on 2021/3/12.
//

#import "MessageForwardProcess2.h"
#import "TestClass.h"
#import "MessageForwardTest.h"
@implementation MessageForwardProcess2

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    return [NSMethodSignature signatureWithObjCTypes:"v@:"];
}

-(void)forwardInvocation:(NSInvocation *)anInvocation {
    //转发：
    [TestClass transfer];
    [MessageForwardTest transfer];
    
}

- (void)pushMessage {
    NSLog(@"执行了pushMessage方法");
}


@end
