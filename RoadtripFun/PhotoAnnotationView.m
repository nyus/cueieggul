//
//  PhotoAnnotationView.m
//  RoadtripFun
//
//  Created by Huang, Jason on 8/26/13.
//  Copyright (c) 2013 Sihang Huang. All rights reserved.
//

#import "PhotoAnnotationView.h"

@implementation PhotoAnnotationView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    UIView *background = [[UIView alloc] initWithFrame:CGRectMake(rect.origin.x,
                                                                 rect.origin.y,
                                                                 80,
                                                                 80)];
}

@end
