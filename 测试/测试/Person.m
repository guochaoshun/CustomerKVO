//
//  Person.m
//  测试
//
//  Created by gao on 2019/1/14.
//  Copyright © 2019年 gao. All rights reserved.
//

#import "Person.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import "NSObject+Selector.h"

@implementation Person

- (void)setName:(NSString *)name {

    NSLog(@"%@ %@",self,NSStringFromSelector(_cmd));
    _name = name;
}

- (void)gcs_addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(nullable void *)context {
    
    // 生成一个新子类 , 替换isa 的指向
    NSString * newClassName = [NSString stringWithFormat:@"GCSKVO_%@",NSStringFromClass([self class])];
    Class subClass = objc_allocateClassPair([self class], [newClassName UTF8String], 0);
    // 说明已经生成过了
    if (subClass != nil) {
        objc_registerClassPair(subClass);
        object_setClass(self, subClass);
    } else {
        object_setClass(self, NSClassFromString(newClassName));
    }
    
    // 保存观察者
    objc_setAssociatedObject(self, @"observer_name", observer, OBJC_ASSOCIATION_ASSIGN) ;
    
    // 重写新子类的set方法
    NSString * selectorName = [NSString stringWithFormat:@"set%@:",keyPath.capitalizedString];
    class_addMethod(subClass, NSSelectorFromString(selectorName), (IMP)setNewValue, "v@:@");
    // 其实系统还重写了很多方法,比如 [self class] , 
    
}

void setNewValue(id self , SEL _cmd , id newValue) {
    
    struct objc_super superClass = {
        self,
        class_getSuperclass([self class])
    };
    NSLog(@"调用了父类的方法");
    objc_msgSendSuper(&superClass,_cmd,newValue);

    
    NSString * key = NSStringFromSelector(_cmd);
    key = [key substringWithRange:NSMakeRange(3, key.length-4)].lowercaseString;
    
    id observer = objc_getAssociatedObject(self, @"observer_name");
    // 还可以自定义回调方法
    [observer gcs_observeValueForKeyPath:key ofObject:observer change:@{@"GCS_newValue":newValue,@"hhh":@"you can do anything"} context:@""];
    
    NSLog(@"已经通知了观察者值改变了");
}


- (void)gcs_removeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath {

    // 去除观察者
    objc_setAssociatedObject(self, @"observer_name", nil, OBJC_ASSOCIATION_ASSIGN) ;

}


@end
