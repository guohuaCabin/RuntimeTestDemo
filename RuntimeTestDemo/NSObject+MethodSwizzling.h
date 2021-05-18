//
//  NSObject+MethodSwizzling.h
//  RuntimeTestDemo
//
//  Created by guohua on 2021/5/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (MethodSwizzling)

// 交换两个类方法的实现
+ (void)class_swizzlingMethod:(SEL)originalSelector method:(SEL)swizzledSelector class:(Class)targetClass;
// 交换两个对象方法的实现
+ (void)instance_swizzlingMethod:(SEL)originalSelector method:(SEL)swizzledSelector class:(Class)targetClass;

@end

NS_ASSUME_NONNULL_END
