//
//  TestClass.m
//  RuntimeTestDemo
//
//  Created by guohua on 2021/3/10.
//

#import "TestClass.h"
#import <objc/runtime.h>

@interface TestClass()

@property (nonatomic, assign) CGFloat score;

@end

@implementation TestClass

- (void)message {
    NSLog(@"在TestClass类中执行了message方法");
}

- (void)pushMessage:(NSString *)msg {
    NSLog(@">> 在%@类中未找到实现方法，中转到了TestClass类中执行了pushMessage:方法，并传递了:%@",NSStringFromClass([self class]),msg);
}

+ (void)transfer {
    NSLog(@"中转消息");
}

@end
