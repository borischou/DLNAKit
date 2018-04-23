//
//  NSString+Ext.m
//  SVDLNADemo
//
//  Created by  bolizhou on 17/2/7.
//  Copyright © 2017年  bolizhou. All rights reserved.
//

#import "NSString+Ext.h"

@implementation NSString (Ext)

- (NSString *)trimmedString
{
    NSString *trimmedString = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return [trimmedString length] ? trimmedString : nil;
}

@end
