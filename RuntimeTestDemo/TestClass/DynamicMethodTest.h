//
//  DynamicMethodTest.h
//  RuntimeTestDemo
//
//  Created by guohua on 2021/3/10.
//

#import "TestClass.h"

NS_ASSUME_NONNULL_BEGIN

@interface DynamicMethodTest : NSObject
//@interface DynamicMethodTest : TestClass
//实例方法
- (void)message;
- (void)pushMessage;
///类方法
+ (void)classMessage;

@end

NS_ASSUME_NONNULL_END
