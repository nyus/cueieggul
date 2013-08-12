//
//  LocationPoint.h
//  RoadtripFun
//
//  Created by Huang, Jason on 8/12/13.
//  Copyright (c) 2013 Sihang Huang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface PathPoint : NSManagedObject

@property (nonatomic, retain) NSDate * dateCreated;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;

@end
