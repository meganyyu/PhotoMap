//
//  LocationsViewController.m
//  PhotoMap
//
//  Created by emersonmalca on 7/8/18.
//  Copyright © 2018 Codepath. All rights reserved.
//

#import "LocationsViewController.h"

#import "LocationCell.h"

static NSString *const kbaseAPIURLString = @"https://api.foursquare.com/v2/venues/search?";
static NSString *const kClientID = @"Client ID";
static NSString *const kClientSecretID = @"Client Secret";
static NSString *const kInfoPlistID = @"Info";

static NSString *const hardCodedClientID = @"44XEIAQRYL4AKWNNTGI32IGCSNQ1HIRL1M0WQOCW4NWTXQTA";
static NSString *const hardCodedClientSecret = @"PSCQOIHYHPIXERW1YFI1UZCFNB0GDE4ZBYSDIXMLW4Z3EGIS";

#pragma mark - Interface

@interface LocationsViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *const tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *const searchBar;
@property (strong, nonatomic) NSArray *const results;

@end

#pragma mark - Implementation

@implementation LocationsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.searchBar.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.results.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LocationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LocationCell" forIndexPath:indexPath];
    [cell updateWithLocation:_results[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // This is the selected venue
    NSDictionary *venue = self.results[indexPath.row];
    NSNumber *lat = [venue valueForKeyPath:@"location.lat"];
    NSNumber *lng = [venue valueForKeyPath:@"location.lng"];
    NSLog(@"%@, %@", lat, lng);
    
    [_delegate locationsViewController:self didPickLocationWithLatitude:lat longitude:lng];
}

#pragma mark - Search Bar

// FIXME: move to its own API Manager later
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

- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    NSString *newText = [searchBar.text stringByReplacingCharactersInRange:range withString:text];
    [self fetchLocationsWithQuery:newText nearCity:@"San Francisco"];
    return true;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self fetchLocationsWithQuery:searchBar.text nearCity:@"San Francisco"];
}

- (void)fetchLocationsWithQuery:(NSString *)query nearCity:(NSString *)city {
    
    NSString *const clientID = [LocationsViewController getClientID];
    NSString *const clientSecret = [LocationsViewController getClientSecret];
    
    // Testing logs for FIXME
    NSLog(@"clientID is? %@. clientSecret is? %@", clientID, clientSecret);
    NSLog(@"hardCodedClientID is? %@. hardCodedClientSecret is? %@", clientID, clientSecret);
    NSLog(@"clientID is equal to hardCodedClientID? %d", [clientID isEqualToString:hardCodedClientID]);
    NSLog(@"clientSecret is equal to hardCodedClientSecret? %d", [clientSecret isEqualToString:hardCodedClientSecret]);
    
    NSString *queryString = [NSString stringWithFormat:@"client_id=%@&client_secret=%@&v=20141020&near=%@,CA&query=%@", clientID, clientSecret, city, query];
    queryString = [queryString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSURL *const url = [NSURL URLWithString:[kbaseAPIURLString stringByAppendingString:queryString]];
    NSURLRequest *const request = [NSURLRequest requestWithURL:url];
    
    NSURLSession *const session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *const task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data) {
            NSDictionary *const responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            NSLog(@"response: %@", responseDictionary);
            self.results = [responseDictionary valueForKeyPath:@"response.venues"];
            [self.tableView reloadData];
        }
    }];
    [task resume];
}

@end
