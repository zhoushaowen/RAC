//
//  ViewController.m
//  RAC常用的宏
//
//  Created by 周少文 on 16/9/5.
//  Copyright © 2016年 YiXi. All rights reserved.
//

#import "ViewController.h"
#import "ReactiveCocoa.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//1.RAC(TARGET, [KEYPATH, [NIL_VALUE]]):用于给某个对象的某个属性绑定。
    
//    [_textField.rac_textSignal subscribeNext:^(id x) {
//        _label.text = x;
//    }];
    
    // 用来给某个对象的某个属性绑定信号,只要产生信号内容,就会把内容给属性赋值
    RAC(_label,text) = _textField.rac_textSignal;
    
    
//2.RACObserve(self, name):监听某个对象的某个属性,返回的是信号。
    [RACObserve(self.view, frame) subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
    
//3.RACTuplePack：把数据包装成RACTuple（元组类）
    RACTuple *tuple = RACTuplePack(@"123",@456);
    NSLog(@"%@",tuple);
    
    
//4.RACTupleUnpack：把RACTuple（元组类）解包成对应的数据。
    
    // 解包元组，会把元组的值，按顺序给参数里面的变量赋值
    RACTupleUnpack(NSString *key1,NSNumber *key2) = tuple;
    NSLog(@"%@--%@",key1,key2);
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    CGRect rect = self.view.frame;
    rect.origin.y -= 20;
    self.view.frame = rect;
}


@end
