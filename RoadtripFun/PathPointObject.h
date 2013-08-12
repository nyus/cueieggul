//
//  MapAnnationObject.h
//  RoadtripFun
//
//  Created by Huang, Jason on 8/9/13.
//  Copyright (c) 2013 Sihang Huang. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CLLocation;
@interface PathPointObject : NSObject
@property(nonatomic, strong) CLLocation *location;
@property(nonatomic, strong) NSString *title;
@end
