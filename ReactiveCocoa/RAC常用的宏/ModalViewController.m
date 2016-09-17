//
//  ModalViewController.m
//  ReactiveCocoa
//
//  Created by 周少文 on 16/9/5.
//  Copyright © 2016年 YiXi. All rights reserved.
//

#import "ModalViewController.h"
#import "ReactiveCocoa.h"

@interface ModalViewController ()

@property (nonatomic,strong) RACSignal *signal;

@end

@implementation ModalViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    //5.@weakify(Obj)和@strongify(Obj),一般两个都是配套使用,解决循环引用问题.

    @weakify(self)
    
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self)
        
        
        NSLog(@"%@",self);
        return nil;
    }];
    
    _signal = signal;
}

- (IBAction)dismiss:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)dealloc
{
    NSLog(@"%s",__func__);
}

@end
