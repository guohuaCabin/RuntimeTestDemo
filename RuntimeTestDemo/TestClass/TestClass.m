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


- (void)instanceMethod {
    NSLog(@"%@类的实例方法",NSStringFromClass([self class]));
}
+ (void)classMethod {
    NSLog(@"%@类的类方法",NSStringFromClass(self));
}


- (NSMutableArray*)getPropertiesWithClass:(Class)cls{
    
    unsigned int count;// 记录属性个数
    objc_property_t *properties = class_copyPropertyList(cls, &count);
    // 遍历
    NSMutableArray *mArray = [NSMutableArray array];
    for (int i = 0; i < count; i++) {
    // objc_property_t 属性类型
    objc_property_t property = properties[i];
    // 获取属性的名称 C语言字符串
    const char *cName = property_getName(property);
    // 转换为Objective C 字符串
    NSString *name = [NSString stringWithCString:cName encoding:NSUTF8StringEncoding];
    [mArray addObject:name];
    }
    return mArray.copy;
}

- (NSMutableArray*)getIvarsWithClass:(Class)cls{
    
    unsigned int count;// 记录属性个数
    Ivar *ivars = class_copyIvarList(cls, &count);
    // 遍历
    NSMutableArray *mArray = [NSMutableArray array];
    for (int i = 0; i < count; i++) {
    // objc_property_t 属性类型
    Ivar ivar = ivars[i];
    // 获取属性的名称 C语言字符串
    const char *cName = ivar_getName(ivar);
    // 转换为Objective C 字符串
    NSString *name = [NSString stringWithCString:cName encoding:NSUTF8StringEncoding];
    [mArray addObject:name];
    }
    return mArray.copy;
}

@end
