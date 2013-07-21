//
//  APIHelper.h
//  RoadtripFun
//
//  Created by Jason Huang on 7/21/13.
//  Copyright (c) 2013 Sihang Huang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
@class APIHelper;
@protocol APIHelperDelegate <NSObject>
-(void)didRecieveJsonOjbectFromURLConnection:(id)jsonObject;
-(void)didFailWithError:(NSError *)error;
@end


@interface APIHelper : NSObject
@property(nonatomic, assign) id <APIHelperDelegate> delegate;
-(void)cancelConnection;
-(void)launchGoogleMapsRadarSearchWithLocation:(CLLocationCoordinate2D)location
                           radiusInMiles:(CGFloat)radius
                                 keyword:(NSString *)keyword
                                    name:(NSString *)name;
@end
