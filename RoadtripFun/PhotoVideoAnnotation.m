//
//  PhotoVideoAnnotation.m
//  RoadtripFun
//
//  Created by Huang, Jason on 8/12/13.
//  Copyright (c) 2013 Sihang Huang. All rights reserved.
//

#import "PhotoVideoAnnotation.h"

@implementation PhotoVideoAnnotation
- (id)initWithLocation:(CLLocationCoordinate2D)coord{
    self = [super init];
    if (self) {
        self.coordinate = coord;
    }
    
    return self;
}
@end
