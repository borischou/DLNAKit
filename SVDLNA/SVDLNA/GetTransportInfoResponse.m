//
//  GetTransportInfoResponse.m
//  SVDLNA
//
//  Created by Silver Fox on 17/3/15.
//  Copyright © 2017年 Silver Fox. All rights reserved.
//

#import "Service.h"
#import "XMLDictionary.h"
#import "UPnPManager.h"

@implementation GetTransportInfoResponse

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self)
    {
        NSDictionary *body = [dictionary dictionaryValueForKeyPath:@"s:Body"];
        if (body)
        {
            _currentSpeed = [body stringValueForKeyPath:@"u:GetTransportInfoResponse.CurrentSpeed"];
            NSString *state = [body stringValueForKeyPath:@"u:GetTransportInfoResponse.CurrentTransportState"];
            _currentTransportState = [[UPnPManager sharedManager] transportStateWith:state];
            _currentTransportStatus = [body stringValueForKeyPath:@"u:GetTransportInfoResponse.CurrentTransportStatus"];
        }
    }
    return self;
}

- (instancetype)initWithData:(NSData *)data
{
    self = [super init];
    if (self)
    {
        if (data == nil)
        {
            return nil;
        }
        NSDictionary *dict = [NSDictionary dictionaryWithXMLData:data];
        NSDictionary *body = [dict dictionaryValueForKeyPath:@"s:Body"];
        if (body)
        {
            _currentSpeed = [body stringValueForKeyPath:@"u:GetTransportInfoResponse.CurrentSpeed"];
            NSString *state = [body stringValueForKeyPath:@"u:GetTransportInfoResponse.CurrentTransportState"];
            _currentTransportState = [[UPnPManager sharedManager] transportStateWith:state];
            _currentTransportStatus = [body stringValueForKeyPath:@"u:GetTransportInfoResponse.CurrentTransportStatus"];
        }
    }
    return self;
}

@end
