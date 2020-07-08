//
//  PhotoAnnotation.m
//  PhotoMap
//
//  Created by meganyu on 7/8/20.
//  Copyright © 2020 Codepath. All rights reserved.
//

#import "PhotoAnnotation.h"

#pragma mark - Interface

@interface PhotoAnnotation()

@property (nonatomic) CLLocationCoordinate2D coordinate;

@end

#pragma mark - Implementation

@implementation PhotoAnnotation

- (NSString *)title {
    return [NSString stringWithFormat:@"%f", self.coordinate.latitude];
}

@end
