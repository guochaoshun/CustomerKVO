//
//  ViewController.m
//  测试
//
//  Created by gao on 2019/1/7.
//  Copyright © 2019年 gao. All rights reserved.
//

#import "ViewController.h"
#import "Person.h"
#import <objc/runtime.h>


@interface ViewController ()

@property (nonatomic,strong) Person * person ;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self addKVO:nil];

}
- (IBAction)nextVC:(id)sender {
    
    ViewController * vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ViewController"];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)addKVO:(id)sender {
    
    // isa的指针变了
    //    Person * p = [[Person alloc] init];
    //    p.name = @"123";
    //    NSLog(@"%p %@ ",object_getClass(p),p); // p->isa = Person
    //    [p addObserver:self forKeyPath:@"name" options:(NSKeyValueObservingOptionNew) context:nil];
    //    NSLog(@"%p %@ ",object_getClass(p),p); // p->isa = NSKVONotifying_Person
    //    p.name = @"123456";
    
    
    // 自己实现一个kvo玩玩 , 详见Person类
    self.person = [[Person alloc] init];
    self.person.name = @"123";
    NSLog(@"%p %@ ",object_getClass(self.person),self.person); // isa Person
    [self.person gcs_addObserver:self forKeyPath:@"name" options:(NSKeyValueObservingOptionNew) context:nil];
    NSLog(@"%p %@ ",object_getClass(self.person),self.person); // isa GCSKVO_Person
    
    self.person.name = @"123456";
    
    
}


// 系统的kvo回调方法 , 这个也可以自己写
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    NSLog(@"observeValueForKeyPath  --- %@ %@",object,change);
    
}


// 自己写的kvo回调
- (void)gcs_observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    NSLog(@"自己写的kvo回调 gcs_observeValueForKeyPath  --- %@ %@",object,change);
    
}


- (void)dealloc {
//    [self.person removeObserver:self forKeyPath:@"name"];
//    [self.person gcs_removeObserver:self forKeyPath:@"name"];
    NSLog(@"%@ dealloc",self);
}




@end
