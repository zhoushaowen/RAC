//
//  ViewController.m
//  RAC在开发中的使用场景
//
//  Created by 周少文 on 16/9/5.
//  Copyright © 2016年 YiXi. All rights reserved.
//

#import "ViewController.h"
#import "ReactiveCocoa.h"
#import "RedView.h"

#import "NSObject+RACKVOWrapper.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet RedView *redView;
@property (weak, nonatomic) IBOutlet UIButton *btn;
@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
#pragma mark - 1.代替代理:1.RACSubject 2.rac_signalForSelector
    // 只要传值,就必须使用RACSubject
    [[_redView rac_signalForSelector:@selector(btnClick:)] subscribeNext:^(RACTuple *x) {
        NSLog(@"控制器知道按钮被点击了------%@",x);
        
    }];
    
    // rac_signalForSelector:监听某对象有没有调用某方法
    [[self rac_signalForSelector:@selector(didReceiveMemoryWarning)] subscribeNext:^(id x) {
        NSLog(@"当前控制器调用了内存警告方法");
    }];
    
#pragma mark - 2.代替KVO
    [_redView rac_observeKeyPath:@"frame" options:NSKeyValueObservingOptionNew observer:nil block:^(id value, NSDictionary *change, BOOL causedByDealloc, BOOL affectedOnlyLastComponent) {
        NSLog(@"11111111%@",value);
    }];
    
    [[_redView rac_valuesAndChangesForKeyPath:@"frame" options:NSKeyValueObservingOptionNew observer:nil] subscribeNext:^(id x) {
        NSLog(@"222222222%@",x);
    }];
    
    //这种方式只要一监听就会调用一次block
    //这个方法内部调用的是上面的rac_valuesAndChangesForKeyPath方法,并且传的参数是:NSKeyValueObservingOptionInitial
    [[_redView rac_valuesForKeyPath:@"frame" observer:nil] subscribeNext:^(id x) {
        NSLog(@"33333333%@",x);
    }];

    
#pragma mark - 3.监听事件
    [[_btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *x) {
        NSLog(@"监听到按钮点击了%@",x);
        x.selected = !x.selected;
    }];
    
    
#pragma mark - 4.代替通知
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillShowNotification object:nil] subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
    
#pragma mark - 5.监听文本框
    [_textField.rac_textSignal subscribeNext:^(id x) {
        NSLog(@"文字改变了:%@",x);
    }];
    
#pragma mark - 6.当一个界面有多次请求时候,需要保证全部都请求完成,才更新界面
    RACSignal *signal1 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        NSLog(@"接口一正在请求数据");
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSLog(@"接口一请求完毕");
            [subscriber sendNext:@"接口一的返回数据"];
        });
        
        return nil;
    }];
    
    RACSignal *signal2 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        NSLog(@"接口二正在请求数据");
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSLog(@"接口二请求完毕");
            [subscriber sendNext:@"接口二的返回数据"];
        });
        
        return nil;
    }];
    
    // 数组:存放信号
    // 当数组中的所有信号都发送数据的时候,才会执行Selector
    // 方法的参数:必须跟数组的信号一一对应
    // 方法的参数:就是每一个信号发送的数据
    [self rac_liftSelector:@selector(updateUIWithData1:data2:) withSignalsFromArray:@[signal1,signal2]];
}

- (void)updateUIWithData1:(NSString *)data1 data2:(NSString *)data2
{
    NSLog(@"更新UI:%@--%@",data1,data2);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    _redView.frame = CGRectMake(0, 0, 100, 100);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
