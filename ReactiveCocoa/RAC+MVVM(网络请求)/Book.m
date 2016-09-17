//
//  Book.m
//  ReactiveCocoa
//
//  Created by 周少文 on 16/9/8.
//  Copyright © 2016年 YiXi. All rights reserved.
//

#import "Book.h"

@implementation Book

- (instancetype)initWithDictionaray:(NSDictionary *)dic
{
    self = [super init];
    if(self)
    {
        [self setValuesForKeysWithDictionary:dic];
    }
    
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

@end
