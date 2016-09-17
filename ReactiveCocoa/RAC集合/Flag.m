
//
//  Flag.m
//  ReactiveCocoa
//
//  Created by 周少文 on 16/9/4.
//  Copyright © 2016年 YiXi. All rights reserved.
//

#import "Flag.h"

@implementation Flag

- (instancetype)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    if(self)
    {
        [self setValuesForKeysWithDictionary:dic];
    }
    
    return self;
}

@end
