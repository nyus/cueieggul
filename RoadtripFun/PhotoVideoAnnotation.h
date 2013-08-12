//
//  PhotoVideoAnnotation.h
//  RoadtripFun
//
//  Created by Huang, Jason on 8/12/13.
//  Copyright (c) 2013 Sihang Huang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface PhotoVideoAnnotation : NSObject<MKAnnotation>
@property(nonatomic) CLLocationCoordinate2D location;
@property(nonatomic, strong) NSMutableArray *arrayOfThumnailUrls;
@property(nonatomic, strong) NSMutableArray *arrayOfHighResPhotoUrls;
@end
