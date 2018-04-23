//
//  SsdpResponseHeader.m
//  SVDLNADemo
//
//  Created by  bolizhou on 17/2/6.
//  Copyright © 2017年  bolizhou. All rights reserved.
//

#import "Device.h"
#import "NSString+Ext.h"

#define SSDP_SEARCH_RESP_HEADER_PREFIX_HTTP @"http/1.1"
#define SSDP_SEARCH_RESP_HEADER_PREFIX_LOCATION @"location:"
#define SSDP_SEARCH_RESP_HEADER_PREFIX_CACHE_CONTROL @"cache-control:"
#define SSDP_SEARCH_RESP_HEADER_PREFIX_SERVER @"server:"
#define SSDP_SEARCH_RESP_HEADER_PREFIX_DATE @"date:"
#define SSDP_SEARCH_RESP_HEADER_PREFIX_BOOTID_UPNP_ORG @"bootid.upnp.org:"
#define SSDP_SEARCH_RESP_HEADER_PREFIX_CONFIGID_UPNP_ORG @"configid.upnp.org:"
#define SSDP_SEARCH_RESP_HEADER_PREFIX_USN @"usn:"
#define SSDP_SEARCH_RESP_HEADER_PREFIX_ST @"st:"

@implementation SsdpResponseHeader

- (instancetype)initWithReceivedMsg:(NSString *)message
{
    self = [super init];
    
    if (self)
    {
        if (message == nil || message.length == 0)
        {
            return nil;
        }
        
        [message enumerateLinesUsingBlock:^(NSString * _Nonnull line, BOOL * _Nonnull stop) {
            NSArray *items = nil;
            NSString *lowercaseLine = [line lowercaseString];
            if ([lowercaseLine hasPrefix:SSDP_SEARCH_RESP_HEADER_PREFIX_HTTP])
            {
                items = [lowercaseLine componentsSeparatedByString:@" "];
                _statusCode = [items objectAtIndex:1];
            }
            else
            {
                if ([lowercaseLine hasPrefix:SSDP_SEARCH_RESP_HEADER_PREFIX_LOCATION])
                {
                    _location = [self ssdpValueForKey:SSDP_SEARCH_RESP_HEADER_PREFIX_LOCATION lowercaseLine:lowercaseLine];
                    _address = [self addressFromString:_location];
                }
                else if ([lowercaseLine hasPrefix:SSDP_SEARCH_RESP_HEADER_PREFIX_DATE])
                {
                    _date = [self ssdpValueForKey:SSDP_SEARCH_RESP_HEADER_PREFIX_DATE lowercaseLine:lowercaseLine];
                }
                else if ([lowercaseLine hasPrefix:SSDP_SEARCH_RESP_HEADER_PREFIX_CACHE_CONTROL])
                {
                    NSString *maxAgeStr = [self ssdpValueForKey:SSDP_SEARCH_RESP_HEADER_PREFIX_CACHE_CONTROL lowercaseLine:lowercaseLine];
                    _maxAge = [maxAgeStr substringFromIndex:8];
                }
                else if ([lowercaseLine hasPrefix:SSDP_SEARCH_RESP_HEADER_PREFIX_SERVER])
                {
                    _server = [self ssdpValueForKey:SSDP_SEARCH_RESP_HEADER_PREFIX_SERVER lowercaseLine:lowercaseLine];
                }
                else if ([lowercaseLine hasPrefix:SSDP_SEARCH_RESP_HEADER_PREFIX_BOOTID_UPNP_ORG])
                {
                    _bootid_upnp_org = [self ssdpValueForKey:SSDP_SEARCH_RESP_HEADER_PREFIX_BOOTID_UPNP_ORG lowercaseLine:lowercaseLine];
                }
                else if ([lowercaseLine hasPrefix:SSDP_SEARCH_RESP_HEADER_PREFIX_CONFIGID_UPNP_ORG])
                {
                    _configid_upnp_org = [self ssdpValueForKey:SSDP_SEARCH_RESP_HEADER_PREFIX_CONFIGID_UPNP_ORG lowercaseLine:lowercaseLine];
                }
                else if ([lowercaseLine hasPrefix:SSDP_SEARCH_RESP_HEADER_PREFIX_USN])
                {
                    _usn = [self ssdpValueForKey:SSDP_SEARCH_RESP_HEADER_PREFIX_USN lowercaseLine:lowercaseLine];
                }
                else if ([lowercaseLine hasPrefix:SSDP_SEARCH_RESP_HEADER_PREFIX_ST])
                {
                    _st = [self ssdpValueForKey:SSDP_SEARCH_RESP_HEADER_PREFIX_ST lowercaseLine:lowercaseLine];
                }
            }
        }];
    }
    
    return self;
}

- (Address *)addressFromString:(NSString *)location
{
    if (location == nil || location.length == 0 || [location containsString:@":"] == NO || [location containsString:@"."] == NO)
    {
        return nil;
    }
    Address *address = [Address new];
    
    NSArray *subs = [location componentsSeparatedByString:@":"];
    if (subs.count < 2)
    {
        return nil;
    }
    if (subs.count == 2)
    {
        if ([subs.firstObject hasPrefix:@"http"])
        {
            return nil;
        }
        address.ipv4 = [subs.firstObject trimmedString];
    }
    if (subs.count >= 3)
    {
        if ([subs.firstObject hasPrefix:@"http"])
        {
            address.ipv4 = [[subs objectAtIndex:1] substringFromIndex:2];
            address.port = [self portFromString:[subs objectAtIndex:2]];
        }
        else
        {
            address.ipv4 = subs.firstObject;
            address.port = [self portFromString:[subs objectAtIndex:1]];
        }
    }
    
    return address;
}

- (NSString *)portFromString:(NSString *)str
{
    if (str == nil  || str.length == 0)
    {
        return nil;
    }
    NSString *trim = str.trimmedString;
    NSMutableString *mutStr = [NSMutableString new];
    for (int i = 0; i < trim.length; i ++)
    {
        char ch = [trim characterAtIndex:i];
        if (ch == '/')
        {
            break;
        }
        if (ch >= '0' && ch <= '9')
        {
            [mutStr appendString:[NSString stringWithFormat:@"%c", ch]];
        }
    }
    return mutStr.copy;
}

- (NSString *)ssdpValueForKey:(NSString *)key lowercaseLine:(NSString *)line
{
    NSInteger endIdx = key.length-1;
    NSString *value = [[line substringFromIndex:endIdx+1] trimmedString];
    return value;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"http/1.1: %@\nlocation: %@\ncache-control: max-age=%@\nserver: %@\nbootid_upnp_org: %@\nconfigid_upnp_org: %@\nusn: %@\nst: %@", self.statusCode, self.location, self.maxAge, self.server, self.bootid_upnp_org, self.configid_upnp_org, self.usn, self.st];
}

@end
