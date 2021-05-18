//
//  TestClass.h
//  RuntimeTestDemo
//
//  Created by guohua on 2021/3/10.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol TestClassDelegate <NSObject>

- (void)testRun;

- (void)testStack;

@end
NS_ASSUME_NONNULL_BEGIN

@interface TestClass : NSObject

@property(nonatomic,strong)NSArray *array;
@property (nonatomic,copy)NSString *name;

@property (nonatomic,assign) NSInteger age;

@property (nonatomic,weak) id <TestClassDelegate> deleagte;


- (void)message;

- (void)pushMessage:(NSString *)msg;

+ (void)transfer;

- (void)instanceMethod;
+ (void)classMethod;

- (void)test;

- (NSMutableArray*)getPropertiesWithClass:(Class)cls;

- (NSMutableArray*)getIvarsWithClass:(Class)cls;

@end

NS_ASSUME_NONNULL_END
