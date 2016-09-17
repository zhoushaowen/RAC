//
//  ViewController.m
//  RAC集合
//
//  Created by 周少文 on 16/9/4.
//  Copyright © 2016年 YiXi. All rights reserved.
//

#import "ViewController.h"
#import "ReactiveCocoa.h"
#import "Flag.h"

@interface ViewController ()

@end

@implementation ViewController

/*
 RACTuple:元组类,类似NSArray,用来包装值.
 RACSequence:RAC中的集合类，用于代替NSArray,NSDictionary,可以使用它来快速遍历数组和字典。
 */

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self tuple];
//    [self arr];
//    [self dic];
    [self dicToModel];
}

//字典转模型
- (void)dicToModel
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"flags.plist" ofType:nil];
    NSArray *array = [NSArray arrayWithContentsOfFile:path];
    
//    NSMutableArray *mutableArr = [NSMutableArray array];
//    [array.rac_sequence.signal subscribeNext:^(NSDictionary *x) {
//        Flag *model = [[Flag alloc] initWithDictionary:x];
//        [mutableArr addObject:model];
//    }];
//    //研究发现:mutableArr一开始是空的,只有等上面的block执行完才有值
//    NSLog(@"%@",mutableArr);
    
    //高级用法
    // 会把集合中所有元素都映射成一个新的对象
    NSArray *arr = [array.rac_sequence map:^id(NSDictionary *value) {
        return [[Flag alloc] initWithDictionary:value];
    }].array;
    
    NSLog(@"%@",arr);
}


- (void)dic
{
    NSDictionary *dic = @{@"name":@"zhangsan",@"age":@18};
    
    //转换成集合
    [dic.rac_sequence.signal subscribeNext:^(RACTuple *x) {
        //遍历字典,内部会将x转换成RACTuple类
//        NSLog(@"%@",x);
//        NSString *key = x[0];
//        NSString *value = x[1];
//        NSLog(@"%@----%@",key,value);
        
        //也可以利用下面的宏,实现快速写法
        RACTupleUnpack(NSString *key,NSString *value) = x;
        NSLog(@"%@---%@",key,value);
    }];
}

- (void)arr
{
    NSArray *array = @[@"123",@"456",@111];
    
//    // RAC集合
//    RACSequence *sequence = array.rac_sequence;
//    
//    // 把集合转换成信号
//    RACSignal *signal = sequence.signal;
//    
//    // 订阅集合信号,内部会自动遍历所有的元素发出来
//    [signal subscribeNext:^(id x) {
//        NSLog(@"%@",x);
//    }];
    
    //快速写法
    [array.rac_sequence.signal subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
}

- (void)tuple
{
    //将OC数组转换成RAC元祖
    RACTuple *tuple = [RACTuple tupleWithObjectsFromArray:@[@"123",@"456",@111]];
    NSString *str = tuple[0];
    NSLog(@"%@",str);
}








@end
