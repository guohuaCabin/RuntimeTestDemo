//
//  TestClass.m
//  RuntimeTestDemo
//
//  Created by guohua on 2021/3/10.
//

#import "TestClass.h"
#import <objc/runtime.h>


@implementation TestClass

- (void)message {
    NSLog(@"在TestClass类中执行了message方法");
}

@end
