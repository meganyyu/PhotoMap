//
//  APIManager.m
//  PhotoMap
//
//  Created by meganyu on 7/9/20.
//  Copyright © 2020 Codepath. All rights reserved.
//

#import "APIManager.h"

static NSString *const kbaseAPIURLString = @"https://api.foursquare.com/v2/venues/search?";
static NSString *const kClientID = @"Client ID";
static NSString *const kClientSecretID = @"Client Secret";
static NSString *const kInfoPlistID = @"Info";
static NSString *const kResponseVenuesKey = @"response.venues";

@implementation APIManager

+ (NSString *)getClientID {
    NSDictionary *const dictionary = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:kInfoPlistID ofType:@"plist"]];
    NSString *const clientID = (NSString *)[dictionary objectForKey:kClientID];
    return clientID;
}

+ (NSString *)getClientSecret {
    NSDictionary *const dictionary = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:kInfoPlistID ofType:@"plist"]];
    NSString *const clientSecret = (NSString *)[dictionary objectForKey:kClientSecretID];
    return clientSecret;
}

- (void)fetchLocationsWithQuery:(NSString *)query
                       nearCity:(NSString *)city
                     completion:(void(^)(NSArray *results, NSError *error))completion {
    NSString *const clientID = [APIManager getClientID];
    NSString *const clientSecret = [APIManager getClientSecret];
    
    NSString *queryString = [NSString stringWithFormat:@"client_id=%@&client_secret=%@&v=20141020&near=%@,CA&query=%@", clientID, clientSecret, city, query];
    queryString = [queryString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSURL *const url = [NSURL URLWithString:[kbaseAPIURLString stringByAppendingString:queryString]];
    NSURLRequest *const request = [NSURLRequest requestWithURL:url];
    
    NSURLSession *const session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *const task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data) {
            NSDictionary *const responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            NSLog(@"response: %@", responseDictionary);
            completion([responseDictionary valueForKeyPath:kResponseVenuesKey], nil);
        } else {
            completion(nil, error);
        }
    }];
    [task resume];
}

@end
