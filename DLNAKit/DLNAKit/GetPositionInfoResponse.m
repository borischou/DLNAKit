//
//  GetPositionInfoResponse.m
//  DLNAKit
//
//  Created by  bolizhou on 2017/3/16.
//  Copyright © 2017年 Silver Fox. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Service.h"
#import "XMLDictionary.h"

@implementation GetPositionInfoResponse

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
            _absTime = [body stringValueForKeyPath:@"u:GetPositionInfoResponse.AbsTime"];
            _absCount = [body stringValueForKeyPath:@"u:GetPositionInfoResponse.AbsCount"];
            _relTime = [body stringValueForKeyPath:@"u:GetPositionInfoResponse.RelTime"];
            _relCount = [body stringValueForKeyPath:@"u:GetPositionInfoResponse.RelCount"];
            _track = [body stringValueForKeyPath:@"u:GetPositionInfoResponse.Track"];
            _trackDuration = [body stringValueForKeyPath:@"u:GetPositionInfoResponse.TrackDuration"];
            _trackMetaData = [body stringValueForKeyPath:@"u:GetPositionInfoResponse.TrackMetaData"];
        }
    }
    return self;
}

@end
