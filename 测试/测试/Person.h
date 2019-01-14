//
//  Person.h
//  测试
//
//  Created by gao on 2019/1/14.
//  Copyright © 2019年 gao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Person : NSObject

@property (nonatomic,copy) NSString * name ;


- (void)gcs_addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(nullable void *)context;

- (void)gcs_removeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath;


@end

NS_ASSUME_NONNULL_END
