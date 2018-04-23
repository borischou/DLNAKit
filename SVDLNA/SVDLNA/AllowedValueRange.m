//
//  AllowedValueRange.m
//  SVDLNADemo
//
//  Created by  bolizhou on 17/2/8.
//  Copyright © 2017年  bolizhou. All rights reserved.
//

#import "Service.h"
#import "XMLDictionary.h"

@implementation AllowedValueRange

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self)
    {
        if (dictionary == nil)
        {
            return nil;
        }
        _minimum = [dictionary stringValueForKeyPath:@"minimum"];
        _maximum = [dictionary stringValueForKeyPath:@"maximum"];
        _step = [dictionary stringValueForKeyPath:@"step"];
    }
    return self;
}

@end
