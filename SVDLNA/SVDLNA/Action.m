//
//  Action.m
//  SVDLNADemo
//
//  Created by  bolizhou on 17/2/7.
//  Copyright © 2017年  bolizhou. All rights reserved.
//

#import "Service.h"
#import "XMLDictionary.h"

@implementation Action

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
        
        NSMutableArray *arguments = [NSMutableArray new];
        NSArray *argumentList = [dictionary arrayValueForKeyPath:@"argumentList.argument"];
        if (argumentList != nil && argumentList.count > 0)
        {
            for (NSDictionary *argument in argumentList)
            {
                Argument *arg = [[Argument alloc] initWithDictionary:argument];
                [arguments addObject:arg];
            }
        }
        _arguments = arguments.copy;
    }
    return self;
}

@end
