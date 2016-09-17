//
//  ViewController.m
//  RAC操作方法之组合
//
//  Created by 周少文 on 16/9/6.
//  Copyright © 2016年 YiXi. All rights reserved.
//

#import "ViewController.h"
#import "ReactiveCocoa.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *accountTextField;
@property (weak, nonatomic) IBOutlet UITextField *pswTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self concat];
//    [self then];
//    [self merge];
//    [self zip];
    [self combineLatest];
    
}

- (void)combineLatest{
    
    // 组合
    // 组合哪些信号
    // reduce:聚合
    
    // reduceBlock参数:根组合的信号有关,一一对应

    //(id<NSFastEnumeration>),只要看到某个对象要遵循NSFastEnumeration协议,那么直接就填数组,因为NSArray就遵循这个协议
    NSArray *signals = @[_accountTextField.rac_textSignal,_pswTextField.rac_textSignal];
    RACSignal *combineSignal =  [[RACSignal combineLatest:signals] reduceEach:^id(NSString *account,NSString *psw){
        
        // block:只要源信号发送内容就会调用,组合成新一个值
        NSLog(@"%@---%@",account,psw);
        
        // 聚合的值就是组合信号的内容
        return @(account.length && psw.length);
    }];
    
    // 订阅组合信号
//    [combineSignal subscribeNext:^(id x) {
//        
//        _loginBtn.enabled = [x boolValue];
//    }];
    
    //快速写法
    RAC(_loginBtn,enabled) = combineSignal;
}

//zipWith:把两个信号压缩成一个信号，只有当两个信号同时发出信号内容时，并且把两个信号的内容合并成一个元组，才会触发压缩流的next事件。
- (void)zip{
    // 创建信号A
    RACSubject *signalA = [RACSubject subject];
    
    // 创建信号B
    RACSubject *signalB = [RACSubject subject];

    // 压缩成一个信号
    // zipWith:当一个界面多个请求的时候,要等所有请求完成才能更新UI
    // zipWith:等所有信号都发送内容的时候才会调用
    RACSignal *zipSignal = [signalA zipWith:signalB];
    
    // 订阅信号
    [zipSignal subscribeNext:^(RACTuple *x) {
        //必须两个信号都发送完数据才会调用block,并且返回值是一个RACTuple
        NSLog(@"%@--%@",x[0],x[1]);
    }];
    
    // 发送数据
    [signalB sendNext:@"下部分数据"];
    [signalA sendNext:@"上部分数据"];
    
}

//merge:把多个信号合并为一个信号，任何一个信号有新值的时候就会调用.
- (void)merge{
    // 创建信号A
    RACSubject *signalA = [RACSubject subject];
    
    // 创建信号B
    RACSubject *signalB = [RACSubject subject];
    
    // 组合信号
    RACSignal *mergeSignal = [signalA merge:signalB];
    
    // 订阅信号
    [mergeSignal subscribeNext:^(id x) {
        
        // 任意一个信号发送内容都会来这个block
        NSLog(@"%@",x);
    }];
    
    // 发送数据
    [signalB sendNext:@"下部分数据"];
    [signalA sendNext:@"上部分数据"];
}

// then:用于连接两个信号，当第一个信号完成，才会连接then返回的信号
// 注意使用then，之前信号的值会被忽略掉.
- (void)then{
    // 创建信号A
    RACSignal *signalA = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        //发送请求
        NSLog(@"发送上部分请求");
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            //请求完成,发送数据
            [subscriber sendNext:@"上部分数据"];
            [subscriber sendCompleted];
        });
        
        
        
        return nil;
    }];
    
    //创建信号B
    RACSignal *signalB = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        //发送信号
        NSLog(@"发送下部分数据");
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            //请求完成,发送数据
            [subscriber sendNext:@"下部分数据"];
        });
        
        
        return nil;
    }];

    // 创建组合信号
    // then:忽悠掉第一个信号所发送的值
    RACSignal *thenSignal = [signalA then:^RACSignal *{
        
        // 返回信号就是需要组合的信号
        return signalB;
    }];
    
    // 订阅信号
    [thenSignal subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
}


//concat:按一定顺序拼接信号，当多个信号发出的时候，有顺序的接收信号。
- (void)concat{
    // 创建信号A
    RACSignal *signalA = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        //发送请求
        NSLog(@"发送上部分请求");
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            //请求完成,发送数据
            [subscriber sendNext:@"上部分数据"];
            [subscriber sendCompleted];
        });
        
        
        
        return nil;
    }];
    
    //创建信号B
    RACSignal *signalB = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        //发送信号
        NSLog(@"发送下部分请求");
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            //请求完成,发送数据
            [subscriber sendNext:@"下部分数据"];
        });
        
        
        return nil;
    }];
    
    // concat:按顺序去连接
    // 注意:concat,第一个信号必须要调用sendCompleted
    // 创建组合信号
    RACSignal *concatSignal = [signalA concat:signalB];
    
    
    // 订阅组合信号
    [concatSignal subscribeNext:^(id x) {
        // 既能拿到A信号的值,又能拿到B信号的值
        //block会调用两次,始终是先拿到第一个信号发送的数据,后拿到第二个信号发送的数据
        NSLog(@"%@",x);
    }];

}














@end
