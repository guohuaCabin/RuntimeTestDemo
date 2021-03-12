//
//  MessageForwardProcess.h
//  RuntimeTestDemo
//
//  Created by guohua on 2021/3/12.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MessageForwardProcess : NSObject

+ (void)pushMessage;

- (void)pushMessage;

- (void)runMessage;

@end

NS_ASSUME_NONNULL_END
