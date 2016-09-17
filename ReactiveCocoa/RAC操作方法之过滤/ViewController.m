//
//  ViewController.m
//  RAC操作方法之过滤
//
//  Created by 周少文 on 16/9/7.
//  Copyright © 2016年 YiXi. All rights reserved.
//

#import "ViewController.h"
#import "ReactiveCocoa.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self filter];
//    [self ignore];
//    [self take];
//    [self takeLast];
//    [self takeUntil];
//    [self distinctUntilChanged];
    [self skip];
}

- (void)skip {
    // skip:跳跃几个值
    RACSubject *subject = [RACSubject subject];
    
    [[subject skip:2] subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
    
    [subject sendNext:@"a"];
    [subject sendNext:@"b"];
    [subject sendNext:@"c"];
}

- (void)distinctUntilChanged {
    // distinctUntilChanged:如果当前的值跟上一个值相同,就不会被订阅到
    RACSubject *subject = [RACSubject subject];
    
    [[subject distinctUntilChanged] subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
    
    [subject sendNext:@1];
    [subject sendNext:@1];
    [subject sendNext:@2];
}

- (void)takeUntil {
    // 创建信号
    RACSubject *subject = [RACSubject subject];
    
    RACSubject *signal = [RACSubject subject];
    
    // takeUntil:只要传入信号发送完成或者发送任意数据,就不能在接收源信号的内容
    [[subject takeUntil:signal] subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
    
    // 发送数据
    [subject sendNext:@"a"];
    [subject sendNext:@"b"];
    //发送完成
//    [signal sendCompleted];
    [signal sendNext:@1];
    //发送错误不可以
//    [signal sendError:nil];
    [subject sendNext:@"c"];

}

- (void)takeLast
{
    // 1.创建信号
    RACSubject *subject = [RACSubject subject];
    
    //2.过滤信号
    // takeLast:取后面多少个值.必须要发送完成
    RACSignal *takeSignal = [subject takeLast:1];
    
    // 3.订阅信号
    [takeSignal subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
    
    // 4.发送数据
    [subject sendNext:@"a"];
    [subject sendNext:@"b"];
    //发送完成
    [subject sendCompleted];
    [subject sendNext:@"c"];

}

- (void)take {
    // 1.创建信号
    RACSubject *subject = [RACSubject subject];
    
    //2.过滤信号
    //take:取前面几个值
    RACSignal *takeSignal = [subject take:2];
    
    // 3.订阅信号
    [takeSignal subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
    
    // 4.发送数据
    [subject sendNext:@"a"];
    [subject sendNext:@"b"];
    [subject sendNext:@"c"];
}

- (void)ignore {
    
    // ignore:忽略一些值
    // ignoreValues:忽略所有的值
    
    // 1.创建信号
    RACSubject *subject =[RACSubject subject];
    
    // 2.忽略一些
    RACSignal *ignoreSignal = [subject ignore:@"a"];
//    RACSignal *ignoreSignal = [subject ignoreValues];
    
    // 3.订阅信号
    [ignoreSignal subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
    
    // 4.发送数据
    [subject sendNext:@"a"];
    [subject sendNext:@"b"];
}

//filter:过滤信号，使用它可以获取满足条件的信号.
- (void)filter{
    // 只有当我们文本框的内容长度大于3,才想要获取文本框的内容
    [[_textField.rac_textSignal filter:^BOOL(NSString *value) {
        
        // value:源信号的内容
        return value.length > 3;
        // 返回值,就是过滤条件,只有满足这个条件,才能能获取到内容
        
    }] subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
}

















@end
