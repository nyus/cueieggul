//
//  NSString+Formatting.h
//  RoadtripFun
//
//  Created by Jason Huang on 7/21/13.
//  Copyright (c) 2013 Sihang Huang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface NSString (Formatting)
+(NSString *)formatRadarSearchStringWithLocation:(CLLocationCoordinate2D)location
                                   radiusInMiles:(CGFloat)radius
                                         keyword:(NSString *)keyword
                                            name:(NSString *)name;
@end
