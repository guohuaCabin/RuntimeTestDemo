//
//  DoesNotRecognizeSelector.m
//  RuntimeTestDemo
//
//  Created by guohua on 2021/3/13.
//

#import "DoesNotRecognizeSelector.h"

@implementation DoesNotRecognizeSelector

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    return [NSMethodSignature signatureWithObjCTypes:"v@:"];
}

- (void)doesNotRecognizeSelector:(SEL)aSelector {
    NSLog(@"找不到方法");
}

@end
