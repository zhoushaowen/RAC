//
//  RequestViewModel.m
//  ReactiveCocoa
//
//  Created by 周少文 on 16/9/8.
//  Copyright © 2016年 YiXi. All rights reserved.
//

#import "RequestViewModel.h"
#import "AFNetworking.h"
#import "Book.h"

@implementation RequestViewModel

- (instancetype)init
{
    self = [super init];
    if(self)
    {
        [self setup];
    }
    
    return self;
}

- (void)setup {
    
    _requestCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            
            //发送请求
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            NSString *urlStr = @"https://api.douban.com/v2/book/search";
            [manager GET:urlStr parameters:@{@"q":@"历史"} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary*  _Nullable responseObject) {
//                NSLog(@"%@",responseObject);
                
                [responseObject writeToFile:@"/Users/zhoushaowen/Desktop/responseObject.plist" atomically:YES];
                NSArray *array = responseObject[@"books"];
                //映射对象
                NSArray *books = [array.rac_sequence map:^id(id value) {
                   
                    Book *model = [[Book alloc] init];
                    return model;
                    
                }].array;
                //发送数据
                [subscriber sendNext:books];
                //发送完成
                [subscriber sendCompleted];
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                //发送数据
                [subscriber sendError:error];
                //发送完成
                [subscriber sendCompleted];
                
            }];
            
            return nil;
        }];
    }];
    
}

@end
