//
//  APIManager.h
//  PhotoMap
//
//  Created by meganyu on 7/9/20.
//  Copyright © 2020 Codepath. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface APIManager : NSObject

+ (NSString *)getClientID;

+ (NSString *)getClientSecret;

- (void)fetchLocationsWithQuery:(NSString *)query
                       nearCity:(NSString *)city
                     completion:(void(^)(NSArray *results, NSError *error))completion;

@end

NS_ASSUME_NONNULL_END
