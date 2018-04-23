//
//  Argument.m
//  SVDLNADemo
//
//  Created by  bolizhou on 17/2/7.
//  Copyright © 2017年  bolizhou. All rights reserved.
//

#import "Service.h"
#import "XMLDictionary.h"

@implementation Argument

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self)
    {
        if (dictionary == nil)
        {
            return nil;
        }
        _name = [dictionary stringValueForKeyPath:@"name"];
        _direction = [dictionary stringValueForKeyPath:@"direction"];
        _relatedStateVariable = [dictionary stringValueForKeyPath:@"relatedStateVariable"];
    }
    return self;
}

@end
