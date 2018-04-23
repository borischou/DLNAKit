//
//  ServiceDescription.m
//  SVDLNADemo
//
//  Created by  bolizhou on 17/2/7.
//  Copyright © 2017年  bolizhou. All rights reserved.
//

#import "Service.h"
#import "XMLDictionary.h"

@implementation ServiceDescription

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self)
    {
        if (dictionary == nil)
        {
            return nil;
        }
        
        NSMutableArray *actions = [NSMutableArray new];
        NSArray *actionList = [dictionary arrayValueForKeyPath:@"actionList.action"];
        if (actionList != nil && actionList.count > 0)
        {
            for (NSDictionary *action in actionList)
            {
                Action *act = [[Action alloc] initWithDictionary:action];
                [actions addObject:act];
            }
        }
        _actions = actions.copy;
    }
    return self;
}

@end
