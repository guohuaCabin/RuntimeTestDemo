//
//  SubTestClass.m
//  RuntimeTestDemo
//
//  Created by guohua on 2021/3/22.
//

#import "SubTestClass.h"

@implementation SubTestClass

- (void)instanceMethod {
    [super instanceMethod];
    
    NSLog(@"%@重写了父类的实例方法",NSStringFromClass([self class]));
}

+ (void) classMethod{
    [super classMethod];
    NSLog(@"%@重写了父类的类方法",NSStringFromClass([self class]));
}

@end
