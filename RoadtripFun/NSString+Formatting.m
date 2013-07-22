//
//  NSString+Formatting.m
//  RoadtripFun
//
//  Created by Jason Huang on 7/21/13.
//  Copyright (c) 2013 Sihang Huang. All rights reserved.
//

#import "NSString+Formatting.h"
#define RadarSearchURL @"https://maps.googleapis.com/maps/api/place/radarsearch/json?sensor=false&"
#define NearbySearchURL @"https://maps.googleapis.com/maps/api/place/nearbysearch/json?sensor=false&"

@implementation NSString (Formatting)
+(NSString *)formatRadarSearchStringWithLocation:(CLLocationCoordinate2D)location radiusInMiles:(CGFloat)radius keyword:(NSString *)keyword name:(NSString *)name{
    //google api takes meter but not mile
    NSString *urlString = [RadarSearchURL stringByAppendingFormat:@"key=%@&location=%f,%f&radius=%f",GMapsWebServiceKey,location.latitude,location.longitude,radius*1609.44];
    if (keyword!=nil) {
        urlString = [urlString stringByAppendingFormat:@"&keyword=%@",keyword];
    }
    if (name!=nil) {
        urlString = [urlString stringByAppendingFormat:@"&name=%@",name];
    }
    return [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];;
}

+(NSString *)formatNearbySearchStringWithLocation:(CLLocationCoordinate2D)location radiusInMiles:(CGFloat)radius keyword:(NSString *)keyword name:(NSString *)name{
    //google api takes meter but not mile
    NSString *urlString = [NearbySearchURL stringByAppendingFormat:@"key=%@&location=%f,%f&radius=%f",GMapsWebServiceKey,location.latitude,location.longitude,radius*1609.44];
    if (keyword!=nil) {
        urlString = [urlString stringByAppendingFormat:@"&keyword=%@",keyword];
    }
    if (name!=nil) {
        urlString = [urlString stringByAppendingFormat:@"&name=%@",name];
    }
    return [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];;
}
@end
