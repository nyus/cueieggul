//
//  AnnotationPoint.h
//  RoadtripFun
//
//  Created by Huang, Jason on 8/12/13.
//  Copyright (c) 2013 Sihang Huang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface PhotoAnnotation : NSManagedObject

@property (nonatomic, retain) NSString * dateCreated;
@property (nonatomic, retain) id imageFilePathArray;
@property (nonatomic, retain) NSString * latitude;
@property (nonatomic, retain) NSString * longitude;
@property (nonatomic, retain) id thumnailFilePathArray;

@end
