//
//  MapAnnationObject.h
//  RoadtripFun
//
//  Created by Huang, Jason on 8/9/13.
//  Copyright (c) 2013 Sihang Huang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
@interface MapAnnationObject : NSObject<MKAnnotation>
@property(nonatomic)CLLocationCoordinate2D coordinate;
@property(nonatomic, strong) NSString *title;
@end
